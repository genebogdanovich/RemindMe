//
//  NewReminderViewModel.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import Combine

protocol NewReminderViewModelProtocol {
    func addNewReminder(date: Date, name: String, note: String?, url: URL?)
}

final class NewReminderViewModel: ObservableObject {
    var dataManager: DataManager
    
    init(dataManager: DataManager = ReminderDataManager.shared) {
        self.dataManager = dataManager
    }
}


// MARK: - NewReminderViewModelProtocol

extension NewReminderViewModel: NewReminderViewModelProtocol {
    func addNewReminder(date: Date, name: String, note: String?, url: URL?) {
        dataManager.addReminder(date: date, name: name, note: note, url: url)
    }
}
