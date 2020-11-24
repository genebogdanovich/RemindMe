//
//  ReminderManagedObject+.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import CoreData

extension ReminderManagedObject {
    func mapToReminder() -> Reminder {
        Reminder(
            id: id ?? UUID(),
            isCompleted: isCompleted,
            name: name ?? "New Reminder",
            date: date ?? Date(),
            note: note,
            url: url)
    }
}
