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

final class NewReminderViewModel: ObservableObject {
    var dataManager: DataManager
    
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
        
        if urlString.hasPrefix("https://") || urlString.hasPrefix("http://") {
            let url = URL(string: urlString)
            dataManager.addReminder(date: date, name: name, note: note, url: url)
        } else {
            let correctedURL = "http://\(urlString)"
            let url = URL(string: correctedURL)
            dataManager.addReminder(date: date, name: name, note: note, url: url)
        }
    }
}
