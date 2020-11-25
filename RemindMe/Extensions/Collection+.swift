//
//  Collection+.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 25.11.20.
//

import Foundation
import CoreData

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
