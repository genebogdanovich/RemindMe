//
//  ReminderManagedObject+.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import CoreData

extension ReminderManagedObject {
    static func save(reminderToSave: Reminder, inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        
        let item = self.init(context: managedObjectContext)
        item.name = reminderToSave.name
        item.date = reminderToSave.date
        item.isCompleted = reminderToSave.isCompleted
        item.id = reminderToSave.id
        item.url = reminderToSave.url
        item.note = reminderToSave.note
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}

extension Collection where Element == ReminderManagedObject, Index == Int {
    func delete(at indices: IndexSet, inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        indices.forEach { index in
            managedObjectContext.delete(self[index])
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}
