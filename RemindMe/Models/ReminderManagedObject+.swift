//
//  ReminderManagedObject+.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import CoreData
import UIKit

extension ReminderManagedObject {
    func mapToReminder() -> Reminder {
        
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            return Reminder(
                id: id,
                isCompleted: isCompleted,
                name: name ?? "New Reminder",
                date: date ?? Date(),
                note: note,
                url: url,
                image: uiImage)
        } else {
            return Reminder(
                id: id,
                isCompleted: isCompleted,
                name: name ?? "New Reminder",
                date: date ?? Date(),
                note: note,
                url: url,
                image: nil)
        }
    }
}
