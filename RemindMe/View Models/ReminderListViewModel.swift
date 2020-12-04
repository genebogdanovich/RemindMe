//
//  ReminderListViewModel.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import Combine
import UIKit
import SwiftUI

protocol ReminderListViewModelProtocol {
    var reminders: [ReminderViewModel] { get }
    var showCompleted: Bool { get set }
    func fetchReminders()
    
}

final class ReminderListViewModel: ObservableObject {
    @Published var reminders = [ReminderViewModel]()
    @Published var showCompleted = false {
        didSet {
            fetchReminders()
        }
    }
    
    var dataManager: DataManager
    
    init(dataManager: DataManager = ReminderDataManager.shared) {
        self.dataManager = dataManager
        fetchReminders()
    }
}

class ReminderViewModel: ObservableObject {
    var reminder: Reminder
    
    init(reminder: Reminder) {
        self.reminder = reminder
    }
    
    var image: Image? {
        if let uiImage = reminder.image {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    var uiImage: UIImage? {
        return reminder.image
    }
    
    
    var id: UUID {
        return reminder.id
    }
    
    var isCompleted: Bool {
        return reminder.isCompleted
    }
    
    var dateString: String {
        return format(date: date)
    }
    
    var date: Date {
        return reminder.date
    }
    
    var url: URL? {
        return reminder.url
    }
    
    var name: String {
        return reminder.name
    }
    
    var note: String? {
        return reminder.note
    }
    
    /// String to display on the screen for the user.
    var urlString: String? {
        return reminder.url?.host
    }
    
    /// Method to open URL in the user’s browser.
    func openURL() {
        guard let url = reminder.url else {
            fatalError()
            
        }
        UIApplication.shared.open(url, completionHandler: { success in
            if success {
                print("Successfully opened URL!")
            } else {
                
                print("Something went wrong with URL.")
            }
            
        })
        
    }
    
    private func format(date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = Constants.Formatting.timeFormat
            return "Today, \(formatter.string(from: date))"
        }
        
        if calendar.isDateInYesterday(date) {
            formatter.dateFormat = Constants.Formatting.timeFormat
            return "Yesterday, \(formatter.string(from: date))"
        }
        
        if calendar.isDateInTomorrow(date) {
            formatter.dateFormat = Constants.Formatting.timeFormat
            return "Tomorrow, \(formatter.string(from: date))"
        }
        
        formatter.dateFormat = Constants.Formatting.fullDateFormat
        
        return formatter.string(from: date)
    }
    
    
    
}

// MARK: - ReminderListViewModelProtocol

extension ReminderListViewModel: ReminderListViewModelProtocol {
    func fetchReminders() {
        reminders = dataManager.fetchReminderList(includingCompleted: showCompleted).map(ReminderViewModel.init)
    }
    
    func toggleIsCompleted(for reminder: Reminder) {
        dataManager.toggleIsCompleted(for: reminder)
        
        if !reminder.isCompleted {
            LocalUserNotificationsManager.shared.cancelPendingNotification(withIdentifier: reminder.id)
        } else if reminder.isCompleted {
            if reminder.date > Date() {
                LocalUserNotificationsManager.shared.createLocalUserNotification(for: reminder)
            }
        }
        fetchReminders()
    }
    
    func deleteReminders(at indices: IndexSet) {
        dataManager.deleteReminders(at: indices)
    }
}
