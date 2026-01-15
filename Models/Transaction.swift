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
    var note: String?
    var tags: [String]
    var photoData: Data?
    
    init(
        id: UUID = UUID(),
        amount: Double,
        category: String,
        type: TransactionType,
        date: Date = Date(),
        note: String? = nil,
        tags: [String] = [],
        photoData: Data? = nil
    ) {
        self.id = id
        self.amount = amount
        self.category = category
        self.type = type
        self.date = date
        self.note = note
        self.tags = tags
        self.photoData = photoData
    }
}
