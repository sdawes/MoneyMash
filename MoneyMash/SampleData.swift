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
        // Check if we already have data
        let fetchDescriptor = FetchDescriptor<FinancialAccount>()
        let existingAccounts = (try? context.fetch(fetchDescriptor)) ?? []
        
        guard existingAccounts.isEmpty else { return }
        
        // Create accounts based on your actual portfolio
        let cashISA_T212 = FinancialAccount(type: .cashISA, provider: "Trading 212")
        let stocksISA_T212 = FinancialAccount(type: .stocksAndSharesISA, provider: "Trading 212")
        let stocksISA_HL = FinancialAccount(type: .stocksAndSharesISA, provider: "HL")
        let pension_HL = FinancialAccount(type: .pension, provider: "HL")
        let savings_HL = FinancialAccount(type: .savingsAccount, provider: "HL")
        let cashISA_Monzo = FinancialAccount(type: .cashISA, provider: "Monzo")
        let savings_Monzo = FinancialAccount(type: .savingsAccount, provider: "Monzo")
        let creditCard_Barclays = FinancialAccount(type: .creditCard, provider: "Barclays")
        let creditCard_AMEX = FinancialAccount(type: .creditCard, provider: "AMEX")
        
        // Insert accounts
        let accounts = [cashISA_T212, stocksISA_T212, stocksISA_HL, pension_HL, savings_HL, 
                       cashISA_Monzo, savings_Monzo, creditCard_Barclays, creditCard_AMEX]
        accounts.forEach { context.insert($0) }
        
        // Create historical balance updates
        let calendar = Calendar.current
        let now = Date()
        
        // Cash ISA Trading 212 - Current: £21,881.80
        let cashISA_T212_Balances: [Decimal] = [21881.80, 21456.23, 20998.76, 20123.45, 19785.67, 19234.89]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: cashISA_T212_Balances[i], date: date, account: cashISA_T212)
            context.insert(update)
        }
        
        // Stocks & Shares ISA Trading 212 - Current: £4,296.51
        let stocksISA_T212_Balances: [Decimal] = [4296.51, 4089.34, 3876.23, 3654.12, 3423.78, 3198.45]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: stocksISA_T212_Balances[i], date: date, account: stocksISA_T212)
            context.insert(update)
        }
        
        // Stocks & Shares ISA HL - Current: £12,259.78
        let stocksISA_HL_Balances: [Decimal] = [12259.78, 11876.23, 11523.45, 11089.67, 10654.89, 10234.12]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: stocksISA_HL_Balances[i], date: date, account: stocksISA_HL)
            context.insert(update)
        }
        
        // Pension HL - Current: £71,688
        let pension_HL_Balances: [Decimal] = [71688.00, 70234.56, 68789.23, 67345.67, 65901.34, 64456.78]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: pension_HL_Balances[i], date: date, account: pension_HL)
            context.insert(update)
        }
        
        // Cash Savings HL - Current: £44,775.93
        let savings_HL_Balances: [Decimal] = [44775.93, 43234.67, 41789.45, 40345.23, 38901.56, 37456.89]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: savings_HL_Balances[i], date: date, account: savings_HL)
            context.insert(update)
        }
        
        // Cash ISA Monzo - Current: £18,563.69
        let cashISA_Monzo_Balances: [Decimal] = [18563.69, 17234.45, 15876.23, 14567.89, 13234.56, 11901.23]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: cashISA_Monzo_Balances[i], date: date, account: cashISA_Monzo)
            context.insert(update)
        }
        
        // Cash Savings Monzo - Current: £59,329.11
        let savings_Monzo_Balances: [Decimal] = [59329.11, 57234.78, 55189.45, 53134.67, 51078.23, 49023.89]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: savings_Monzo_Balances[i], date: date, account: savings_Monzo)
            context.insert(update)
        }
        
        // Credit Card Barclays - Current: £270.31 debt (negative)
        let creditCard_Barclays_Balances: [Decimal] = [-270.31, -189.45, -345.67, -123.89, -456.78, -234.56]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: creditCard_Barclays_Balances[i], date: date, account: creditCard_Barclays)
            context.insert(update)
        }
        
        // Credit Card AMEX - Current: £650.18 debt (negative)
        let creditCard_AMEX_Balances: [Decimal] = [-650.18, -567.89, -789.34, -423.67, -834.56, -612.45]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: creditCard_AMEX_Balances[i], date: date, account: creditCard_AMEX)
            context.insert(update)
        }
        
        // Save all changes
        try? context.save()
    }
}
#endif