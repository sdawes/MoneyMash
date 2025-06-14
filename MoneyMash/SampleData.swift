//
//  SampleData.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

#if DEBUG
struct SampleData {
    
    static func populateIfEmpty(context: ModelContext) {
        // Check if database is already populated
        let descriptor = FetchDescriptor<FinancialAccount>()
        let existingAccounts = try? context.fetch(descriptor)
        
        guard existingAccounts?.isEmpty == true else {
            print("Database already contains accounts, skipping sample data population")
            return
        }
        
        print("Database is empty, populating with sample data...")
        
        // Create sample accounts with realistic UK financial data
        let sampleAccounts = createSampleAccounts()
        
        // Insert all sample accounts
        for account in sampleAccounts {
            context.insert(account)
        }
        
        // Save the context
        do {
            try context.save()
            print("Successfully populated database with \(sampleAccounts.count) sample accounts")
        } catch {
            print("Failed to save sample data: \(error)")
        }
    }
    
    private static func createSampleAccounts() -> [FinancialAccount] {
        return [
            // Current Account
            FinancialAccount(type: .currentAccount, provider: "Monzo", balance: 2847.32),
            
            // Savings Accounts (couple as requested)
            FinancialAccount(type: .savingsAccount, provider: "Marcus by Goldman Sachs", balance: 15400.00),
            FinancialAccount(type: .savingsAccount, provider: "Chase", balance: 8750.50),
            
            // ISAs (one of each type)
            FinancialAccount(type: .cashISA, provider: "Nationwide", balance: 20000.00),
            FinancialAccount(type: .stocksAndSharesISA, provider: "Vanguard", balance: 18750.25),
            FinancialAccount(type: .lifetimeISA, provider: "Monzo", balance: 12500.00),
            FinancialAccount(type: .juniorISA, provider: "Fidelity", balance: 5680.40),
            
            // Investment Account
            FinancialAccount(type: .generalInvestmentAccount, provider: "Interactive Investor", balance: 25750.60),
            
            // Pensions (two as requested)
            FinancialAccount(type: .pension, provider: "Aviva", balance: 125000.00),
            FinancialAccount(type: .pension, provider: "Legal & General", balance: 85500.75),
            FinancialAccount(type: .juniorSIPP, provider: "AJ Bell", balance: 8500.00),
            
            // Debt Accounts
            FinancialAccount(type: .mortgage, provider: "Nationwide", balance: -285000.00),
            FinancialAccount(type: .loan, provider: "Santander", balance: -15600.00),
            FinancialAccount(type: .creditCard, provider: "American Express", balance: -1247.50),
            
            // Alternative Assets
            FinancialAccount(type: .crypto, provider: "Coinbase", balance: 4250.80),
            FinancialAccount(type: .foreignCurrency, provider: "Wise", balance: 1150.25),
            FinancialAccount(type: .cash, provider: "Physical Cash", balance: 320.00)
        ]
    }
}
#endif