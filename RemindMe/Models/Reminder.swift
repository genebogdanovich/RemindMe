//
//  Reminder.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation

struct Reminder: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var isCompleted: Bool
    var name: String
    var note: String?
    var url: URL?
    
    init(id: UUID, isCompleted: Bool, name: String, date: Date, note: String?, url: URL?) {
        self.id = id
        self.date = date
        self.isCompleted = isCompleted
        self.name = name
        self.note = note
        self.url = url
    }
}
