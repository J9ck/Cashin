//
//  AchievementManager.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

final class AchievementManager {
    
    /// Initialize default achievements if they don't exist
    static func initializeDefaultAchievements(context: ModelContext, achievements: [Achievement]) {
        if achievements.isEmpty {
            let defaultAchievements = createDefaultAchievements()
            for achievement in defaultAchievements {
                context.insert(achievement)
            }
            try? context.save()
        }
    }
    
    /// Check and update achievements based on current app state
    static func checkAchievements(
        context: ModelContext,
        achievements: [Achievement],
        transactions: [Transaction],
        summaries: [DailySummary],
        currentBalance: Double,
        currentStreak: Int
    ) {
        for achievement in achievements where !achievement.isUnlocked {
            var shouldUnlock = false
            var progress: Double = 0
            
            switch achievement.id {
            // Tracking achievements
            case "first_transaction":
                shouldUnlock = !transactions.isEmpty
                progress = transactions.isEmpty ? 0 : 1
                
            case "hundred_transactions":
                progress = min(Double(transactions.count) / 100.0, 1.0)
                shouldUnlock = transactions.count >= 100
                
            // Balance achievements
            case "debt_free":
                shouldUnlock = currentBalance >= 0
                progress = currentBalance >= 0 ? 1 : 0
                
            case "first_hundred":
                progress = min(currentBalance / 100.0, 1.0)
                shouldUnlock = currentBalance >= 100
                
            case "saved_500":
                progress = min(currentBalance / 500.0, 1.0)
                shouldUnlock = currentBalance >= 500
                
            case "saved_1000":
                progress = min(currentBalance / 1000.0, 1.0)
                shouldUnlock = currentBalance >= 1000
                
            // Streak achievements
            case "three_day_streak":
                progress = min(Double(currentStreak) / 3.0, 1.0)
                shouldUnlock = currentStreak >= 3
                
            case "week_in_green":
                progress = min(Double(currentStreak) / 7.0, 1.0)
                shouldUnlock = currentStreak >= 7
                
            case "month_master":
                progress = min(Double(currentStreak) / 30.0, 1.0)
                shouldUnlock = currentStreak >= 30
                
            default:
                break
            }
            
            achievement.progress = progress
            
            if shouldUnlock {
                unlockAchievement(achievement)
            }
        }
        
        try? context.save()
    }
    
    // MARK: - Helper Methods
    
    private static func unlockAchievement(_ achievement: Achievement) {
        achievement.isUnlocked = true
        achievement.earnedDate = Date()
        achievement.progress = 1.0
        
        // Trigger celebration
        HapticManager.shared.successHaptic()
    }
    
    private static func createDefaultAchievements() -> [Achievement] {
        return [
            // Tracking
            Achievement(
                id: "first_transaction",
                title: "First Step",
                achievementDescription: "Log your first transaction",
                iconName: "star.fill",
                category: .tracking,
                targetValue: 1
            ),
            Achievement(
                id: "hundred_transactions",
                title: "Century Club",
                achievementDescription: "Log 100 transactions",
                iconName: "star.circle.fill",
                category: .tracking,
                targetValue: 100
            ),
            
            // Balance
            Achievement(
                id: "debt_free",
                title: "Debt Free",
                achievementDescription: "Reach a positive balance",
                iconName: "checkmark.circle.fill",
                category: .balance,
                targetValue: 1
            ),
            Achievement(
                id: "first_hundred",
                title: "First $100",
                achievementDescription: "Save your first $100",
                iconName: "banknote.fill",
                category: .savings,
                targetValue: 100
            ),
            Achievement(
                id: "saved_500",
                title: "Big Saver",
                achievementDescription: "Save $500",
                iconName: "dollarsign.circle.fill",
                category: .savings,
                targetValue: 500
            ),
            Achievement(
                id: "saved_1000",
                title: "Millionaire (in progress)",
                achievementDescription: "Save $1000",
                iconName: "crown.fill",
                category: .savings,
                targetValue: 1000
            ),
            
            // Streaks
            Achievement(
                id: "three_day_streak",
                title: "Hat Trick",
                achievementDescription: "3 days of positive balance",
                iconName: "flame.fill",
                category: .streaks,
                targetValue: 3
            ),
            Achievement(
                id: "week_in_green",
                title: "Week Warrior",
                achievementDescription: "7 days of positive balance",
                iconName: "flame.circle.fill",
                category: .streaks,
                targetValue: 7
            ),
            Achievement(
                id: "month_master",
                title: "Month Master",
                achievementDescription: "30 days of positive balance",
                iconName: "trophy.fill",
                category: .streaks,
                targetValue: 30
            )
        ]
    }
}
