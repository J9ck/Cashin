//
//  DailySummary.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

@Model
final class DailySummary {
    var id: UUID
    var date: Date
    var totalNet: Double
    
    init(id: UUID = UUID(), date: Date, totalNet: Double) {
        self.id = id
        self.date = date
        self.totalNet = totalNet
    }
}
