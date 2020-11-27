//
//  NewReminderViewModel.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import Combine

protocol NewReminderViewModelProtocol {
    func addNewReminder(date: Date, name: String, note: String?, urlString: String?)
}

struct NewReminderViewState {
    var name: String = "New Reminder"
    var note: String = ""
    var date: Date = Date()
    var urlString = ""
}

final class NewReminderViewModel: ObservableObject {
    var dataManager: DataManager
    var newReminderViewState = NewReminderViewState()
    
    init(dataManager: DataManager = ReminderDataManager.shared) {
        self.dataManager = dataManager
    }
}


// MARK: - NewReminderViewModelProtocol

extension NewReminderViewModel: NewReminderViewModelProtocol {
    func addNewReminder(date: Date, name: String, note: String?, urlString: String?) {
        
        guard let urlString = urlString else {
            dataManager.addReminder(date: date, name: name, note: note, url: nil)
            return
        }
        dataManager.addReminder(date: date, name: name, note: note, url: createURL(of: urlString))
        
    }
    
    
    private func createURL(of string: String) -> URL? {
        if string.hasPrefix("https://") || string.hasPrefix("http://") {
            let url = URL(string: string)
            return url
        } else {
            let correctedURL = "http://\(string)"
            let url = URL(string: correctedURL)
            return url
        }
    }
}
