//
//  NotificationModel.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import UserNotifications

class NotificationModel: ObservableObject {
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                print("✅ Notifications allowed")
            } else {
                print("❌ Notifications denied")
            }
        }
    }

    func scheduleNotification(taskTitle: String, deadline: Date) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ Task Reminder"
        content.body = "Task \"\(taskTitle)\" is due soon!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("⚠️ Notification error: \(error.localizedDescription)")
            }
        }
    }
}
