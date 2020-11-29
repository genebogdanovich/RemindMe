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
    func addNew(_ reminder: Reminder)
}

//struct NewReminderViewState {
//    var name: String = "New Reminder"
//    var note: String = ""
//    var date: Date = Date()
//    var urlString = ""
//}

final class DetailReminderViewModel: ObservableObject {
    var dataManager: DataManager
//    var newReminderViewState = NewReminderViewState()
    
    init(dataManager: DataManager = ReminderDataManager.shared) {
        self.dataManager = dataManager
    }
}


// MARK: - NewReminderViewModelProtocol

extension DetailReminderViewModel: DetailReminderViewModelProtocol {
    func addNew(_ reminder: Reminder) {
        
        // Schedule notification
        
        createLocalNotification(withTitle: reminder.name, subtitle: reminder.note, date: reminder.date, id: reminder.id)

        dataManager.add(Reminder(
                            id: reminder.id,
                            isCompleted: reminder.isCompleted,
                            name: reminder.name,
                            date: reminder.date,
                            note: reminder.note,
                            url: reminder.url))
        
    }
    
    private func createLocalNotification(withTitle title: String, subtitle: String?, date: Date, id: UUID) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle ?? ""
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute, .day, .month], from: date), repeats: false)
        
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { _ in
            // TODO: Error handling.
        })
    }
}
