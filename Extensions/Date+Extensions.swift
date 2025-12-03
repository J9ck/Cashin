//
//  Date+Extensions.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import Foundation

extension Date {
    /// Returns the start of the day for this date
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// Checks if the date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// Compares if two dates are on the same day
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}
