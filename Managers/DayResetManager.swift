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
}
