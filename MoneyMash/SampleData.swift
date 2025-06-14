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
            // Current Accounts
            FinancialAccount(type: .currentAccount, provider: "Monzo", balance: 2847.32),
            FinancialAccount(type: .currentAccount, provider: "Starling Bank", balance: 1256.78),
            
            // Savings Accounts
            FinancialAccount(type: .savingsAccount, provider: "Marcus by Goldman Sachs", balance: 15400.00),
            FinancialAccount(type: .savingsAccount, provider: "Chase", balance: 8750.50),
            
            // ISAs
            FinancialAccount(type: .cashISA, provider: "Nationwide", balance: 20000.00),
            FinancialAccount(type: .stocksAndSharesISA, provider: "Vanguard", balance: 18750.25),
            FinancialAccount(type: .stocksAndSharesISA, provider: "Hargreaves Lansdown", balance: 15420.85),
            FinancialAccount(type: .lifetimeISA, provider: "Monzo", balance: 12500.00),
            FinancialAccount(type: .juniorISA, provider: "Fidelity", balance: 5680.40),
            
            // Investment Accounts
            FinancialAccount(type: .generalInvestmentAccount, provider: "Interactive Investor", balance: 25750.60),
            FinancialAccount(type: .generalInvestmentAccount, provider: "AJ Bell", balance: 32100.15),
            
            // Pensions
            FinancialAccount(type: .pension, provider: "Aviva", balance: 125000.00),
            FinancialAccount(type: .pension, provider: "Legal & General", balance: 85500.75),
            FinancialAccount(type: .pension, provider: "Scottish Widows", balance: 67250.30),
            FinancialAccount(type: .juniorSIPP, provider: "AJ Bell", balance: 8500.00),
            
            // Debt Accounts (negative balances)
            FinancialAccount(type: .mortgage, provider: "Nationwide", balance: -285000.00),
            FinancialAccount(type: .mortgage, provider: "Halifax", balance: -195750.50),
            FinancialAccount(type: .loan, provider: "Santander", balance: -15600.00),
            FinancialAccount(type: .creditCard, provider: "American Express", balance: -1247.50),
            FinancialAccount(type: .creditCard, provider: "Barclaycard", balance: -892.75),
            
            // Alternative Assets
            FinancialAccount(type: .crypto, provider: "Coinbase", balance: 4250.80),
            FinancialAccount(type: .crypto, provider: "Kraken", balance: 2890.45),
            FinancialAccount(type: .foreignCurrency, provider: "Wise", balance: 1150.25),
            FinancialAccount(type: .cash, provider: "Physical Cash", balance: 320.00),
            
            // Additional accounts for variety
            FinancialAccount(type: .currentAccount, provider: "First Direct", balance: 3420.90),
            FinancialAccount(type: .savingsAccount, provider: "Virgin Money", balance: 11200.00),
            FinancialAccount(type: .stocksAndSharesISA, provider: "Freetrade", balance: 9875.40),
            FinancialAccount(type: .generalInvestmentAccount, provider: "Trading 212", balance: 6540.20),
            FinancialAccount(type: .pension, provider: "Nest", balance: 45600.85),
            FinancialAccount(type: .creditCard, provider: "John Lewis Partnership", balance: -456.30)
        ]
    }
}
#endif