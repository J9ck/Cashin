//
//  DayResetManager.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

final class DayResetManager {
    
    // MARK: - Day Reset Logic
    
    /// Performs day reset if needed - archives transactions and updates settings
    static func performResetIfNeeded(
        context: ModelContext,
        settings: AppSettings?,
        transactions: [Transaction],
        summaries: [DailySummary]
    ) {
        // Create settings if none exists
        var currentSettings = settings
        if currentSettings == nil {
            let newSettings = AppSettings(lastSessionDate: Date())
            context.insert(newSettings)
            currentSettings = newSettings
            try? context.save()
            return
        }
        
        guard let settings = currentSettings else { return }
        
        // Check if we need to perform a reset
        let today = Date().startOfDay
        let lastSessionDay = settings.lastSessionDate.startOfDay
        
        if lastSessionDay < today {
            // Archive yesterday's transactions
            archiveTransactions(
                context: context,
                transactions: transactions,
                summaries: summaries,
                lastSessionDate: settings.lastSessionDate
            )
            
            // Update streaks
            updateStreaks(
                context: context,
                summaries: summaries,
                lastSessionDate: settings.lastSessionDate
            )
            
            // Update last session date
            settings.lastSessionDate = Date()
            try? context.save()
        }
    }
    
    // MARK: - Helper Methods
    
    private static func archiveTransactions(
        context: ModelContext,
        transactions: [Transaction],
        summaries: [DailySummary],
        lastSessionDate: Date
    ) {
        let lastSessionDay = lastSessionDate.startOfDay
        
        // Filter transactions from the last session day
        let yesterdayTransactions = transactions.filter { transaction in
            transaction.date.isSameDay(as: lastSessionDay)
        }
        
        // Calculate total net for yesterday
        let totalNet = yesterdayTransactions.reduce(0.0) { sum, transaction in
            switch transaction.type {
            case .income:
                return sum + transaction.amount
            case .expense:
                return sum - transaction.amount
            }
        }
        
        // Check if summary for this day already exists
        let existingSummary = summaries.first { $0.date.isSameDay(as: lastSessionDay) }
        
        if existingSummary == nil && !yesterdayTransactions.isEmpty {
            // Create new daily summary
            let summary = DailySummary(date: lastSessionDay, totalNet: totalNet)
            context.insert(summary)
        }
    }
    
    private static func updateStreaks(
        context: ModelContext,
        summaries: [DailySummary],
        lastSessionDate: Date
    ) {
        // Fetch or create streak record
        let descriptor = FetchDescriptor<Streak>()
        let streaks = (try? context.fetch(descriptor)) ?? []
        
        let streak: Streak
        if let existingStreak = streaks.first {
            streak = existingStreak
        } else {
            streak = Streak()
            context.insert(streak)
        }
        
        // Get yesterday's summary
        let lastSessionDay = lastSessionDate.startOfDay
        let yesterdaySummary = summaries.first { $0.date.isSameDay(as: lastSessionDay) }
        
        // Check if yesterday was positive
        if let summary = yesterdaySummary, summary.totalNet > 0 {
            // Continue or start streak
            if let lastPositive = streak.lastPositiveDate,
               lastPositive.startOfDay == lastSessionDay.addingTimeInterval(-86400) { // Previous day
                streak.currentStreak += 1
            } else {
                streak.currentStreak = 1
            }
            
            streak.lastPositiveDate = lastSessionDay
            
            // Update longest streak
            if streak.currentStreak > streak.longestStreak {
                streak.longestStreak = streak.currentStreak
            }
        } else {
            // Reset streak
            streak.currentStreak = 0
        }
        
        try? context.save()
    }
}
