//
//  AppSettings.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

@Model
final class AppSettings {
    var id: UUID
    var lastSessionDate: Date
    var preferredColorScheme: Int? // 0=system, 1=light, 2=dark
    var biometricLockEnabled: Bool
    var soundEffectsEnabled: Bool
    var hasCompletedOnboarding: Bool
    var lastTransactionID: UUID? // For undo functionality
    var milestonesReached: [String] // Track which milestones triggered confetti
    
    init(
        id: UUID = UUID(),
        lastSessionDate: Date = Date(),
        preferredColorScheme: Int? = nil,
        biometricLockEnabled: Bool = false,
        soundEffectsEnabled: Bool = true,
        hasCompletedOnboarding: Bool = false,
        lastTransactionID: UUID? = nil,
        milestonesReached: [String] = []
    ) {
        self.id = id
        self.lastSessionDate = lastSessionDate
        self.preferredColorScheme = preferredColorScheme
        self.biometricLockEnabled = biometricLockEnabled
        self.soundEffectsEnabled = soundEffectsEnabled
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.lastTransactionID = lastTransactionID
        self.milestonesReached = milestonesReached
    }
}
