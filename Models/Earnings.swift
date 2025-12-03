//
//  Earnings.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

@Model
final class Earnings {
    var id: UUID
    var date: Date
    var totalIncome: Double
    var totalExpense: Double
    var netEarnings: Double
    var category: String?
    var notes: String?
    
    init(id: UUID = UUID(), date: Date = Date(), totalIncome: Double = 0.0, totalExpense: Double = 0.0, category: String? = nil, notes: String? = nil) {
        self.id = id
        self.date = date
        self.totalIncome = totalIncome
        self.totalExpense = totalExpense
        self.netEarnings = totalIncome - totalExpense
        self.category = category
        self.notes = notes
    }
    
    func updateNetEarnings() {
        self.netEarnings = totalIncome - totalExpense
    }
}
