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
        
        // Create historical balance updates for each account
        createHistoricalUpdates(for: sampleAccounts, context: context)
        
        // Save the context
        do {
            try context.save()
            print("Successfully populated database with \(sampleAccounts.count) sample accounts and historical updates")
        } catch {
            print("Failed to save sample data: \(error)")
        }
    }
    
    private static func createSampleAccounts() -> [FinancialAccount] {
        return [
            // Current Account
            FinancialAccount(type: .currentAccount, provider: "Monzo"),
            
            // Savings Accounts (couple as requested)
            FinancialAccount(type: .savingsAccount, provider: "Marcus by Goldman Sachs"),
            FinancialAccount(type: .savingsAccount, provider: "Chase"),
            
            // ISAs (one of each type)
            FinancialAccount(type: .cashISA, provider: "Nationwide"),
            FinancialAccount(type: .stocksAndSharesISA, provider: "Vanguard"),
            FinancialAccount(type: .lifetimeISA, provider: "Monzo"),
            FinancialAccount(type: .juniorISA, provider: "Fidelity"),
            
            // Investment Account
            FinancialAccount(type: .generalInvestmentAccount, provider: "Interactive Investor"),
            
            // Pensions (two as requested)
            FinancialAccount(type: .pension, provider: "Aviva"),
            FinancialAccount(type: .pension, provider: "Legal & General"),
            FinancialAccount(type: .juniorSIPP, provider: "AJ Bell"),
            
            // Debt Accounts
            FinancialAccount(type: .mortgage, provider: "Nationwide"),
            FinancialAccount(type: .loan, provider: "Santander"),
            FinancialAccount(type: .creditCard, provider: "American Express"),
            
            // Alternative Assets
            FinancialAccount(type: .crypto, provider: "Coinbase"),
            FinancialAccount(type: .foreignCurrency, provider: "Wise"),
            FinancialAccount(type: .cash, provider: "Physical Cash")
        ]
    }
    
    private static func createHistoricalUpdates(for accounts: [FinancialAccount], context: ModelContext) {
        let calendar = Calendar.current
        
        // Create dates for the last 4 months (March to June 2025)
        guard let march1 = calendar.date(from: DateComponents(year: 2025, month: 3, day: 1)),
              let april1 = calendar.date(from: DateComponents(year: 2025, month: 4, day: 1)),
              let may1 = calendar.date(from: DateComponents(year: 2025, month: 5, day: 1)),
              let june1 = calendar.date(from: DateComponents(year: 2025, month: 6, day: 1)) else {
            return
        }
        
        for account in accounts {
            switch account.type {
            case .currentAccount:
                createCurrentAccountHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .savingsAccount:
                createSavingsAccountHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .cashISA, .stocksAndSharesISA, .lifetimeISA, .juniorISA:
                createISAHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .generalInvestmentAccount:
                createInvestmentHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .pension, .juniorSIPP:
                createPensionHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .mortgage:
                createMortgageHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .loan:
                createLoanHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .creditCard:
                createCreditCardHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .crypto:
                createCryptoHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .foreignCurrency:
                createForeignCurrencyHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            case .cash:
                createCashHistory(account: account, march1: march1, april1: april1, may1: may1, june1: june1, context: context)
            }
        }
    }
    
    // MARK: - Account-specific history creators
    
    private static func createCurrentAccountHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        let calendar = Calendar.current
        
        // March - initial balance
        let march3 = calendar.date(byAdding: .day, value: 2, to: march1)!
        context.insert(BalanceUpdate(balance: 1256.78, date: march3, account: account))
        
        // April - salary + spending
        let april2 = calendar.date(byAdding: .day, value: 1, to: april1)!
        context.insert(BalanceUpdate(balance: 3420.90, date: april2, account: account))
        
        let april15 = calendar.date(byAdding: .day, value: 14, to: april1)!
        context.insert(BalanceUpdate(balance: 2180.45, date: april15, account: account))
        
        // May - salary + spending
        let may1st = calendar.date(byAdding: .day, value: 0, to: may1)!
        context.insert(BalanceUpdate(balance: 4250.30, date: may1st, account: account))
        
        // June - current balance
        let june3 = calendar.date(byAdding: .day, value: 2, to: june1)!
        context.insert(BalanceUpdate(balance: 2847.32, date: june3, account: account))
    }
    
    private static func createSavingsAccountHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        let calendar = Calendar.current
        let isFirstSavings = account.provider == "Marcus by Goldman Sachs"
        
        if isFirstSavings {
            // Marcus - growing significantly
            context.insert(BalanceUpdate(balance: 12800.00, date: march1, account: account))
            context.insert(BalanceUpdate(balance: 13950.00, date: april1, account: account))
            context.insert(BalanceUpdate(balance: 14600.00, date: may1, account: account))
            let june2 = calendar.date(byAdding: .day, value: 1, to: june1)!
            context.insert(BalanceUpdate(balance: 15400.00, date: june2, account: account))
        } else {
            // Chase - slower growth
            context.insert(BalanceUpdate(balance: 7500.00, date: march1, account: account))
            context.insert(BalanceUpdate(balance: 8000.50, date: april1, account: account))
            context.insert(BalanceUpdate(balance: 8350.25, date: may1, account: account))
            let june4 = calendar.date(byAdding: .day, value: 3, to: june1)!
            context.insert(BalanceUpdate(balance: 8750.50, date: june4, account: account))
        }
    }
    
    private static func createISAHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        let calendar = Calendar.current
        
        switch account.type {
        case .cashISA:
            // Nationwide Cash ISA - steady contributions
            context.insert(BalanceUpdate(balance: 16000.00, date: march1, account: account))
            context.insert(BalanceUpdate(balance: 17500.00, date: april1, account: account))
            context.insert(BalanceUpdate(balance: 19000.00, date: may1, account: account))
            let june1st = calendar.date(byAdding: .day, value: 0, to: june1)!
            context.insert(BalanceUpdate(balance: 20000.00, date: june1st, account: account))
            
        case .stocksAndSharesISA:
            // Vanguard S&S ISA - market fluctuations
            context.insert(BalanceUpdate(balance: 16420.80, date: march1, account: account))
            context.insert(BalanceUpdate(balance: 17890.45, date: april1, account: account))
            let may15 = calendar.date(byAdding: .day, value: 14, to: may1)!
            context.insert(BalanceUpdate(balance: 18120.65, date: may15, account: account))
            let june5 = calendar.date(byAdding: .day, value: 4, to: june1)!
            context.insert(BalanceUpdate(balance: 18750.25, date: june5, account: account))
            
        case .lifetimeISA:
            // Monzo LISA - monthly contributions
            context.insert(BalanceUpdate(balance: 9500.00, date: march1, account: account))
            context.insert(BalanceUpdate(balance: 10750.00, date: april1, account: account))
            context.insert(BalanceUpdate(balance: 11600.00, date: may1, account: account))
            let june2 = calendar.date(byAdding: .day, value: 1, to: june1)!
            context.insert(BalanceUpdate(balance: 12500.00, date: june2, account: account))
            
        case .juniorISA:
            // Fidelity Junior ISA - occasional contributions
            context.insert(BalanceUpdate(balance: 4800.20, date: march1, account: account))
            context.insert(BalanceUpdate(balance: 5240.80, date: may1, account: account))
            let june8 = calendar.date(byAdding: .day, value: 7, to: june1)!
            context.insert(BalanceUpdate(balance: 5680.40, date: june8, account: account))
            
        default:
            break
        }
    }
    
    private static func createInvestmentHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        let calendar = Calendar.current
        
        // Interactive Investor - volatile market movements
        context.insert(BalanceUpdate(balance: 22450.30, date: march1, account: account))
        let march20 = calendar.date(byAdding: .day, value: 19, to: march1)!
        context.insert(BalanceUpdate(balance: 21890.75, date: march20, account: account))
        context.insert(BalanceUpdate(balance: 24120.40, date: april1, account: account))
        let may3 = calendar.date(byAdding: .day, value: 2, to: may1)!
        context.insert(BalanceUpdate(balance: 25750.60, date: may3, account: account))
    }
    
    private static func createPensionHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        let calendar = Calendar.current
        
        if account.provider == "Aviva" {
            // Aviva pension - quarterly updates
            context.insert(BalanceUpdate(balance: 118500.00, date: march1, account: account))
            let june15 = calendar.date(byAdding: .day, value: 14, to: june1)!
            context.insert(BalanceUpdate(balance: 125000.00, date: june15, account: account))
        } else if account.provider == "Legal & General" {
            // L&G pension - quarterly updates
            context.insert(BalanceUpdate(balance: 79200.50, date: march1, account: account))
            let june10 = calendar.date(byAdding: .day, value: 9, to: june1)!
            context.insert(BalanceUpdate(balance: 85500.75, date: june10, account: account))
        } else {
            // Junior SIPP - less frequent updates
            context.insert(BalanceUpdate(balance: 7850.00, date: march1, account: account))
            let june6 = calendar.date(byAdding: .day, value: 5, to: june1)!
            context.insert(BalanceUpdate(balance: 8500.00, date: june6, account: account))
        }
    }
    
    private static func createMortgageHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        // Nationwide mortgage - monthly payments reducing balance
        context.insert(BalanceUpdate(balance: -288500.00, date: march1, account: account))
        context.insert(BalanceUpdate(balance: -287200.00, date: april1, account: account))
        context.insert(BalanceUpdate(balance: -286100.00, date: may1, account: account))
        context.insert(BalanceUpdate(balance: -285000.00, date: june1, account: account))
    }
    
    private static func createLoanHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        // Santander loan - monthly payments
        context.insert(BalanceUpdate(balance: -17200.00, date: march1, account: account))
        context.insert(BalanceUpdate(balance: -16400.00, date: april1, account: account))
        context.insert(BalanceUpdate(balance: -16000.00, date: may1, account: account))
        context.insert(BalanceUpdate(balance: -15600.00, date: june1, account: account))
    }
    
    private static func createCreditCardHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        let calendar = Calendar.current
        
        // AMEX - fluctuating balance
        context.insert(BalanceUpdate(balance: -892.50, date: march1, account: account))
        let march15 = calendar.date(byAdding: .day, value: 14, to: march1)!
        context.insert(BalanceUpdate(balance: -1456.75, date: march15, account: account))
        context.insert(BalanceUpdate(balance: -678.20, date: april1, account: account))
        let may20 = calendar.date(byAdding: .day, value: 19, to: may1)!
        context.insert(BalanceUpdate(balance: -1247.50, date: may20, account: account))
    }
    
    private static func createCryptoHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        let calendar = Calendar.current
        
        // Coinbase - volatile crypto market
        context.insert(BalanceUpdate(balance: 3420.60, date: march1, account: account))
        let march10 = calendar.date(byAdding: .day, value: 9, to: march1)!
        context.insert(BalanceUpdate(balance: 2890.40, date: march10, account: account))
        context.insert(BalanceUpdate(balance: 3850.75, date: april1, account: account))
        let may12 = calendar.date(byAdding: .day, value: 11, to: may1)!
        context.insert(BalanceUpdate(balance: 4680.90, date: may12, account: account))
        let june7 = calendar.date(byAdding: .day, value: 6, to: june1)!
        context.insert(BalanceUpdate(balance: 4250.80, date: june7, account: account))
    }
    
    private static func createForeignCurrencyHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        let calendar = Calendar.current
        
        // Wise - exchange rate fluctuations
        context.insert(BalanceUpdate(balance: 980.50, date: march1, account: account))
        context.insert(BalanceUpdate(balance: 1085.75, date: april1, account: account))
        let june4 = calendar.date(byAdding: .day, value: 3, to: june1)!
        context.insert(BalanceUpdate(balance: 1150.25, date: june4, account: account))
    }
    
    private static func createCashHistory(account: FinancialAccount, march1: Date, april1: Date, may1: Date, june1: Date, context: ModelContext) {
        let calendar = Calendar.current
        
        // Physical cash - occasional updates
        context.insert(BalanceUpdate(balance: 450.00, date: march1, account: account))
        let may25 = calendar.date(byAdding: .day, value: 24, to: may1)!
        context.insert(BalanceUpdate(balance: 320.00, date: may25, account: account))
    }
}
#endif