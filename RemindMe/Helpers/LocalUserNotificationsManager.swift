//
//  LocalUserNotificationsManager.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 4.12.20.
//

import Foundation
import UserNotifications

class LocalUserNotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared: LocalUserNotificationsManager = LocalUserNotificationsManager()
    
    func requestLocalNotificationsAuthorisation() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { didAllow, error in
            if !didAllow {
                print("User has declined local notifications authorization: \(error?.localizedDescription ?? "Unknown error")")
            }
        })
        
    }
    
    private func createLocalUserNotification(withRequest request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { _ in
            // TODO: Error handling.
        })
        
        
    }
    
    func createLocalUserNotificationForReminder(withName name: String, note: String?, date: Date, id: UUID) {
        let content = UNMutableNotificationContent()
        content.title = name
        content.subtitle = note ?? ""
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute, .day, .month], from: date), repeats: false)
        
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
        createLocalUserNotification(withRequest: request)
    }
}
