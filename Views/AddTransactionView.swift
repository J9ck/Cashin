//
//  AddTransactionView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedType: TransactionType = .expense
    @State private var amount: String = ""
    @State private var selectedCategory: String = "Coffee"
    @State private var flipRotation: Double = 0
    @State private var note: String = ""
    
    private let incomeCategories = ["Work", "Freelance", "Gifts", "Bonus", "Other"]
    private let expenseCategories = ["Coffee", "Groceries", "Food", "Transport", "Entertainment", "Shopping"]
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Type Picker
                Section {
                    Picker("Type", selection: $selectedType) {
                        Text("Income").tag(TransactionType.income)
                        Text("Expense").tag(TransactionType.expense)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedType) { _, newValue in
                        // Reset category when type changes
                        selectedCategory = newValue == .income ? incomeCategories[0] : expenseCategories[0]
                        
                        // Haptic feedback
                        HapticManager.shared.selectionHaptic()
                        
                        // Card flip animation
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            flipRotation += 180
                        }
                    }
                }
                
                // MARK: - Amount Field
                Section {
                    HStack {
                        Text("$")
                            .font(.largeTitle)
                            .foregroundStyle(selectedType == .income ? .green : .red)
                        
                        TextField("Amount", text: $amount)
                            .font(.largeTitle)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(selectedType == .income ? .green : .red)
                            .accessibilityLabel("Transaction amount")
                    }
                }
                .rotation3DEffect(
                    .degrees(flipRotation),
                    axis: (x: 0, y: 1, z: 0)
                )
                
                // MARK: - Category Picker
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(currentCategories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.wheel)
                    .accessibilityLabel("Transaction category")
                }
                
                // MARK: - Note Field
                Section("Note (Optional)") {
                    TextField("Add a note...", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                        .accessibilityLabel("Transaction note")
                }
            }
            .navigationTitle("Add Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
                    }
                    .disabled(!isValidAmount)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    // MARK: - Helper Properties
    
    private var currentCategories: [String] {
        selectedType == .income ? incomeCategories : expenseCategories
    }
    
    private var isValidAmount: Bool {
        guard let value = Double(amount), value > 0 else {
            return false
        }
        return true
    }
    
    // MARK: - Actions
    
    private func saveTransaction() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            return
        }
        
        // Haptic feedback
        if selectedType == .income {
            HapticManager.shared.incomeHaptic()
        } else {
            HapticManager.shared.expenseHaptic()
        }
        
        let transaction = Transaction(
            amount: amountValue,
            category: selectedCategory,
            type: selectedType,
            date: Date(),
            note: note.isEmpty ? nil : note
        )
        
        modelContext.insert(transaction)
        try? modelContext.save()
        
        HapticManager.shared.successHaptic()
        dismiss()
    }
}

#Preview {
    AddTransactionView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
