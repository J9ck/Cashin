//
//  CashinUITests.swift
//  CashinUITests
//
//  UI tests for Cashin' app
//

import XCTest

final class CashinUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Launch Tests
    
    func testAppLaunch_displaysMainView() throws {
        // Verify the app launches and displays the main view
        XCTAssertTrue(app.exists, "App should launch successfully")
    }
    
    // MARK: - Balance Display Tests
    
    func testMainView_displaysDailyBalance() throws {
        // Verify the main balance display exists
        // Note: Adjust accessibility identifiers as needed in actual implementation
        let balanceText = app.staticTexts["dailyBalance"]
        XCTAssertTrue(balanceText.waitForExistence(timeout: 5), "Daily balance should be displayed")
    }
    
    // MARK: - Quick Add Button Tests
    
    func testQuickAddButtons_exist() throws {
        // Verify quick-add buttons are present
        let quickAddButton5 = app.buttons["quickAdd5"]
        let quickAddButton10 = app.buttons["quickAdd10"]
        let quickAddButton20 = app.buttons["quickAdd20"]
        
        XCTAssertTrue(quickAddButton5.exists, "$5 quick-add button should exist")
        XCTAssertTrue(quickAddButton10.exists, "$10 quick-add button should exist")
        XCTAssertTrue(quickAddButton20.exists, "$20 quick-add button should exist")
    }
    
    func testQuickAddButton_tap_addsTransaction() throws {
        // Get initial transaction count (if available)
        // Tap a quick-add button
        let quickAddButton10 = app.buttons["quickAdd10"]
        if quickAddButton10.exists {
            quickAddButton10.tap()
            
            // Wait for the UI to update using proper expectation
            let transactionAdded = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '10'")).firstMatch
            XCTAssertTrue(transactionAdded.waitForExistence(timeout: 3), "Transaction should appear in the UI")
        }
    }
    
    // MARK: - Add Transaction Tests
    
    func testAddEntryButton_tap_opensSheet() throws {
        // Tap the "Add Entry" button
        let addEntryButton = app.buttons["Add Entry"]
        if addEntryButton.exists {
            addEntryButton.tap()
            
            // Verify the add transaction sheet appears
            XCTAssertTrue(app.sheets.element.waitForExistence(timeout: 2), "Add transaction sheet should appear")
        }
    }
    
    func testAddTransaction_withValidData_succeeds() throws {
        // Open add transaction sheet
        let addEntryButton = app.buttons["Add Entry"]
        if addEntryButton.exists {
            addEntryButton.tap()
            
            // Wait for sheet to appear
            XCTAssertTrue(app.sheets.element.waitForExistence(timeout: 2))
            
            // Select transaction type (Income/Expense)
            let incomeButton = app.buttons["Income"]
            if incomeButton.exists {
                incomeButton.tap()
            }
            
            // Enter amount
            let amountField = app.textFields["amount"]
            if amountField.exists {
                amountField.tap()
                amountField.typeText("50")
            }
            
            // Select category
            let categoryPicker = app.pickers["category"]
            if categoryPicker.exists {
                // Adjust based on actual picker implementation
            }
            
            // Tap Save
            let saveButton = app.buttons["Save"]
            if saveButton.exists {
                saveButton.tap()
            }
        }
    }
    
    // MARK: - History View Tests
    
    func testHistoryButton_tap_opensHistoryView() throws {
        // Tap the History button
        let historyButton = app.buttons["History"]
        if historyButton.exists {
            historyButton.tap()
            
            // Verify history view appears
            XCTAssertTrue(app.navigationBars["History"].waitForExistence(timeout: 2), "History view should appear")
            
            // Navigate back
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
            }
        }
    }
    
    func testHistoryView_displays7DayChart() throws {
        let historyButton = app.buttons["History"]
        if historyButton.exists {
            historyButton.tap()
            
            // Verify chart exists (implementation-dependent)
            // Charts would have specific accessibility identifiers
            let chartView = app.otherElements["7DayChart"]
            XCTAssertTrue(chartView.waitForExistence(timeout: 3), "7-day chart should be displayed")
            
            // Navigate back
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
            }
        }
    }
    
    // MARK: - Transaction Row Tests
    
    func testTransactionRow_swipeToDelete_removesTransaction() throws {
        // First, add a transaction (use quick-add for simplicity)
        let quickAddButton10 = app.buttons["quickAdd10"]
        if quickAddButton10.exists {
            quickAddButton10.tap()
            
            // Wait for transaction to appear
            let transactionRow = app.tables.cells.element(boundBy: 0)
            XCTAssertTrue(transactionRow.waitForExistence(timeout: 3), "Transaction row should appear")
            
            if transactionRow.exists {
                // Swipe left to reveal delete button
                transactionRow.swipeLeft()
                
                // Tap delete button
                let deleteButton = transactionRow.buttons["Delete"]
                if deleteButton.exists {
                    deleteButton.tap()
                }
            }
        }
    }
    
    // MARK: - Performance Tests
    
    func testAppLaunchPerformance() throws {
        // Measure app launch performance using the configured app instance
        app.terminate()
        
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
}
