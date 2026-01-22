//
//  EarningsView.swift
//  Cashin'
//
//  Created on 2026-01-22.
//

import SwiftUI
import SwiftData
import Charts

struct EarningsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var transactions: [Transaction]
    @Query private var summaries: [DailySummary]
    
    // Cash App theme colors
    private let darkBackground = Color(red: 28/255, green: 28/255, blue: 30/255)
    private let accentGreen = Color(red: 0/255, green: 214/255, blue: 50/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                darkBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Total Earnings Card
                        VStack(spacing: 12) {
                            Text("Total Earnings")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Text(formattedEarnings)
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundStyle(accentGreen)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                        .padding(.horizontal)
                        
                        // Statistics Cards
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Income",
                                value: formattedIncome,
                                color: accentGreen
                            )
                            
                            StatCard(
                                title: "Expenses",
                                value: formattedExpenses,
                                color: .red
                            )
                        }
                        .padding(.horizontal)
                        
                        // Net Earnings Card
                        VStack(spacing: 12) {
                            Text("Net Earnings")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Text(formattedNet)
                                .font(.system(size: 32, weight: .semibold, design: .rounded))
                                .foregroundStyle(netEarnings >= 0 ? accentGreen : .red)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                        .padding(.horizontal)
                        
                        // Recent Summary Chart
                        if !recentSummaries.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Recent Performance")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                
                                Chart {
                                    ForEach(recentSummaries, id: \.id) { summary in
                                        BarMark(
                                            x: .value("Date", summary.date, unit: .day),
                                            y: .value("Net", summary.totalNet)
                                        )
                                        .foregroundStyle(summary.totalNet >= 0 ? accentGreen : Color.red)
                                    }
                                }
                                .frame(height: 200)
                                .chartYAxis {
                                    AxisMarks(position: .leading) { value in
                                        AxisValueLabel()
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                }
                                .chartXAxis {
                                    AxisMarks { value in
                                        AxisValueLabel()
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.05))
                                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Earnings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(accentGreen)
                }
            }
            .toolbarBackground(darkBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    // MARK: - Helper Properties
    
    private var totalEarnings: Double {
        EarningsManager.calculateTotalEarnings(from: transactions)
    }
    
    private var totalExpenses: Double {
        EarningsManager.calculateTotalExpenses(from: transactions)
    }
    
    private var netEarnings: Double {
        EarningsManager.calculateNetEarnings(from: transactions)
    }
    
    private var recentSummaries: [DailySummary] {
        summaries
            .sorted { $0.date > $1.date }
            .prefix(7)
            .reversed()
    }
    
    private var formattedEarnings: String {
        formatCurrency(totalEarnings)
    }
    
    private var formattedExpenses: String {
        formatCurrency(totalExpenses)
    }
    
    private var formattedIncome: String {
        formatCurrency(totalEarnings)
    }
    
    private var formattedNet: String {
        let sign = netEarnings >= 0 ? "+" : ""
        return sign + formatCurrency(abs(netEarnings))
    }
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    private func formatCurrency(_ amount: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    EarningsView()
        .modelContainer(for: [Transaction.self, DailySummary.self], inMemory: true)
}
