//
//  NotificationManager.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Authorization
    
    /// Request notification permissions from the user
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Scheduling
    
    /// Schedule a daily reminder notification at 8 PM
    func scheduleDailyReminder(balance: Double) {
        // Remove all pending notifications first
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Cashin' Daily Reminder"
        content.body = getReminderMessage(for: balance)
        content.sound = .default
        
        // Schedule for 8 PM daily
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getReminderMessage(for balance: Double) -> String {
        if balance > 0 {
            return "Great job! You're up \(formatCurrency(balance)) today. Keep it going! 💚"
        } else if balance < 0 {
            return "You're down \(formatCurrency(abs(balance))) today. Tomorrow's a fresh start! ⚠️"
        } else {
            return "How did your spending go today? Log your transactions! 📊"
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}
