//
//  ReminderListViewModel.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import Combine
import UIKit

protocol ReminderListViewModelProtocol {
    var reminders: [ReminderViewModel] { get }
    var showCompleted: Bool { get set }
    func fetchReminders()
    func toggleIsCompleted(for reminder: Reminder)
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

struct ReminderViewModel {
    let reminder: Reminder
    
    var id: UUID {
        return reminder.id
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Formatting.fullDateFormat
        return formatter.string(from: reminder.date)
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
    
}

// MARK: - ReminderListViewModelProtocol

extension ReminderListViewModel: ReminderListViewModelProtocol {
    func fetchReminders() {
        reminders = dataManager.fetchReminderList(includingCompleted: showCompleted).map(ReminderViewModel.init)
    }
    
    func toggleIsCompleted(for reminder: Reminder) {
        dataManager.toggleIsCompleted(for: reminder)
        fetchReminders()
    }
    
    
    func deleteReminders(at indices: IndexSet) {
        dataManager.deleteReminders(at: indices)
    }
}
