//
//  TransactionRow.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    // Cash App theme colors
    private let accentGreen = Color(red: 0/255, green: 214/255, blue: 50/255)
    
    var body: some View {
        HStack {
            // Arrow icon
            Image(systemName: transaction.type == .income ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .foregroundStyle(transaction.type == .income ? accentGreen : .red)
                .font(.title2)
                .accessibilityLabel(transaction.type == .income ? "Income" : "Expense")
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(formattedTime)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
            
            Text(formattedAmount)
                .font(.headline)
                .foregroundStyle(transaction.type == .income ? accentGreen : .red)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Helper Properties
    
    private var formattedAmount: String {
        let sign = transaction.type == .income ? "+" : "-"
        return "\(sign)$\(String(format: "%.2f", transaction.amount))"
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: transaction.date)
    }
}

#Preview {
    ZStack {
        Color(red: 28/255, green: 28/255, blue: 30/255)
            .ignoresSafeArea()
        
        List {
            TransactionRow(transaction: Transaction(amount: 25.50, category: "Coffee", type: .expense))
            TransactionRow(transaction: Transaction(amount: 100.00, category: "Work", type: .income))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
