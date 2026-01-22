//
//  EarningsManager.swift
//  Cashin'
//
//  Created on 2026-01-22.
//

import Foundation
import SwiftData

struct EarningsManager {
    static func calculateTotalEarnings(from transactions: [Transaction]) -> Double {
        return transactions
            .filter { $0.type == .income }
            .reduce(0.0) { $0 + $1.amount }
    }
    
    static func calculateTotalExpenses(from transactions: [Transaction]) -> Double {
        return transactions
            .filter { $0.type == .expense }
            .reduce(0.0) { $0 + $1.amount }
    }
    
    static func calculateNetEarnings(from transactions: [Transaction]) -> Double {
        let income = calculateTotalEarnings(from: transactions)
        let expenses = calculateTotalExpenses(from: transactions)
        return income - expenses
    }
    
    static func updateEarningsModel(
        context: ModelContext,
        earnings: EarningsModel?,
        transactions: [Transaction]
    ) {
        let totalEarnings = calculateTotalEarnings(from: transactions)
        
        if let earnings = earnings {
            earnings.totalEarnings = totalEarnings
            earnings.lastUpdated = Date()
        } else {
            let newEarnings = EarningsModel(totalEarnings: totalEarnings)
            context.insert(newEarnings)
        }
        
        try? context.save()
    }
}
