//
//  EarningsModel.swift
//  Cashin'
//
//  Created on 2026-01-22.
//

import Foundation
import SwiftData

@Model
final class EarningsModel {
    var id: UUID
    var totalEarnings: Double
    var lastUpdated: Date
    
    init(id: UUID = UUID(), totalEarnings: Double = 0.0, lastUpdated: Date = Date()) {
        self.id = id
        self.totalEarnings = totalEarnings
        self.lastUpdated = lastUpdated
    }
}
