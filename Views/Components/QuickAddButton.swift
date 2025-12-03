//
//  QuickAddButton.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData

struct QuickAddButton: View {
    let amount: Double
    let type: TransactionType
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Button(action: addTransaction) {
            Text(formattedAmount)
                .font(.headline)
                .foregroundStyle(type == .income ? .green : .red)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(type == .income ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                )
        }
        .accessibilityLabel("Quick add \(formattedAmount)")
    }
    
    // MARK: - Helper Properties
    
    private var formattedAmount: String {
        let sign = type == .income ? "+" : "-"
        return "\(sign)$\(Int(amount))"
    }
    
    // MARK: - Actions
    
    private func addTransaction() {
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Create and insert transaction
        let category = "Other"
        let transaction = Transaction(
            amount: amount,
            category: category,
            type: type,
            date: Date()
        )
        modelContext.insert(transaction)
        
        try? modelContext.save()
    }
}

#Preview {
    QuickAddButton(amount: 5, type: .income)
        .modelContainer(for: Transaction.self, inMemory: true)
}
