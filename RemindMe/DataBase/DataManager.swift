//
//  DataManager.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import CoreData

protocol DataManager {
    func fetchReminderList(includingCompleted: Bool) -> [Reminder]
    func addReminder(date: Date, name: String, note: String?, url: URL?)
    func toggleIsCompleted(for reminder: Reminder)
    func deleteReminders(at indices: IndexSet)
}

extension DataManager {
    func fetchReminderList(includingCompleted: Bool = false) -> [Reminder] {
        fetchReminderList(includingCompleted: includingCompleted)
    }
}

class ReminderDataManager {
    static let shared: DataManager = ReminderDataManager()
    
    var dbHelper: CoreDataHelper = CoreDataHelper.shared
    
    private var reminders = [Reminder]()
    
    private init() {}
    
    /// Takes a Reminder object and fetches ReminderManagedObject from CoreData based on Reminder’s id.
    private func getReminderManagedObject(for reminder: Reminder) -> ReminderManagedObject? {
        
        let predicate = NSPredicate(format: "id = %@", reminder.id as CVarArg)
        
        let result = dbHelper.fetchFirst(ReminderManagedObject.self, predicate: predicate)
        
        switch result {
        case .success(let reminderManagedObject):
            
            return reminderManagedObject
        case .failure(_):
            return nil
        }
    }
}

// MARK: - DataManagerProtocol
extension ReminderDataManager: DataManager {
    
    func fetchReminderList(includingCompleted: Bool = false) -> [Reminder] {
        let predicate = includingCompleted ? nil : NSPredicate(format: "isCompleted == false")
        let result: Result<[ReminderManagedObject], Error> = dbHelper.fetch(ReminderManagedObject.self, predicate: predicate)
        switch result {
        case .success(let reminderManagedObject):
            // Here we map our ReminderManagedObjects to Reminder type and return it. Genius!
            return reminderManagedObject.map { $0.mapToReminder() }
        case .failure(let error):
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
    
    
    func addReminder(date: Date, name: String, note: String?, url: URL?) {
        
        
        let entity = ReminderManagedObject.entity()
        let newReminder = ReminderManagedObject(entity: entity, insertInto: dbHelper.context)
        newReminder.id = UUID()
        newReminder.name = name
        newReminder.date = date
        newReminder.note = note
        newReminder.url = url
        newReminder.isCompleted = false
        dbHelper.create(newReminder) // All this does is it saves our ManagedObjectContext.
    }
    
    func toggleIsCompleted(for reminder: Reminder) {
        guard let reminderManagedObject = getReminderManagedObject(for: reminder) else { return }
        
        reminderManagedObject.isCompleted.toggle()
        dbHelper.update(reminderManagedObject)
    }
    
    func deleteReminders(at indices: IndexSet) {
        let result = dbHelper.fetch(ReminderManagedObject.self, atIndex: indices)
        
        switch result {
        case .success(let reminderManagedObjectToDelete):
            
            dbHelper.delete(reminderManagedObjectToDelete!)
            
        case .failure(let error):
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
        
        
    }
}
