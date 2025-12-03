//
//  TransactionTests.swift
//  CashinTests
//
//  Unit tests for Transaction model
//

import XCTest
import SwiftData
@testable import Cashin

final class TransactionTests: XCTestCase {
    
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    
    override func setUp() {
        super.setUp()
        // Create an in-memory model container for testing
        let schema = Schema([Transaction.self, DailySummary.self, AppSettings.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Could not create ModelContainer for testing: \(error)")
        }
    }
    
    override func tearDown() {
        modelContainer = nil
        modelContext = nil
        super.tearDown()
    }
    
    // MARK: - Transaction Creation Tests
    
    func testTransactionCreation_withValidData_succeeds() {
        // Arrange
        let amount = 25.50
        let type = TransactionType.income
        let category = "Work"
        let date = Date()
        
        // Act
        let transaction = Transaction(
            amount: amount,
            category: category,
            type: type,
            date: date
        )
        
        // Assert
        XCTAssertEqual(transaction.amount, amount, "Transaction amount should match")
        XCTAssertEqual(transaction.type, type, "Transaction type should match")
        XCTAssertEqual(transaction.category, category, "Transaction category should match")
        XCTAssertEqual(transaction.date, date, "Transaction date should match")
    }
    
    func testTransactionInsertion_intoContext_succeeds() {
        // Arrange
        let transaction = Transaction(
            amount: 50.0,
            category: "Food",
            type: .expense,
            date: Date()
        )
        
        // Act
        modelContext.insert(transaction)
        
        do {
            try modelContext.save()
            
            // Assert
            let fetchDescriptor = FetchDescriptor<Transaction>()
            let transactions = try modelContext.fetch(fetchDescriptor)
            XCTAssertEqual(transactions.count, 1, "Should have one transaction")
            XCTAssertEqual(transactions.first?.amount, 50.0, "Transaction amount should be saved correctly")
        } catch {
            XCTFail("Failed to save or fetch transaction: \(error)")
        }
    }
    
    // MARK: - Transaction Type Tests
    
    func testTransactionType_income_isCorrect() {
        // Arrange & Act
        let transaction = Transaction(
            amount: 100.0,
            category: "Freelance",
            type: .income,
            date: Date()
        )
        
        // Assert
        XCTAssertEqual(transaction.type, .income, "Transaction type should be income")
    }
    
    func testTransactionType_expense_isCorrect() {
        // Arrange & Act
        let transaction = Transaction(
            amount: 75.0,
            category: "Transport",
            type: .expense,
            date: Date()
        )
        
        // Assert
        XCTAssertEqual(transaction.type, .expense, "Transaction type should be expense")
    }
    
    // MARK: - Transaction Deletion Tests
    
    func testTransactionDeletion_fromContext_succeeds() {
        // Arrange
        let transaction = Transaction(
            amount: 30.0,
            category: "Bonus",
            type: .income,
            date: Date()
        )
        modelContext.insert(transaction)
        
        do {
            try modelContext.save()
            
            // Act
            modelContext.delete(transaction)
            try modelContext.save()
            
            // Assert
            let fetchDescriptor = FetchDescriptor<Transaction>()
            let transactions = try modelContext.fetch(fetchDescriptor)
            XCTAssertEqual(transactions.count, 0, "Should have no transactions after deletion")
        } catch {
            XCTFail("Failed to delete transaction: \(error)")
        }
    }
    
    // MARK: - Multiple Transactions Tests
    
    func testMultipleTransactions_calculation_isCorrect() {
        // Arrange
        let income1 = Transaction(amount: 100.0, category: "Work", type: .income, date: Date())
        let income2 = Transaction(amount: 50.0, category: "Freelance", type: .income, date: Date())
        let expense1 = Transaction(amount: 30.0, category: "Food", type: .expense, date: Date())
        let expense2 = Transaction(amount: 20.0, category: "Transport", type: .expense, date: Date())
        
        modelContext.insert(income1)
        modelContext.insert(income2)
        modelContext.insert(expense1)
        modelContext.insert(expense2)
        
        do {
            try modelContext.save()
            
            // Act
            let fetchDescriptor = FetchDescriptor<Transaction>()
            let transactions = try modelContext.fetch(fetchDescriptor)
            
            let totalIncome = transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
            let totalExpense = transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
            let netBalance = totalIncome - totalExpense
            
            // Assert
            XCTAssertEqual(totalIncome, 150.0, "Total income should be 150.0")
            XCTAssertEqual(totalExpense, 50.0, "Total expense should be 50.0")
            XCTAssertEqual(netBalance, 100.0, "Net balance should be 100.0")
        } catch {
            XCTFail("Failed to fetch and calculate transactions: \(error)")
        }
    }
}
