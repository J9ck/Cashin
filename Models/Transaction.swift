//
//  Transaction.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID
    var amount: Double
    var category: String
    var type: TransactionType
    var date: Date
    
    init(id: UUID = UUID(), amount: Double, category: String, type: TransactionType, date: Date = Date()) {
        self.id = id
        self.amount = amount
        self.category = category
        self.type = type
        self.date = date
    }
}
