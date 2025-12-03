//
//  DateExtensionsTests.swift
//  CashinTests
//
//  Unit tests for Date extension helpers
//

import XCTest
@testable import Cashin

final class DateExtensionsTests: XCTestCase {
    
    // MARK: - Start of Day Tests
    
    func testStartOfDay_returnsCorrectDate() throws {
        // Arrange
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2025, month: 12, day: 3, hour: 14, minute: 30)) else {
            XCTFail("Failed to create test date")
            return
        }
        
        // Act
        let startOfDay = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startOfDay)
        
        // Assert
        XCTAssertEqual(components.year, 2025)
        XCTAssertEqual(components.month, 12)
        XCTAssertEqual(components.day, 3)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.second, 0)
    }
    
    // MARK: - Date Comparison Tests
    
    func testIsToday_withTodaysDate_returnsTrue() {
        // Arrange
        let today = Date()
        
        // Act
        let result = Calendar.current.isDateInToday(today)
        
        // Assert
        XCTAssertTrue(result, "Today's date should be recognized as today")
    }
    
    func testIsToday_withYesterdaysDate_returnsFalse() throws {
        // Arrange
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            XCTFail("Failed to create yesterday's date")
            return
        }
        
        // Act
        let result = Calendar.current.isDateInToday(yesterday)
        
        // Assert
        XCTAssertFalse(result, "Yesterday's date should not be recognized as today")
    }
    
    func testIsYesterday_withYesterdaysDate_returnsTrue() throws {
        // Arrange
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            XCTFail("Failed to create yesterday's date")
            return
        }
        
        // Act
        let result = Calendar.current.isDateInYesterday(yesterday)
        
        // Assert
        XCTAssertTrue(result, "Yesterday's date should be recognized as yesterday")
    }
    
    // MARK: - Date Addition Tests
    
    func testAddingDays_toDate_returnsCorrectDate() throws {
        // Arrange
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 1)) else {
            XCTFail("Failed to create start date")
            return
        }
        
        // Act
        guard let resultDate = calendar.date(byAdding: .day, value: 7, to: startDate) else {
            XCTFail("Failed to add days to date")
            return
        }
        let components = calendar.dateComponents([.year, .month, .day], from: resultDate)
        
        // Assert
        XCTAssertEqual(components.year, 2025)
        XCTAssertEqual(components.month, 12)
        XCTAssertEqual(components.day, 8)
    }
    
    // MARK: - Date Formatting Tests
    
    func testDateFormatting_withStandardFormat_returnsCorrectString() throws {
        // Arrange
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2025, month: 12, day: 3)) else {
            XCTFail("Failed to create test date")
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // Act
        let formattedDate = formatter.string(from: date)
        
        // Assert
        XCTAssertEqual(formattedDate, "2025-12-03")
    }
    
    // MARK: - Days Between Tests
    
    func testDaysBetween_twoDates_returnsCorrectDifference() throws {
        // Arrange
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 1)),
              let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 8)) else {
            XCTFail("Failed to create test dates")
            return
        }
        
        // Act
        let days = calendar.dateComponents([.day], from: startDate, to: endDate).day
        
        // Assert
        XCTAssertEqual(days, 7, "Should be 7 days between December 1 and December 8")
    }
}
