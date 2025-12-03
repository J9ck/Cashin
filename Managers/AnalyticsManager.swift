//
//  AnalyticsManager.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation

/// AnalyticsManager provides a centralized interface for tracking app events
/// This manager is designed to work with Firebase Analytics, Apple App Analytics, or other analytics services
class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    
    private init() {}
    
    // MARK: - Configuration
    
    /// Configure the analytics service
    /// Call this method during app initialization
    func configure() {
        // TODO: Initialize Firebase Analytics or other analytics service
        // Example: FirebaseApp.configure()
        print("[Analytics] Analytics service configured")
    }
    
    // MARK: - Event Tracking
    
    /// Log a custom event
    /// - Parameters:
    ///   - name: The name of the event
    ///   - parameters: Optional dictionary of event parameters
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        #if DEBUG
        print("[Analytics] Event: \(name), Parameters: \(parameters ?? [:])")
        #endif
        
        // TODO: Implement actual analytics tracking
        // Example: Analytics.logEvent(name, parameters: parameters)
    }
    
    /// Log a screen view event
    /// - Parameters:
    ///   - screenName: The name of the screen
    ///   - screenClass: The class name of the screen
    func logScreenView(screenName: String, screenClass: String? = nil) {
        let params: [String: Any] = [
            "screen_name": screenName,
            "screen_class": screenClass ?? screenName
        ]
        logEvent("screen_view", parameters: params)
    }
    
    // MARK: - Transaction Events
    
    /// Log when a transaction is added
    /// - Parameters:
    ///   - type: The transaction type (income or expense)
    ///   - amount: The transaction amount
    ///   - category: The transaction category
    func logTransactionAdded(type: String, amount: Double, category: String) {
        logEvent("transaction_added", parameters: [
            "transaction_type": type,
            "amount": amount,
            "category": category
        ])
    }
    
    /// Log when a transaction is deleted
    func logTransactionDeleted() {
        logEvent("transaction_deleted")
    }
    
    // MARK: - Feature Usage Events
    
    /// Log when earnings view is opened
    func logEarningsViewed(period: String) {
        logEvent("earnings_viewed", parameters: ["period": period])
    }
    
    /// Log when history view is opened
    func logHistoryViewed() {
        logEvent("history_viewed")
    }
    
    /// Log when daily reminder is sent
    func logDailyReminderSent(balance: Double) {
        logEvent("daily_reminder_sent", parameters: ["balance": balance])
    }
    
    // MARK: - User Properties
    
    /// Set a user property
    /// - Parameters:
    ///   - value: The property value
    ///   - name: The property name
    func setUserProperty(_ value: String?, forName name: String) {
        #if DEBUG
        print("[Analytics] User Property: \(name) = \(value ?? "nil")")
        #endif
        
        // TODO: Implement actual user property tracking
        // Example: Analytics.setUserProperty(value, forName: name)
    }
    
    // MARK: - App Lifecycle Events
    
    /// Log app launch
    func logAppLaunched() {
        logEvent("app_launched")
    }
    
    /// Log app backgrounded
    func logAppBackgrounded() {
        logEvent("app_backgrounded")
    }
}

// MARK: - Analytics Event Names

extension AnalyticsManager {
    struct EventName {
        static let transactionAdded = "transaction_added"
        static let transactionDeleted = "transaction_deleted"
        static let earningsViewed = "earnings_viewed"
        static let historyViewed = "history_viewed"
        static let dailyReminderSent = "daily_reminder_sent"
        static let appLaunched = "app_launched"
        static let appBackgrounded = "app_backgrounded"
    }
    
    struct ParameterKey {
        static let transactionType = "transaction_type"
        static let amount = "amount"
        static let category = "category"
        static let period = "period"
        static let balance = "balance"
        static let screenName = "screen_name"
        static let screenClass = "screen_class"
    }
}
