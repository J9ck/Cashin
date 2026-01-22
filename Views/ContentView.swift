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
    @State private var showingEarnings = false
    
    // Cash App theme colors
    private let darkBackground = Color(red: 28/255, green: 28/255, blue: 30/255)
    private let accentGreen = Color(red: 0/255, green: 214/255, blue: 50/255)
    
    var body: some View {
        ZStack {
            // Dark background
            darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                VStack(spacing: 8) {
                    Text(currentDateString)
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text("Cashin'")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.top, 20)
                
                // MARK: - Balance Display Card
                VStack(spacing: 8) {
                    Text("Today's Balance")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text(formattedBalance)
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundStyle(dailyBalance >= 0 ? accentGreen : .red)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.3), value: dailyBalance)
                        .accessibilityLabel("Daily balance: \(formattedBalance)")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                .padding(.vertical, 20)
                
                // MARK: - Quick Add Buttons (2x3 Grid)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    QuickAddButton(amount: 5, type: .income)
                    QuickAddButton(amount: 10, type: .income)
                    QuickAddButton(amount: 20, type: .income)
                    QuickAddButton(amount: 5, type: .expense)
                    QuickAddButton(amount: 10, type: .expense)
                    QuickAddButton(amount: 20, type: .expense)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                // MARK: - Transactions List
                List {
                    ForEach(todayTransactions) { transaction in
                        TransactionRow(transaction: transaction)
                            .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteTransactions)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                
                // MARK: - Bottom Action Bar
                VStack(spacing: 12) {
                    // Large Add Entry Button
                    Button(action: { showingAddTransaction = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("Add Entry")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(accentGreen)
                        .cornerRadius(14)
                    }
                    .foregroundStyle(.white)
                    .accessibilityLabel("Add new transaction")
                    
                    // Secondary buttons
                    HStack(spacing: 12) {
                        Button(action: { showingHistory = true }) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                Text("History")
                            }
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .foregroundStyle(.white)
                        .accessibilityLabel("View history")
                        
                        Button(action: { showingEarnings = true }) {
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                Text("Earnings")
                            }
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .foregroundStyle(.white)
                        .accessibilityLabel("View earnings")
                    }
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
        .sheet(isPresented: $showingEarnings) {
            EarningsView()
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
        .modelContainer(for: [Transaction.self, DailySummary.self, AppSettings.self, EarningsModel.self], inMemory: true)
}
