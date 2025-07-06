//
//  BalanceUpdateDeletionManager.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 06/07/2025.
//

import SwiftUI
import SwiftData
import Foundation

class BalanceUpdateDeletionManager {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Safely deletes a balance update and regenerates all affected portfolio snapshots
    func deleteBalanceUpdate(_ update: BalanceUpdate, from account: FinancialAccount) throws {
        print("🗑️ Starting deletion of balance update: \(update.formattedBalance) from \(update.formattedDate)")
        
        // Safety check: Don't allow deletion of the only balance update
        guard account.balanceUpdates.count > 1 else {
            throw DeletionError.lastUpdateCantBeDeleted
        }
        
        // Store the date for snapshot regeneration
        let updateDate = update.date
        let calendar = Calendar.current
        let updateDayStart = calendar.startOfDay(for: updateDate)
        
        // Delete the balance update
        modelContext.delete(update)
        
        try modelContext.save()
        print("🗑️ Successfully deleted balance update from database")
        
        // Regenerate portfolio snapshots from the affected date onwards
        regenerateSnapshotsFromDate(updateDayStart)
        
        print("🗑️ Balance update deletion completed successfully")
    }
    
    /// Regenerates all portfolio snapshots from a specific date onwards
    private func regenerateSnapshotsFromDate(_ fromDate: Date) {
        print("🔄 Regenerating portfolio snapshots from \(fromDate)")
        
        // Delete all snapshots from the affected date onwards
        let snapshotDescriptor = FetchDescriptor<PortfolioSnapshot>(
            predicate: #Predicate<PortfolioSnapshot> { snapshot in
                snapshot.date >= fromDate
            }
        )
        
        do {
            let affectedSnapshots = try modelContext.fetch(snapshotDescriptor)
            
            print("🔄 Found \(affectedSnapshots.count) snapshots to regenerate")
            
            // Delete affected snapshots
            for snapshot in affectedSnapshots {
                modelContext.delete(snapshot)
            }
            
            // Get all balance updates from the affected date onwards to regenerate snapshots
            let balanceDescriptor = FetchDescriptor<BalanceUpdate>(
                predicate: #Predicate<BalanceUpdate> { update in
                    update.date >= fromDate
                },
                sortBy: [SortDescriptor(\.date, order: .forward)]
            )
            
            let affectedUpdates = try modelContext.fetch(balanceDescriptor)
            
            // Get unique dates that need new snapshots
            let calendar = Calendar.current
            var uniqueDates = Set<Date>()
            
            for update in affectedUpdates {
                let dayStart = calendar.startOfDay(for: update.date)
                uniqueDates.insert(dayStart)
            }
            
            let sortedDates = uniqueDates.sorted()
            print("🔄 Regenerating snapshots for \(sortedDates.count) dates")
            
            // Create new snapshots for each affected date
            let snapshotManager = PortfolioSnapshotManager(modelContext: modelContext)
            for date in sortedDates {
                snapshotManager.createSnapshotForDate(date, includePensions: true, includeMortgage: true)
            }
            
            try modelContext.save()
            print("🔄 Successfully regenerated \(sortedDates.count) portfolio snapshots")
            
        } catch {
            print("❌ Failed to regenerate snapshots: \(error)")
        }
    }
}

// MARK: - Deletion Errors

enum DeletionError: LocalizedError {
    case lastUpdateCantBeDeleted
    
    var errorDescription: String? {
        switch self {
        case .lastUpdateCantBeDeleted:
            return "Cannot delete the only balance update for this account. An account must have at least one balance entry."
        }
    }
}