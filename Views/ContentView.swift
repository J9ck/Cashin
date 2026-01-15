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
    @State private var isRefreshing = false
    @State private var showConfetti = false
    @State private var showParticleEffect = false
    @State private var particleIsPositive = true
    @State private var previousBalance: Double = 0
    @State private var showUndoButton = false
    @State private var undoTimer: Timer?
    
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
                ZStack {
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
                    
                    // Particle effect overlay
                    if showParticleEffect {
                        ParticleEffect(isPositive: particleIsPositive)
                            .padding(.top, 12)
                    }
                }
                
                // MARK: - Quick Add Buttons (Grid)
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    QuickAddButton(amount: 5, type: .income, onTransactionAdded: showUndoOption)
                    QuickAddButton(amount: 10, type: .income, onTransactionAdded: showUndoOption)
                    QuickAddButton(amount: 20, type: .income, onTransactionAdded: showUndoOption)
                    QuickAddButton(amount: 5, type: .expense, onTransactionAdded: showUndoOption)
                    QuickAddButton(amount: 10, type: .expense, onTransactionAdded: showUndoOption)
                    QuickAddButton(amount: 20, type: .expense, onTransactionAdded: showUndoOption)
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
                                                deleteTransaction(transaction)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .listRowBackground(Color.clear)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .refreshable {
                            await refreshData()
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
            
            // MARK: - Confetti Overlay
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
            }
            
            // MARK: - Undo Button
            if showUndoButton {
                VStack {
                    Spacer()
                    Button(action: undoLastTransaction) {
                        HStack {
                            Image(systemName: "arrow.uturn.backward.circle.fill")
                            Text("Undo")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                    .padding(.bottom, 100)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
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
            previousBalance = dailyBalance
        }
        .onChange(of: dailyBalance) { oldValue, newValue in
            handleBalanceChange(from: oldValue, to: newValue)
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
    
    private func deleteTransaction(_ transaction: Transaction) {
        HapticManager.shared.deleteHaptic()
        modelContext.delete(transaction)
        try? modelContext.save()
    }
    
    private func refreshData() async {
        isRefreshing = true
        performDayReset()
        scheduleNotifications()
        
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        isRefreshing = false
    }
    
    private func handleBalanceChange(from oldValue: Double, to newValue: Double) {
        // Trigger particle effects
        if newValue != oldValue && oldValue != 0 {
            particleIsPositive = newValue > oldValue
            showParticleEffect = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showParticleEffect = false
            }
        }
        
        // Check for confetti triggers
        checkConfettiTriggers(oldBalance: oldValue, newBalance: newValue)
    }
    
    private func checkConfettiTriggers(oldBalance: Double, newBalance: Double) {
        guard let currentSettings = settings.first else { return }
        
        // Trigger when balance goes from negative to positive
        if oldBalance < 0 && newBalance >= 0 {
            triggerConfetti()
            return
        }
        
        // Milestone triggers
        let milestones: [Double] = [100, 500, 1000]
        let today = Date().startOfDay.timeIntervalSince1970
        
        for milestone in milestones {
            let milestoneKey = "milestone_\(Int(milestone))_\(Int(today))"
            if newBalance >= milestone && oldBalance < milestone {
                if !currentSettings.milestonesReached.contains(milestoneKey) {
                    currentSettings.milestonesReached.append(milestoneKey)
                    try? modelContext.save()
                    triggerConfetti()
                    break
                }
            }
        }
    }
    
    private func triggerConfetti() {
        HapticManager.shared.successHaptic()
        showConfetti = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showConfetti = false
        }
    }
    
    private func undoLastTransaction() {
        guard let currentSettings = settings.first,
              let lastTransactionID = currentSettings.lastTransactionID,
              let transaction = transactions.first(where: { $0.id == lastTransactionID }) else {
            return
        }
        
        HapticManager.shared.warningHaptic()
        modelContext.delete(transaction)
        currentSettings.lastTransactionID = nil
        try? modelContext.save()
        
        withAnimation {
            showUndoButton = false
        }
        undoTimer?.invalidate()
    }
    
    private func showUndoOption(for transactionID: UUID) {
        guard let currentSettings = settings.first else { return }
        
        currentSettings.lastTransactionID = transactionID
        try? modelContext.save()
        
        withAnimation {
            showUndoButton = true
        }
        
        undoTimer?.invalidate()
        undoTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            withAnimation {
                showUndoButton = false
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Transaction.self, DailySummary.self, AppSettings.self], inMemory: true)
}
