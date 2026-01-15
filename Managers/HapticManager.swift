//
//  HapticManager.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import UIKit

/// Manages haptic feedback throughout the app
final class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    // MARK: - Haptic Generators
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    // MARK: - Public Methods
    
    /// Trigger haptic feedback for income transactions
    func incomeHaptic() {
        lightImpact.impactOccurred()
    }
    
    /// Trigger haptic feedback for expense transactions
    func expenseHaptic() {
        mediumImpact.impactOccurred()
    }
    
    /// Trigger haptic feedback for successful operations
    func successHaptic() {
        notificationGenerator.notificationOccurred(.success)
    }
    
    /// Trigger haptic feedback for warning situations
    func warningHaptic() {
        notificationGenerator.notificationOccurred(.warning)
    }
    
    /// Trigger haptic feedback for errors
    func errorHaptic() {
        heavyImpact.impactOccurred()
        notificationGenerator.notificationOccurred(.error)
    }
    
    /// Trigger haptic feedback for deletion
    func deleteHaptic() {
        mediumImpact.impactOccurred()
    }
    
    /// Trigger haptic feedback for selection
    func selectionHaptic() {
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.selectionChanged()
    }
}
