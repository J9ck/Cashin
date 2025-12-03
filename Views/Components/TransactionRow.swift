//
//  TransactionRow.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    private var cashAppGreen: Color {
        Color(red: 0.0, green: 0.84, blue: 0.2) // #00D632
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Arrow icon in circular background
            ZStack {
                Circle()
                    .fill(transaction.type == .income ? cashAppGreen.opacity(0.2) : Color.red.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: transaction.type == .income ? "arrow.up" : "arrow.down")
                    .foregroundStyle(transaction.type == .income ? cashAppGreen : Color.red)
                    .font(.system(size: 18, weight: .bold))
            }
            .accessibilityLabel(transaction.type == .income ? "Income" : "Expense")
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(formattedTime)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
            
            Text(formattedAmount)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(transaction.type == .income ? cashAppGreen : Color.red)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.clear)
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
    List {
        TransactionRow(transaction: Transaction(amount: 25.50, category: "Coffee", type: .expense))
        TransactionRow(transaction: Transaction(amount: 100.00, category: "Work", type: .income))
    }
}
