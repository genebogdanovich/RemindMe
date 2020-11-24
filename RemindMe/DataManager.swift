//
//  DataManager.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func fetchReminderList(includingCompleted: Bool) -> [Reminder]
    func addReminder(date: Date, name: String, note: String?, url: URL?)
    func toggleIsCompleted(for reminder: Reminder)
}

extension DataManagerProtocol {
    func fetchReminderList(includingCompleted: Bool = false) -> [Reminder] {
        fetchReminderList(includingCompleted: includingCompleted)
    }
}

class DataManager {
    static let shared: DataManagerProtocol = DataManager()
    
    var dbHelper: CoreDataHelper = CoreDataHelper.shared
    
    private var reminders = [Reminder]()
    
    private init() {}
    
    private func getReminderManagedObject(for reminder: Reminder) -> ReminderManagedObject? {
        let predicate = NSPredicate(format: "uuid = %@", reminder.id as CVarArg)
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
extension DataManager: DataManagerProtocol {
    func fetchReminderList(includingCompleted: Bool = false) -> [Reminder] {
        let predicate = includingCompleted ? nil : NSPredicate(format: "isCompleted == false")
        let result: Result<[ReminderManagedObject], Error> = dbHelper.fetch(ReminderManagedObject.self, predicate: predicate)
        switch result {
        case .success(let reminderManagedObject):
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
        dbHelper.create(newReminder)
    }
    
    func toggleIsCompleted(for reminder: Reminder) {
        guard let reminderManagedObject = getReminderManagedObject(for: reminder) else { return }
        reminderManagedObject.isCompleted.toggle()
        dbHelper.update(reminderManagedObject)
    }
}
