//
//  Streak.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

@Model
final class Streak {
    var id: UUID
    var currentStreak: Int
    var longestStreak: Int
    var lastPositiveDate: Date?
    
    init(
        id: UUID = UUID(),
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastPositiveDate: Date? = nil
    ) {
        self.id = id
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPositiveDate = lastPositiveDate
    }
}
