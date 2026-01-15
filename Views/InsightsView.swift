//
//  InsightsView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData

struct InsightsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var transactions: [Transaction]
    @Query private var summaries: [DailySummary]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - This Week Insights
                    InsightCard(
                        icon: "calendar",
                        title: "This Week",
                        insights: weeklyInsights,
                        color: .blue
                    )
                    
                    // MARK: - Spending Patterns
                    InsightCard(
                        icon: "chart.pie.fill",
                        title: "Spending Patterns",
                        insights: spendingPatterns,
                        color: .purple
                    )
                    
                    // MARK: - Best & Worst Days
                    InsightCard(
                        icon: "trophy.fill",
                        title: "Best & Worst",
                        insights: bestWorstDays,
                        color: .orange
                    )
                    
                    // MARK: - Comparisons
                    InsightCard(
                        icon: "arrow.up.arrow.down",
                        title: "Comparisons",
                        insights: comparisons,
                        color: .green
                    )
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Insights Calculations
    
    private var weeklyInsights: [String] {
        var insights: [String] = []
        
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let weekTransactions = transactions.filter { $0.date >= weekAgo }
        
        if weekTransactions.isEmpty {
            return ["No activity this week"]
        }
        
        let totalExpenses = weekTransactions
            .filter { $0.type == .expense }
            .reduce(0.0) { $0 + $1.amount }
        
        let totalIncome = weekTransactions
            .filter { $0.type == .income }
            .reduce(0.0) { $0 + $1.amount }
        
        let netWeek = totalIncome - totalExpenses
        
        if netWeek > 0 {
            insights.append("You saved \(formatCurrency(netWeek)) this week! 🎉")
        } else if netWeek < 0 {
            insights.append("You spent \(formatCurrency(abs(netWeek))) more than you earned this week")
        } else {
            insights.append("You broke even this week")
        }
        
        insights.append("Total spent: \(formatCurrency(totalExpenses))")
        insights.append("Total earned: \(formatCurrency(totalIncome))")
        insights.append("\(weekTransactions.count) transactions logged")
        
        return insights
    }
    
    private var spendingPatterns: [String] {
        var insights: [String] = []
        
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let expenses = transactions.filter { $0.type == .expense && $0.date >= weekAgo }
        
        if expenses.isEmpty {
            return ["No expenses this week"]
        }
        
        // Category breakdown
        var categoryTotals: [String: Double] = [:]
        for expense in expenses {
            categoryTotals[expense.category, default: 0] += expense.amount
        }
        
        let totalExpenses = categoryTotals.values.reduce(0, +)
        
        if let topCategory = categoryTotals.max(by: { $0.value < $1.value }) {
            let percentage = (topCategory.value / totalExpenses) * 100
            insights.append("You spent \(Int(percentage))% on \(topCategory.key) this week")
        }
        
        if let biggestExpense = expenses.max(by: { $0.amount < $1.amount }) {
            insights.append("Your biggest expense was \(formatCurrency(biggestExpense.amount)) on \(biggestExpense.category)")
        }
        
        let avgExpense = totalExpenses / Double(expenses.count)
        insights.append("Average expense: \(formatCurrency(avgExpense))")
        
        return insights
    }
    
    private var bestWorstDays: [String] {
        var insights: [String] = []
        
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        // Calculate daily nets for the week
        var dailyNets: [String: Double] = [:]
        let calendar = Calendar.current
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let startOfDay = date.startOfDay
            
            let dayTransactions = transactions.filter { 
                calendar.isDate($0.date, inSameDayAs: date)
            }
            
            let dayNet = dayTransactions.reduce(0.0) { sum, transaction in
                switch transaction.type {
                case .income:
                    return sum + transaction.amount
                case .expense:
                    return sum - transaction.amount
                }
            }
            
            let dayName = getDayName(date)
            dailyNets[dayName] = dayNet
        }
        
        if let bestDay = dailyNets.max(by: { $0.value < $1.value }) {
            insights.append("Best day: \(bestDay.key) (\(formatCurrency(bestDay.value)))")
        }
        
        if let worstDay = dailyNets.min(by: { $0.value < $1.value }) {
            insights.append("Worst day: \(worstDay.key) (\(formatCurrency(worstDay.value)))")
        }
        
        return insights
    }
    
    private var comparisons: [String] {
        var insights: [String] = []
        
        let thisWeekStart = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let lastWeekStart = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        
        let thisWeekExpenses = transactions
            .filter { $0.type == .expense && $0.date >= thisWeekStart }
            .reduce(0.0) { $0 + $1.amount }
        
        let lastWeekExpenses = transactions
            .filter { $0.type == .expense && $0.date >= lastWeekStart && $0.date < thisWeekStart }
            .reduce(0.0) { $0 + $1.amount }
        
        if lastWeekExpenses > 0 {
            let percentChange = ((thisWeekExpenses - lastWeekExpenses) / lastWeekExpenses) * 100
            
            if percentChange > 0 {
                insights.append("You're spending \(Int(abs(percentChange)))% more than last week")
            } else if percentChange < 0 {
                insights.append("You're spending \(Int(abs(percentChange)))% less than last week! 🎯")
            } else {
                insights.append("Your spending is consistent with last week")
            }
        }
        
        // Month comparison
        let thisMonthStart = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let thisMonthExpenses = transactions
            .filter { $0.type == .expense && $0.date >= thisMonthStart }
            .reduce(0.0) { $0 + $1.amount }
        
        insights.append("Last 30 days total: \(formatCurrency(thisMonthExpenses))")
        
        return insights
    }
    
    // MARK: - Helper Methods
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    private func getDayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let insights: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.headline)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(insights, id: \.self) { insight in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundStyle(color)
                        Text(insight)
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    InsightsView()
        .modelContainer(for: [Transaction.self, DailySummary.self], inMemory: true)
}
