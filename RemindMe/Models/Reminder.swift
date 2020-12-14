//
//  Reminder.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import UIKit

struct Reminder: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var isCompleted: Bool
    var name: String
    var note: String?
    var url: URL?
    var image: UIImage?
    var isFlagged: Bool
    var priority: Int16
    
    init(id: UUID, isCompleted: Bool, name: String, date: Date, note: String?, url: URL?, image: UIImage?, isFlagged: Bool, priority: Int16) {
        self.id = id
        self.date = date
        self.isCompleted = isCompleted
        self.name = name
        self.note = note
        self.url = url
        self.image = image
        self.isFlagged = isFlagged
        self.priority = priority
    }
}

//@objc enum ReminderPriority: Int16 {
//    case none = 0
//    case low = 1
//    case medium = 2
//    case high = 3
//}
