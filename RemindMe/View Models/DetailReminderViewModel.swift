//
//  DetailReminderViewModel.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import Combine
import UserNotifications

protocol DetailReminderViewModelProtocol {
    func add(_ reminder: Reminder)
}



class DetailReminderViewModel: ObservableObject {
    var dataManager: DataManager

    static let priorityTypes = ["None", "Low", "Medium", "High"]
    @Published var priorityType = 0 {
        didSet {
            print("didSet priorityType on DetailReminderViewModel to: \(priorityType)")
        }
    }
    
    init(dataManager: DataManager = ReminderDataManager.shared) {
        self.dataManager = dataManager
    }
}


// MARK: - NewReminderViewModelProtocol

extension DetailReminderViewModel: DetailReminderViewModelProtocol {
    func add(_ reminder: Reminder) {
        
        // Schedule notification
        
        LocalUserNotificationsManager.shared.createLocalUserNotification(for: reminder)

        
        print(reminder.name + " " + String(reminder.isCompleted))
        
        dataManager.add(reminder)
        
    }
}
