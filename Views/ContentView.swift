//
//  ContentView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var transactions: [Transaction]
    @Query private var summaries: [DailySummary]
    @Query private var settings: [AppSettings]
    
    @State private var showingAddTransaction = false
    @State private var showingHistory = false
    
    var body: some View {
        ZStack {
            // Dynamic background color
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                VStack(spacing: 8) {
                    Text(currentDateString)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text("Cashin'")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                
                // MARK: - Balance Display
                VStack(spacing: 4) {
                    Text(formattedBalance)
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.3), value: dailyBalance)
                        .accessibilityLabel("Daily balance: \(formattedBalance)")
                    
                    Text("Today's Balance")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 40)
                
                // MARK: - Quick Add Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        QuickAddButton(amount: 5, type: .income)
                        QuickAddButton(amount: 10, type: .income)
                        QuickAddButton(amount: 20, type: .income)
                        QuickAddButton(amount: 5, type: .expense)
                        QuickAddButton(amount: 10, type: .expense)
                        QuickAddButton(amount: 20, type: .expense)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
                
                // MARK: - Transactions List
                List {
                    ForEach(todayTransactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                    .onDelete(perform: deleteTransactions)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                
                // MARK: - Bottom Action Bar
                HStack(spacing: 16) {
                    Button(action: { showingHistory = true }) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                            Text("History")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .foregroundStyle(.primary)
                    .accessibilityLabel("View history")
                    
                    Button(action: { showingAddTransaction = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Entry")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .foregroundStyle(.white)
                    .accessibilityLabel("Add new transaction")
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView()
        }
        .sheet(isPresented: $showingHistory) {
            HistoryView()
        }
        .onAppear {
            performDayReset()
            scheduleNotifications()
        }
    }
    
    // MARK: - Helper Properties
    
    private var todayTransactions: [Transaction] {
        transactions
            .filter { $0.date.isToday }
            .sorted { $0.date > $1.date }
    }
    
    private var dailyBalance: Double {
        todayTransactions.reduce(0.0) { sum, transaction in
            switch transaction.type {
            case .income:
                return sum + transaction.amount
            case .expense:
                return sum - transaction.amount
            }
        }
    }
    
    private var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let sign = dailyBalance >= 0 ? "+" : ""
        return sign + (formatter.string(from: NSNumber(value: dailyBalance)) ?? "$0.00")
    }
    
    private var backgroundColor: Color {
        if dailyBalance > 0 {
            return Color.green.opacity(0.1)
        } else if dailyBalance < 0 {
            return Color.red.opacity(0.1)
        } else {
            return Color(.systemBackground)
        }
    }
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }
    
    // MARK: - Actions
    
    private func deleteTransactions(at offsets: IndexSet) {
        for index in offsets {
            let transaction = todayTransactions[index]
            modelContext.delete(transaction)
        }
        try? modelContext.save()
    }
    
    private func performDayReset() {
        DayResetManager.performResetIfNeeded(
            context: modelContext,
            settings: settings.first,
            transactions: transactions,
            summaries: summaries
        )
    }
    
    private func scheduleNotifications() {
        NotificationManager.shared.requestAuthorization()
        NotificationManager.shared.scheduleDailyReminder(balance: dailyBalance)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Transaction.self, DailySummary.self, AppSettings.self], inMemory: true)
}
