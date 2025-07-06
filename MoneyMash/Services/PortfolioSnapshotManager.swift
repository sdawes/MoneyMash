//
//  PortfolioSnapshotManager.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 05/07/2025.
//

import SwiftUI
import SwiftData
import Foundation

class PortfolioSnapshotManager {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Creates snapshots for existing data (one-time setup)
    func createSnapshotsIfNeeded(includePensions: Bool, includeMortgage: Bool) {
        // Check if any snapshots already exist
        let descriptor = FetchDescriptor<PortfolioSnapshot>()
        do {
            let existingSnapshots = try modelContext.fetch(descriptor)
            if existingSnapshots.isEmpty {
                print("📊 No snapshots exist - creating historical snapshots from balance updates")
                createHistoricalSnapshots(includePensions: includePensions, includeMortgage: includeMortgage)
            } else if existingSnapshots.count == 1 {
                print("📊 Found only 1 snapshot - creating historical snapshots from balance updates")
                // Delete the single snapshot and recreate from historical data
                for snapshot in existingSnapshots {
                    modelContext.delete(snapshot)
                }
                createHistoricalSnapshots(includePensions: includePensions, includeMortgage: includeMortgage)
            } else {
                print("📊 Found \(existingSnapshots.count) existing snapshots - keeping them")
            }
        } catch {
            print("❌ Failed to check existing snapshots: \(error)")
        }
    }
    
    /// Creates historical snapshots based on all balance update dates
    private func createHistoricalSnapshots(includePensions: Bool, includeMortgage: Bool) {
        // Get all balance updates ordered by date
        let balanceDescriptor = FetchDescriptor<BalanceUpdate>(
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        
        do {
            let allUpdates = try modelContext.fetch(balanceDescriptor)
            
            // Get all unique dates (start of day)
            let calendar = Calendar.current
            var uniqueDates = Set<Date>()
            
            for update in allUpdates {
                let dayStart = calendar.startOfDay(for: update.date)
                uniqueDates.insert(dayStart)
            }
            
            let sortedDates = uniqueDates.sorted()
            print("📊 Creating snapshots for \(sortedDates.count) unique dates from balance history")
            
            // Create snapshot for each date
            for date in sortedDates {
                createSnapshotForDate(date, includePensions: includePensions, includeMortgage: includeMortgage)
            }
            
            // Save all created snapshots
            do {
                try modelContext.save()
                print("📊 Successfully saved \(sortedDates.count) historical snapshots!")
            } catch {
                print("❌ Failed to save historical snapshots: \(error)")
            }
            
        } catch {
            print("❌ Failed to fetch balance updates for historical snapshots: \(error)")
        }
    }
    
    /// Creates a snapshot for a specific date using the portfolio state at that time
    func createSnapshotForDate(_ date: Date, includePensions: Bool, includeMortgage: Bool) {
        let calendar = Calendar.current
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: date)!
        
        // Get all accounts
        let accountDescriptor = FetchDescriptor<FinancialAccount>()
        
        do {
            let accounts = try modelContext.fetch(accountDescriptor)
            var totalNetWorth: Decimal = 0
            
            // For each account, find the most recent balance update up to this date
            for account in accounts {
                if let latestUpdate = account.balanceUpdates
                    .filter({ $0.date < endOfDay })
                    .max(by: { $0.date < $1.date }) {
                    
                    // Apply pension/mortgage filters
                    let shouldInclude = shouldIncludeInNetWorth(account.type, 
                                                             includePensions: includePensions, 
                                                             includeMortgage: includeMortgage)
                    if shouldInclude {
                        totalNetWorth += latestUpdate.balance
                    }
                }
            }
            
            // Create snapshot for this date
            let snapshot = PortfolioSnapshot(date: date, totalNetWorth: totalNetWorth)
            modelContext.insert(snapshot)
            
            print("📊 Created historical snapshot for \(date): \(totalNetWorth)")
            
        } catch {
            print("❌ Failed to create snapshot for date \(date): \(error)")
        }
    }
    
    /// Determines if an account type should be included in net worth calculation
    private func shouldIncludeInNetWorth(_ accountType: AccountType, includePensions: Bool, includeMortgage: Bool) -> Bool {
        // Always exclude pension accounts if toggle is off
        if isPensionAccount(accountType) && !includePensions {
            return false
        }
        
        // Always exclude mortgage if toggle is off
        if accountType == .mortgage && !includeMortgage {
            return false
        }
        
        // Include all account types (debt accounts have negative balances)
        return true
    }
    
    /// Creates or updates a portfolio snapshot for today with current portfolio totals
    func createTodaysSnapshot(includePensions: Bool, includeMortgage: Bool) {
        let today = Calendar.current.startOfDay(for: Date())
        
        print("📊 Creating snapshot for \(today) - Pensions: \(includePensions), Mortgage: \(includeMortgage)")
        
        // Check if snapshot already exists for today
        let existingSnapshot = getSnapshot(for: today)
        
        // Calculate current portfolio totals
        let netWorth = calculateNetWorth(includePensions: includePensions, includeMortgage: includeMortgage)
        
        print("📊 Calculated net worth: \(netWorth)")
        
        if let existing = existingSnapshot {
            // Update existing snapshot
            print("📊 Updating existing snapshot")
            existing.totalNetWorth = netWorth
        } else {
            // Create new snapshot
            print("📊 Creating new snapshot")
            let snapshot = PortfolioSnapshot(
                date: today,
                totalNetWorth: netWorth
            )
            modelContext.insert(snapshot)
        }
        
        // Save changes
        do {
            try modelContext.save()
            print("📊 Successfully saved snapshot!")
        } catch {
            print("❌ Failed to save portfolio snapshot: \(error)")
        }
    }
    
    private func getSnapshot(for date: Date) -> PortfolioSnapshot? {
        // Use date range to handle potential timezone issues
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<PortfolioSnapshot> { snapshot in
            snapshot.date >= startOfDay &&
            snapshot.date < endOfDay
        }
        
        let descriptor = FetchDescriptor<PortfolioSnapshot>(predicate: predicate)
        
        do {
            let snapshots = try modelContext.fetch(descriptor)
            return snapshots.first
        } catch {
            print("Failed to fetch existing snapshot: \(error)")
            return nil
        }
    }
    
    private func calculateNetWorth(includePensions: Bool, includeMortgage: Bool) -> Decimal {
        // Fetch all accounts
        let accountDescriptor = FetchDescriptor<FinancialAccount>()
        
        do {
            let accounts = try modelContext.fetch(accountDescriptor)
            
            let assets = accounts
                .filter { shouldIncludeInAssets($0.type, includePensions: includePensions) }
                .reduce(Decimal(0)) { total, account in
                    total + account.currentBalance
                }
            
            let debt = accounts
                .filter { isDebtAccount($0.type) && (includeMortgage || $0.type != .mortgage) }
                .reduce(Decimal(0)) { total, account in
                    total + account.currentBalance
                }
            
            return assets + debt // debt balances are negative, so adding them subtracts
            
        } catch {
            print("Failed to fetch accounts for portfolio calculation: \(error)")
            return 0
        }
    }
    
    // MARK: - Helper Functions
    
    private func isDebtAccount(_ accountType: AccountType) -> Bool {
        switch accountType {
        case .mortgage, .loan, .creditCard:
            return true
        default:
            return false
        }
    }
    
    private func isPensionAccount(_ accountType: AccountType) -> Bool {
        switch accountType {
        case .pension, .juniorSIPP:
            return true
        default:
            return false
        }
    }
    
    private func shouldIncludeInAssets(_ accountType: AccountType, includePensions: Bool) -> Bool {
        // Exclude debt accounts
        if isDebtAccount(accountType) {
            return false
        }
        
        // Include pension accounts only if toggle is on
        if isPensionAccount(accountType) {
            return includePensions
        }
        
        // Include all other asset types
        return true
    }
}