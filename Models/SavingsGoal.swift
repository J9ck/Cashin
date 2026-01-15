//
//  SavingsGoal.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

@Model
final class SavingsGoal {
    var id: UUID
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date?
    var category: String
    var iconName: String
    var createdDate: Date
    var isCompleted: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        targetAmount: Double,
        currentAmount: Double = 0.0,
        deadline: Date? = nil,
        category: String = "Other",
        iconName: String = "dollarsign.circle.fill",
        createdDate: Date = Date(),
        isCompleted: Bool = false
    ) {
        self.id = id
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
        self.category = category
        self.iconName = iconName
        self.createdDate = createdDate
        self.isCompleted = isCompleted
    }
    
    var progressPercentage: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
}
