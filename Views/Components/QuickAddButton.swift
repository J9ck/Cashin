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
    
    private var cashAppGreen: Color {
        Color(red: 0.0, green: 0.84, blue: 0.2) // #00D632
    }
    
    var body: some View {
        Button(action: addTransaction) {
            VStack(spacing: 8) {
                Image(systemName: type == .income ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(type == .income ? cashAppGreen : Color.red)
                
                Text(formattedAmount)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
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
