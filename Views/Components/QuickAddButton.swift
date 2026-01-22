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
    
    // Cash App theme colors
    private let darkBackground = Color(red: 28/255, green: 28/255, blue: 30/255)
    private let accentGreen = Color(red: 0/255, green: 214/255, blue: 50/255)
    
    var body: some View {
        Button(action: addTransaction) {
            VStack(spacing: 8) {
                Image(systemName: type == .income ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .font(.title)
                    .foregroundStyle(type == .income ? accentGreen : .red)
                
                Text(formattedAmount)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(type == .income ? accentGreen.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
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
    ZStack {
        Color(red: 28/255, green: 28/255, blue: 30/255)
            .ignoresSafeArea()
        
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickAddButton(amount: 5, type: .income)
            QuickAddButton(amount: 10, type: .income)
            QuickAddButton(amount: 20, type: .income)
        }
        .padding()
    }
    .modelContainer(for: Transaction.self, inMemory: true)
}
