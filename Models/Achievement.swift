//
//  Achievement.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

enum AchievementCategory: String, Codable {
    case savings
    case streaks
    case tracking
    case balance
}

@Model
final class Achievement {
    var id: String
    var title: String
    var achievementDescription: String
    var earnedDate: Date?
    var isUnlocked: Bool
    var iconName: String
    var category: AchievementCategory
    var progress: Double // 0.0 to 1.0 for progress tracking
    var targetValue: Double // Target value for completion
    
    init(
        id: String,
        title: String,
        achievementDescription: String,
        earnedDate: Date? = nil,
        isUnlocked: Bool = false,
        iconName: String,
        category: AchievementCategory,
        progress: Double = 0.0,
        targetValue: Double = 1.0
    ) {
        self.id = id
        self.title = title
        self.achievementDescription = achievementDescription
        self.earnedDate = earnedDate
        self.isUnlocked = isUnlocked
        self.iconName = iconName
        self.category = category
        self.progress = progress
        self.targetValue = targetValue
    }
}
