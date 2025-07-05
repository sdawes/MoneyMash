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
    // MARK: - Database Utilities
    static func clearAllData(context: ModelContext) {
        print("🗑️ [SampleData] Clearing all existing data...")
        
        // Delete all balance updates first (due to relationships)
        let balanceDescriptor = FetchDescriptor<BalanceUpdate>()
        let allBalanceUpdates = (try? context.fetch(balanceDescriptor)) ?? []
        for update in allBalanceUpdates {
            context.delete(update)
        }
        
        // Delete all accounts
        let accountDescriptor = FetchDescriptor<FinancialAccount>()
        let allAccounts = (try? context.fetch(accountDescriptor)) ?? []
        for account in allAccounts {
            context.delete(account)
        }
        
        // Save changes
        do {
            try context.save()
            print("✅ [SampleData] Successfully cleared \(allAccounts.count) accounts and \(allBalanceUpdates.count) balance updates")
        } catch {
            print("❌ [SampleData] Failed to clear data: \(error)")
        }
    }
    
    // MARK: - Sample Data Creation
    static func populateIfEmpty(context: ModelContext) {
        // Check if we already have data
        let fetchDescriptor = FetchDescriptor<FinancialAccount>()
        let existingAccounts = (try? context.fetch(fetchDescriptor)) ?? []
        
        guard existingAccounts.isEmpty else {
            print("📊 [SampleData] Found \(existingAccounts.count) existing accounts - skipping sample data creation")
            return
        }
        
        print("📊 [SampleData] No existing data found - creating fresh sample data...")
        createFreshSampleData(context: context)
    }
    
    // MARK: - Fresh Sample Data Creation
    static func createFreshSampleData(context: ModelContext) {
        print("🆕 [SampleData] Creating fresh sample data with expected counts...")
        
        let calendar = Calendar.current
        let now = Date()
        
        // ACCOUNT 1: 5-Year Pension (60 months) - Major growth over time
        let pension = FinancialAccount(type: .pension, provider: "Vanguard")
        context.insert(pension)
        
        // Generate 60 months of pension data from £50K to £185K with realistic growth
        var pensionBalances: [Decimal] = []
        for i in 0..<60 {
            let monthsFromStart = 60 - i - 1
            let baseAmount: Decimal = 50000
            let growthFactor = 1.0 + (Double(monthsFromStart) * 0.045) // 4.5% yearly growth
            let variance = Double.random(in: 0.9...1.1) // ±10% variance
            let balance = baseAmount * Decimal(growthFactor * variance)
            pensionBalances.append(balance)
        }
        
        for i in 0..<60 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: pensionBalances[i], date: date, account: pension)
            context.insert(update)
        }
        
        // ACCOUNT 2: 3-Year Investment Account (36 months) - Volatile growth
        let investmentAccount = FinancialAccount(type: .stocksAndSharesISA, provider: "Trading 212")
        context.insert(investmentAccount)
        
        var investmentBalances: [Decimal] = []
        for i in 0..<36 {
            let monthsFromStart = 36 - i - 1
            let baseAmount: Decimal = 15000
            let trendGrowth = 1.0 + (Double(monthsFromStart) * 0.02) // 2% monthly trend
            let volatility = Double.random(in: 0.8...1.3) // High volatility ±30%
            let balance = baseAmount * Decimal(trendGrowth * volatility)
            investmentBalances.append(balance)
        }
        
        for i in 0..<36 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: investmentBalances[i], date: date, account: investmentAccount)
            context.insert(update)
        }
        
        // ACCOUNT 3: 1-Year Savings Account (12 months) - Steady growth
        let savingsAccount = FinancialAccount(type: .savingsAccount, provider: "Marcus")
        context.insert(savingsAccount)
        
        var savingsBalances: [Decimal] = []
        for i in 0..<12 {
            let monthsFromStart = 12 - i - 1
            let baseAmount: Decimal = 25000
            let steadyGrowth = 1.0 + (Double(monthsFromStart) * 0.004) // 0.4% monthly (5% yearly)
            let balance = baseAmount * Decimal(steadyGrowth)
            savingsBalances.append(balance)
        }
        
        for i in 0..<12 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: savingsBalances[i], date: date, account: savingsAccount)
            context.insert(update)
        }
        
        // ACCOUNT 4: 8-Month Cash ISA - Moderate range
        let cashISA = FinancialAccount(type: .cashISA, provider: "Monzo")
        context.insert(cashISA)
        
        let cashISABalances: [Decimal] = [
            18750.25, 18456.78, 18123.45, 17890.12, 17654.89, 17345.67, 17012.34, 16789.01
        ]
        for i in 0..<8 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: cashISABalances[i], date: date, account: cashISA)
            context.insert(update)
        }
        
        // ACCOUNT 5: 4-Month General Investment - Short term
        let shortInvestment = FinancialAccount(type: .generalInvestmentAccount, provider: "HL")
        context.insert(shortInvestment)
        
        let shortInvestmentBalances: [Decimal] = [6750.25, 6456.78, 6234.56, 6012.34]
        for i in 0..<4 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: shortInvestmentBalances[i], date: date, account: shortInvestment)
            context.insert(update)
        }
        
        // ACCOUNT 6: 2-Month Current Account - Very short term
        let currentAccount = FinancialAccount(type: .currentAccount, provider: "Starling")
        context.insert(currentAccount)
        
        let currentAccountBalances: [Decimal] = [3456.78, 3234.56]
        for i in 0..<2 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: currentAccountBalances[i], date: date, account: currentAccount)
            context.insert(update)
        }
        
        // ACCOUNT 7: 6-Week Foreign Currency (Weekly updates) - Very granular
        let foreignCurrency = FinancialAccount(type: .foreignCurrency, provider: "Wise")
        context.insert(foreignCurrency)
        
        let foreignCurrencyBalances: [Decimal] = [
            4250.50, 4187.25, 4123.75, 4089.50, 4045.25, 3998.75
        ]
        for i in 0..<6 {
            let date = calendar.date(byAdding: .weekOfYear, value: -i, to: now)!
            let update = BalanceUpdate(balance: foreignCurrencyBalances[i], date: date, account: foreignCurrency)
            context.insert(update)
        }
        
        // ACCOUNT 8: 5-Year Mortgage (60 months) - Debt reduction over time
        let mortgage = FinancialAccount(type: .mortgage, provider: "Halifax")
        context.insert(mortgage)
        
        var mortgageBalances: [Decimal] = []
        for i in 0..<60 {
            let monthsFromStart = 60 - i - 1
            let originalDebt: Decimal = -450000
            let monthlyReduction: Decimal = 500 // £500 principal reduction per month
            let balance = originalDebt + (Decimal(monthsFromStart) * monthlyReduction)
            mortgageBalances.append(balance)
        }
        
        for i in 0..<60 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: mortgageBalances[i], date: date, account: mortgage)
            context.insert(update)
        }
        
        // ACCOUNT 9: 18-Month Credit Card - Fluctuating debt
        let creditCard = FinancialAccount(type: .creditCard, provider: "Chase")
        context.insert(creditCard)
        
        var creditCardBalances: [Decimal] = []
        for _ in 0..<18 {
            // Credit cards fluctuate between £200-£2000 debt
            let variance = Double.random(in: -2000...(-200))
            creditCardBalances.append(Decimal(variance))
        }
        
        for i in 0..<18 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: creditCardBalances[i], date: date, account: creditCard)
            context.insert(update)
        }
        
        // ACCOUNT 10: 7-Year Junior ISA (84 months) - Very long term
        let juniorISA = FinancialAccount(type: .juniorISA, provider: "Fidelity")
        context.insert(juniorISA)
        
        var juniorISABalances: [Decimal] = []
        for i in 0..<84 {
            let monthsFromStart = 84 - i - 1
            let baseAmount: Decimal = 2000
            let compoundGrowth = pow(1.06, Double(monthsFromStart) / 12.0) // 6% yearly compound
            let balance = baseAmount * Decimal(compoundGrowth)
            juniorISABalances.append(balance)
        }
        
        for i in 0..<84 {
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            let update = BalanceUpdate(balance: juniorISABalances[i], date: date, account: juniorISA)
            context.insert(update)
        }
        
        // Save all changes
        do {
            try context.save()
            print("✅ [SampleData] Successfully created fresh sample data:")
            print("   • 10 accounts with expected update counts:")
            print("     - Vanguard Pension: 60 updates")
            print("     - Trading 212 Stocks ISA: 36 updates")
            print("     - Marcus Savings: 12 updates")
            print("     - Monzo Cash ISA: 8 updates")
            print("     - HL General Investment: 4 updates")
            print("     - Starling Current Account: 2 updates")
            print("     - Wise Foreign Currency: 6 updates")
            print("     - Halifax Mortgage: 60 updates")
            print("     - Chase Credit Card: 18 updates")
            print("     - Fidelity Junior ISA: 84 updates (max)")
            print("   • Total: 290 balance updates across all accounts")
        } catch {
            print("❌ [SampleData] Failed to save fresh sample data: \(error)")
        }
    }
    
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
    
    // MARK: - Sample Data 3 (Real Portfolio Data) - COMMENTED OUT
    /*
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
    */
}
#endif