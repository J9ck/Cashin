//
//  View+Haptics.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI

extension View {
    /// Add haptic feedback to any view action
    func withHaptic(_ hapticType: HapticType) -> some View {
        self.onTapGesture {
            switch hapticType {
            case .light:
                HapticManager.shared.incomeHaptic()
            case .medium:
                HapticManager.shared.expenseHaptic()
            case .heavy:
                HapticManager.shared.errorHaptic()
            case .success:
                HapticManager.shared.successHaptic()
            case .warning:
                HapticManager.shared.warningHaptic()
            case .selection:
                HapticManager.shared.selectionHaptic()
            }
        }
    }
}

enum HapticType {
    case light
    case medium
    case heavy
    case success
    case warning
    case selection
}
