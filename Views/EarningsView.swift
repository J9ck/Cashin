//
//  EarningsView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData
import Charts

struct EarningsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var transactions: [Transaction]
    
    @State private var selectedPeriod: EarningsPeriod = .monthly
    
    enum EarningsPeriod: String, CaseIterable {
        case weekly = "Week"
        case monthly = "Month"
        case lifetime = "Lifetime"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dark background
                Color(red: 0.11, green: 0.11, blue: 0.12)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Period Selector
                        Picker("Period", selection: $selectedPeriod) {
                            ForEach(EarningsPeriod.allCases, id: \.self) { period in
                                Text(period.rawValue).tag(period)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // MARK: - Earnings Summary Card
                        VStack(spacing: 16) {
                            Text("Net Earnings")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.6))
                            
                            Text(formattedNetEarnings)
                                .font(.system(size: 56, weight: .bold, design: .rounded))
                                .foregroundStyle(earningsColor)
                                .contentTransition(.numericText())
                            
                            HStack(spacing: 40) {
                                VStack(spacing: 4) {
                                    Text("Income")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                    Text(formattedIncome)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.green)
                                }
                                
                                VStack(spacing: 4) {
                                    Text("Expenses")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                    Text(formattedExpense)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                        .padding(.horizontal, 20)
                        
                        // MARK: - Category Breakdown
                        if !categoryData.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Earnings by Category")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 8) {
                                    ForEach(categoryData.sorted(by: { $0.value > $1.value }), id: \.key) { category, amount in
                                        HStack {
                                            Text(category)
                                                .font(.subheadline)
                                                .foregroundStyle(.white)
                                            
                                            Spacer()
                                            
                                            Text(formatCurrency(amount))
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(amount >= 0 ? .green : .red)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // MARK: - Income vs Expense Chart
                        if currentEarnings.income > 0 || currentEarnings.expense > 0 {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Income vs Expenses")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 20)
                                
                                Chart {
                                    BarMark(
                                        x: .value("Type", "Income"),
                                        y: .value("Amount", currentEarnings.income)
                                    )
                                    .foregroundStyle(.green)
                                    
                                    BarMark(
                                        x: .value("Type", "Expenses"),
                                        y: .value("Amount", currentEarnings.expense)
                                    )
                                    .foregroundStyle(.red)
                                }
                                .frame(height: 200)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Earnings Tracker")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
    
    // MARK: - Helper Properties
    
    private var currentEarnings: (income: Double, expense: Double, net: Double) {
        switch selectedPeriod {
        case .weekly:
            let calendar = Calendar.current
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            return EarningsManager.calculateEarnings(from: weekAgo, to: Date(), transactions: transactions)
        case .monthly:
            return EarningsManager.calculateMonthlyEarnings(transactions: transactions)
        case .lifetime:
            return EarningsManager.calculateLifetimeEarnings(transactions: transactions)
        }
    }
    
    private var formattedNetEarnings: String {
        formatCurrency(currentEarnings.net)
    }
    
    private var formattedIncome: String {
        formatCurrency(currentEarnings.income)
    }
    
    private var formattedExpense: String {
        formatCurrency(currentEarnings.expense)
    }
    
    private var earningsColor: Color {
        if currentEarnings.net > 0 {
            return Color(red: 0.0, green: 0.84, blue: 0.2) // Cash App Green
        } else if currentEarnings.net < 0 {
            return .red
        } else {
            return .white
        }
    }
    
    private var categoryData: [String: Double] {
        let filteredTransactions: [Transaction]
        
        switch selectedPeriod {
        case .weekly:
            let calendar = Calendar.current
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            filteredTransactions = transactions.filter { $0.date >= weekAgo }
        case .monthly:
            let calendar = Calendar.current
            let now = Date()
            guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
                return [:]
            }
            filteredTransactions = transactions.filter { $0.date >= startOfMonth }
        case .lifetime:
            filteredTransactions = transactions
        }
        
        return EarningsManager.getEarningsByCategory(transactions: filteredTransactions)
    }
    
    // MARK: - Helper Methods
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let sign = amount >= 0 ? "+" : ""
        return sign + (formatter.string(from: NSNumber(value: amount)) ?? "$0.00")
    }
}

#Preview {
    EarningsView()
        .modelContainer(for: [Transaction.self], inMemory: true)
}
