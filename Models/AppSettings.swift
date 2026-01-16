//
//  AppSettings.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftData

@Model
final class AppSettings {
    var id: UUID
    var lastSessionDate: Date
    
    init(id: UUID = UUID(), lastSessionDate: Date = Date()) {
        self.id = id
        self.lastSessionDate = lastSessionDate
    }
}
