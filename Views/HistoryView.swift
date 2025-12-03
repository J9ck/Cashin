//
//  HistoryView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData
import Charts

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var transactions: [Transaction]
    @Query private var summaries: [DailySummary]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - 7-Day Summary Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("7-Day Summary")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text(formattedTotalNet)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(totalNetColor)
                            .contentTransition(.numericText())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // MARK: - Bar Chart
                    if !chartData.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Daily Net Balance")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                            
                            Chart(chartData) { item in
                                BarMark(
                                    x: .value("Day", item.dayLabel),
                                    y: .value("Net", item.net)
                                )
                                .foregroundStyle(item.net >= 0 ? Color.green : Color.red)
                            }
                            .frame(height: 200)
                            .padding()
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Daily Breakdown
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Daily Breakdown")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        ForEach(chartData) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.dayLabel)
                                        .font(.headline)
                                    Text(item.fullDate)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(formatCurrency(item.net))
                                    .font(.headline)
                                    .foregroundStyle(item.net >= 0 ? .green : .red)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("History")
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
    
    // MARK: - Helper Properties
    
    private var sevenDayNet: Double {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        // Calculate from summaries
        let summaryTotal = summaries
            .filter { $0.date >= sevenDaysAgo }
            .reduce(0.0) { $0 + $1.totalNet }
        
        // Add today's transactions
        let todayTotal = transactions
            .filter { $0.date.isToday }
            .reduce(0.0) { sum, transaction in
                switch transaction.type {
                case .income:
                    return sum + transaction.amount
                case .expense:
                    return sum - transaction.amount
                }
            }
        
        return summaryTotal + todayTotal
    }
    
    private var formattedTotalNet: String {
        formatCurrency(sevenDayNet)
    }
    
    private var totalNetColor: Color {
        if sevenDayNet > 0 {
            return .green
        } else if sevenDayNet < 0 {
            return .red
        } else {
            return .primary
        }
    }
    
    private struct ChartDataItem: Identifiable {
        let id = UUID()
        let date: Date
        let net: Double
        let dayLabel: String
        let fullDate: String
    }
    
    private var chartData: [ChartDataItem] {
        var data: [ChartDataItem] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateStyle = .medium
        
        // Get last 7 days
        for dayOffset in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let startOfDay = date.startOfDay
            
            var dayNet = 0.0
            
            // Check if it's today
            if date.isToday {
                // Use transactions
                dayNet = transactions
                    .filter { $0.date.isToday }
                    .reduce(0.0) { sum, transaction in
                        switch transaction.type {
                        case .income:
                            return sum + transaction.amount
                        case .expense:
                            return sum - transaction.amount
                        }
                    }
            } else {
                // Use summary if available
                if let summary = summaries.first(where: { $0.date.isSameDay(as: startOfDay) }) {
                    dayNet = summary.totalNet
                }
            }
            
            let dayLabel = dateFormatter.string(from: date)
            let fullDate = fullDateFormatter.string(from: date)
            
            data.append(ChartDataItem(date: date, net: dayNet, dayLabel: dayLabel, fullDate: fullDate))
        }
        
        return data
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
    HistoryView()
        .modelContainer(for: [Transaction.self, DailySummary.self], inMemory: true)
}
