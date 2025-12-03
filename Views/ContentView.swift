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
    
    var body: some View {
        ZStack {
            // Dark background
            Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                VStack(spacing: 8) {
                    Text(currentDateString)
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Text("Cashin'")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.top, 20)
                
                // MARK: - Balance Display (Card)
                VStack(spacing: 4) {
                    Text(formattedBalance)
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.3), value: dailyBalance)
                        .foregroundStyle(dailyBalance >= 0 ? cashAppGreen : Color.red)
                        .accessibilityLabel("Daily balance: \(formattedBalance)")
                    
                    Text("Today's Balance")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                // MARK: - Quick Add Buttons (Grid)
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    QuickAddButton(amount: 5, type: .income)
                    QuickAddButton(amount: 10, type: .income)
                    QuickAddButton(amount: 20, type: .income)
                    QuickAddButton(amount: 5, type: .expense)
                    QuickAddButton(amount: 10, type: .expense)
                    QuickAddButton(amount: 20, type: .expense)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                // MARK: - Transactions List (Card)
                VStack(spacing: 0) {
                    if todayTransactions.isEmpty {
                        Text("No transactions today")
                            .foregroundStyle(.white.opacity(0.4))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.vertical, 40)
                    } else {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(todayTransactions) { transaction in
                                    TransactionRow(transaction: transaction)
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                modelContext.delete(transaction)
                                                try? modelContext.save()
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .listRowBackground(Color.clear)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // MARK: - Bottom Action Bar
                HStack(spacing: 16) {
                    Button(action: { showingHistory = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 20))
                            Text("History")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                        )
                    }
                    .foregroundStyle(.white)
                    .accessibilityLabel("View history")
                    
                    Button(action: { showingEarnings = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 20))
                            Text("Earnings")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                        )
                    }
                    .foregroundStyle(.white)
                    .accessibilityLabel("View earnings")
                    
                    Button(action: { showingAddTransaction = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                            Text("Add Entry")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(cashAppGreen)
                                .shadow(color: cashAppGreen.opacity(0.4), radius: 8, x: 0, y: 4)
                        )
                    }
                    .foregroundStyle(.black)
                    .accessibilityLabel("Add new transaction")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
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
    
    private var cashAppGreen: Color {
        Color(red: 0.0, green: 0.84, blue: 0.2) // #00D632
    }
    
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
