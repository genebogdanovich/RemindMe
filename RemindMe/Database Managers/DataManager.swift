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
    func add(_ reminder: Reminder)
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
    
    func add(_ reminder: Reminder) {
        
        // First we check if we already have that reminder. If we do, we update it.
        guard let existingReminder = getReminderManagedObject(for: reminder) else {
            // If the reminder doesn’t exist, create it!
            let entity = ReminderManagedObject.entity()
            let newReminder = ReminderManagedObject(entity: entity, insertInto: dbHelper.context)
            newReminder.isFlagged = reminder.isFlagged
            newReminder.id = reminder.id
            newReminder.name = reminder.name
            newReminder.date = reminder.date
            newReminder.note = reminder.note
            newReminder.url = reminder.url
            newReminder.isCompleted = reminder.isCompleted
            newReminder.imageData = reminder.image?.jpegData(compressionQuality: 1)
            newReminder.priority = reminder.priority
            dbHelper.create(newReminder) // All this does is it saves our ManagedObjectContext.
            return
        }
        existingReminder.isFlagged = reminder.isFlagged
        existingReminder.date = reminder.date
        existingReminder.name = reminder.name
        existingReminder.note = reminder.note
        existingReminder.url = reminder.url
        existingReminder.imageData = reminder.image?.jpegData(compressionQuality: 1)
        existingReminder.priority = reminder.priority
        dbHelper.update(existingReminder)
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
