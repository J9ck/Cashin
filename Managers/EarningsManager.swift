//
//  EarningsManager.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

class EarningsManager {
    
    /// Calculate earnings for a specific date range
    static func calculateEarnings(from startDate: Date, to endDate: Date, transactions: [Transaction]) -> (income: Double, expense: Double, net: Double) {
        let filteredTransactions = transactions.filter { transaction in
            transaction.date >= startDate && transaction.date <= endDate
        }
        
        var totalIncome = 0.0
        var totalExpense = 0.0
        
        for transaction in filteredTransactions {
            switch transaction.type {
            case .income:
                totalIncome += transaction.amount
            case .expense:
                totalExpense += transaction.amount
            }
        }
        
        let netEarnings = totalIncome - totalExpense
        return (totalIncome, totalExpense, netEarnings)
    }
    
    /// Calculate lifetime earnings from all transactions
    static func calculateLifetimeEarnings(transactions: [Transaction]) -> (income: Double, expense: Double, net: Double) {
        var totalIncome = 0.0
        var totalExpense = 0.0
        
        for transaction in transactions {
            switch transaction.type {
            case .income:
                totalIncome += transaction.amount
            case .expense:
                totalExpense += transaction.amount
            }
        }
        
        let netEarnings = totalIncome - totalExpense
        return (totalIncome, totalExpense, netEarnings)
    }
    
    /// Calculate monthly earnings for the current month
    static func calculateMonthlyEarnings(transactions: [Transaction]) -> (income: Double, expense: Double, net: Double) {
        let calendar = Calendar.current
        let now = Date()
        
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            return (0.0, 0.0, 0.0)
        }
        
        return calculateEarnings(from: startOfMonth, to: endOfMonth, transactions: transactions)
    }
    
    /// Save or update earnings record in the database
    static func saveEarnings(context: ModelContext, earnings: Earnings) {
        context.insert(earnings)
        try? context.save()
    }
    
    /// Get earnings by category
    static func getEarningsByCategory(transactions: [Transaction]) -> [String: Double] {
        var categoryEarnings: [String: Double] = [:]
        
        for transaction in transactions {
            let amount = transaction.type == .income ? transaction.amount : -transaction.amount
            categoryEarnings[transaction.category, default: 0.0] += amount
        }
        
        return categoryEarnings
    }
}
