//
//  ReminderListViewModel.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 24.11.20.
//

import Foundation
import Combine

protocol ReminderListViewModelProtocol {
    var reminders: [Reminder] { get }
    var showCompleted: Bool { get set }
    func fetchReminders()
    func toggleIsCompleted(for reminder: Reminder)
}

final class ReminderListViewModel: ObservableObject {
    @Published var reminders = [Reminder]()
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

// MARK: - ReminderListViewModelProtocol

extension ReminderListViewModel: ReminderListViewModelProtocol {
    func fetchReminders() {
        reminders = dataManager.fetchReminderList(includingCompleted: showCompleted)
    }
    
    func toggleIsCompleted(for reminder: Reminder) {
        dataManager.toggleIsCompleted(for: reminder)
        fetchReminders()
    }
    
    
    func deleteReminders(at indices: IndexSet) {
        dataManager.deleteReminders(at: indices)
    }
}
