//
//  TrendsView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData
import Charts

struct TrendsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var transactions: [Transaction]
    @Query private var summaries: [DailySummary]
    
    @State private var selectedPeriod: TrendPeriod = .thirtyDays
    @State private var selectedView: TrendView = .net
    
    enum TrendPeriod: String, CaseIterable {
        case thirtyDays = "30 Days"
        case ninetyDays = "90 Days"
    }
    
    enum TrendView: String, CaseIterable {
        case net = "Net"
        case income = "Income"
        case expense = "Expense"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Period Selector
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(TrendPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // MARK: - View Type Selector
                    Picker("View", selection: $selectedView) {
                        ForEach(TrendView.allCases, id: \.self) { view in
                            Text(view.rawValue).tag(view)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // MARK: - Line Chart
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(selectedView.rawValue) Trend")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        Chart(trendData) { item in
                            LineMark(
                                x: .value("Date", item.date),
                                y: .value("Amount", item.value)
                            )
                            .foregroundStyle(lineColor)
                            .interpolationMethod(.catmullRom)
                            
                            AreaMark(
                                x: .value("Date", item.date),
                                y: .value("Amount", item.value)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [lineColor.opacity(0.3), lineColor.opacity(0.05)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)
                        }
                        .frame(height: 300)
                        .padding()
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // MARK: - Summary Stats
                    VStack(spacing: 12) {
                        StatRow(
                            title: "Average",
                            value: formatCurrency(averageValue),
                            color: .blue
                        )
                        
                        StatRow(
                            title: "Highest",
                            value: formatCurrency(highestValue),
                            color: .green
                        )
                        
                        StatRow(
                            title: "Lowest",
                            value: formatCurrency(lowestValue),
                            color: .red
                        )
                        
                        StatRow(
                            title: "Total",
                            value: formatCurrency(totalValue),
                            color: .purple
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Trends")
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
    
    private struct TrendDataItem: Identifiable {
        let id = UUID()
        let date: Date
        let value: Double
    }
    
    private var trendData: [TrendDataItem] {
        let days = selectedPeriod == .thirtyDays ? 30 : 90
        var data: [TrendDataItem] = []
        let calendar = Calendar.current
        
        for dayOffset in (0..<days).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let startOfDay = date.startOfDay
            
            var value = 0.0
            
            // Check if it's today
            if date.isToday {
                value = calculateDailyValue(from: transactions.filter { $0.date.isToday })
            } else {
                // Use summary if available
                if let summary = summaries.first(where: { $0.date.isSameDay(as: startOfDay) }) {
                    // For historical data, we only have totalNet in summaries
                    // Note: Income/Expense views will show net for historical days
                    value = summary.totalNet
                }
            }
            
            data.append(TrendDataItem(date: date, value: value))
        }
        
        return data
    }
    
    private func calculateDailyValue(from transactions: [Transaction]) -> Double {
        switch selectedView {
        case .net:
            return transactions.reduce(0.0) { sum, transaction in
                switch transaction.type {
                case .income:
                    return sum + transaction.amount
                case .expense:
                    return sum - transaction.amount
                }
            }
        case .income:
            return transactions
                .filter { $0.type == .income }
                .reduce(0.0) { $0 + $1.amount }
        case .expense:
            return transactions
                .filter { $0.type == .expense }
                .reduce(0.0) { $0 + $1.amount }
        }
    }
    
    private var lineColor: Color {
        switch selectedView {
        case .net:
            return .blue
        case .income:
            return .green
        case .expense:
            return .red
        }
    }
    
    private var averageValue: Double {
        guard !trendData.isEmpty else { return 0 }
        return trendData.reduce(0.0) { $0 + $1.value } / Double(trendData.count)
    }
    
    private var highestValue: Double {
        trendData.map { $0.value }.max() ?? 0
    }
    
    private var lowestValue: Double {
        trendData.map { $0.value }.min() ?? 0
    }
    
    private var totalValue: Double {
        trendData.reduce(0.0) { $0 + $1.value }
    }
    
    // MARK: - Helper Methods
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct StatRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    TrendsView()
        .modelContainer(for: [Transaction.self, DailySummary.self], inMemory: true)
}
