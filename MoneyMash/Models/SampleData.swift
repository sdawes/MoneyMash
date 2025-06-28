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
    // MARK: - Sample Data 1 (Original)
    /*
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
    */
    
    // MARK: - Sample Data 2 (Extended 3-Year History) - COMMENTED OUT
    /*
    static func populateIfEmpty(context: ModelContext) {
        // Check if we already have data
        let fetchDescriptor = FetchDescriptor<FinancialAccount>()
        let existingAccounts = (try? context.fetch(fetchDescriptor)) ?? []
        
        guard existingAccounts.isEmpty else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Create test accounts with significant growth over 3 years
        let pension = FinancialAccount(type: .pension, provider: "Vanguard")
        let stocksISA = FinancialAccount(type: .stocksAndSharesISA, provider: "Trading 212")
        let savings = FinancialAccount(type: .savingsAccount, provider: "Marcus")
        let mortgage = FinancialAccount(type: .mortgage, provider: "Halifax")
        let creditCard = FinancialAccount(type: .creditCard, provider: "Chase")
        
        let accounts = [pension, stocksISA, savings, mortgage, creditCard]
        accounts.forEach { context.insert($0) }
        
        // Pension: 36 months of growth from £45K to £185K
        let pensionBalances: [Decimal] = [
            45000, 46200, 47800, 49100, 50500, 52000, 53800, 55200, 56900, 58400, 60100, 61800,
            63500, 65400, 67200, 68900, 70800, 72500, 74400, 76200, 78100, 80000, 82100, 84000,
            86200, 88400, 90700, 93000, 95500, 98000, 100800, 103500, 106400, 109200, 112300, 185000
        ]
        
        // Stocks ISA: 36 months of volatile growth from £8K to £62K
        let stocksBalances: [Decimal] = [
            8000, 8200, 7800, 8500, 9200, 10100, 9600, 10800, 11500, 10900, 12400, 13200,
            12800, 14100, 15600, 14900, 16800, 18200, 17500, 19400, 21100, 20300, 22800, 24500,
            23800, 26200, 28900, 27600, 30800, 33500, 32100, 35400, 38700, 41200, 44800, 62000
        ]
        
        // Savings: 36 months of steady growth from £25K to £145K
        let savingsBalances: [Decimal] = [
            25000, 28500, 32000, 35200, 38800, 42100, 45600, 49000, 52500, 55900, 59400, 62800,
            66300, 69700, 73200, 76600, 80100, 83500, 87000, 90400, 93900, 97300, 100800, 104200,
            107700, 111100, 114600, 118000, 121500, 124900, 128400, 131800, 135300, 138700, 142200, 145000
        ]
        
        // Mortgage: 36 months of decreasing debt from £485K to £425K
        let mortgageBalances: [Decimal] = [
            -485000, -483200, -481500, -479700, -477900, -476200, -474400, -472600, -470900, -469100, -467300, -465600,
            -463800, -462000, -460300, -458500, -456700, -455000, -453200, -451400, -449700, -447900, -446100, -444400,
            -442600, -440800, -439100, -437300, -435500, -433800, -432000, -430200, -428500, -426700, -424900, -425000
        ]
        
        // Credit Card: 36 months of fluctuating debt
        let creditCardBalances: [Decimal] = [
            -1200, -800, -1500, -2100, -900, -1800, -650, -2300, -1100, -1900, -750, -2500,
            -1300, -2000, -850, -1600, -1400, -2200, -950, -1700, -1250, -2100, -600, -1800,
            -1350, -2400, -800, -1500, -1150, -1900, -700, -2000, -1050, -1600, -900, -1200
        ]
        
        // Create balance updates for each account
        for i in 0..<36 {
            let date = calendar.date(byAdding: .month, value: -(35 - i), to: now)!
            
            let pensionUpdate = BalanceUpdate(balance: pensionBalances[i], date: date, account: pension)
            let stocksUpdate = BalanceUpdate(balance: stocksBalances[i], date: date, account: stocksISA)
            let savingsUpdate = BalanceUpdate(balance: savingsBalances[i], date: date, account: savings)
            let mortgageUpdate = BalanceUpdate(balance: mortgageBalances[i], date: date, account: mortgage)
            let creditUpdate = BalanceUpdate(balance: creditCardBalances[i], date: date, account: creditCard)
            
            context.insert(pensionUpdate)
            context.insert(stocksUpdate)
            context.insert(savingsUpdate)
            context.insert(mortgageUpdate)
            context.insert(creditUpdate)
        }
        
        // Save all changes
        try? context.save()
    }
    */
    
    // MARK: - Sample Data 3 (Real Portfolio Data)
    static func populateIfEmpty(context: ModelContext) {
        // Check if we already have data
        let fetchDescriptor = FetchDescriptor<FinancialAccount>()
        let existingAccounts = (try? context.fetch(fetchDescriptor)) ?? []
        
        guard existingAccounts.isEmpty else { return }
        
        let calendar = Calendar.current
        
        // Create accounts based on real portfolio
        let monzoCashISA = FinancialAccount(type: .cashISA, provider: "Monzo")
        let monzoSavings = FinancialAccount(type: .savingsAccount, provider: "Monzo")
        let t212CashISA = FinancialAccount(type: .cashISA, provider: "Trading 212")
        let t212StocksISA = FinancialAccount(type: .stocksAndSharesISA, provider: "Trading 212")
        let hlSavings = FinancialAccount(type: .savingsAccount, provider: "HL")
        let hlStocksISA = FinancialAccount(type: .stocksAndSharesISA, provider: "HL")
        let hlPension = FinancialAccount(type: .pension, provider: "HL")
        
        let accounts = [monzoCashISA, monzoSavings, t212CashISA, t212StocksISA, hlSavings, hlStocksISA, hlPension]
        accounts.forEach { context.insert($0) }
        
        // Real portfolio balances: 1 May 25, 1 Jun 25, 26 Jun 25
        let monzoCashISABalances: [Decimal] = [18502.55, 18563.69, 18563.69]
        let monzoSavingsBalances: [Decimal] = [59133.67, 59329.11, 53924.14]
        let t212CashISABalances: [Decimal] = [21762.77, 21845.73, 21903.48]
        let t212StocksISABalances: [Decimal] = [3695.32, 4230.95, 4286.20]
        let hlSavingsBalances: [Decimal] = [44619.80, 44775.93, 44775.93]
        let hlStocksISABalances: [Decimal] = [11826.95, 12045.36, 12242.74]
        let hlPensionBalances: [Decimal] = [68048.48, 70900.09, 71838.17]
        
        // Create dates: 1 May 25, 1 Jun 25, 26 Jun 25
        let dates = [
            calendar.date(from: DateComponents(year: 2025, month: 5, day: 1))!,
            calendar.date(from: DateComponents(year: 2025, month: 6, day: 1))!,
            calendar.date(from: DateComponents(year: 2025, month: 6, day: 26))!
        ]
        
        // Create balance updates for each account
        let accountBalances = [
            (monzoCashISA, monzoCashISABalances),
            (monzoSavings, monzoSavingsBalances),
            (t212CashISA, t212CashISABalances),
            (t212StocksISA, t212StocksISABalances),
            (hlSavings, hlSavingsBalances),
            (hlStocksISA, hlStocksISABalances),
            (hlPension, hlPensionBalances)
        ]
        
        for (account, balances) in accountBalances {
            for i in 0..<3 {
                let update = BalanceUpdate(balance: balances[i], date: dates[i], account: account)
                context.insert(update)
            }
        }
        
        // Save all changes
        try? context.save()
    }
}
#endif