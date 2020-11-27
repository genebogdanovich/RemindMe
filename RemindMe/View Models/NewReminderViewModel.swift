//
//  NewReminderViewModel.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import Combine

protocol NewReminderViewModelProtocol {
    func addNew(_ reminder: Reminder)
}

//struct NewReminderViewState {
//    var name: String = "New Reminder"
//    var note: String = ""
//    var date: Date = Date()
//    var urlString = ""
//}

final class NewReminderViewModel: ObservableObject {
    var dataManager: DataManager
//    var newReminderViewState = NewReminderViewState()
    
    init(dataManager: DataManager = ReminderDataManager.shared) {
        self.dataManager = dataManager
    }
}


// MARK: - NewReminderViewModelProtocol

extension NewReminderViewModel: NewReminderViewModelProtocol {
    func addNew(_ reminder: Reminder) {
        

        dataManager.add(Reminder(
                            id: reminder.id,
                            isCompleted: reminder.isCompleted,
                            name: reminder.name,
                            date: reminder.date,
                            note: reminder.note,
                            url: reminder.url))
        
    }
    
    
}
