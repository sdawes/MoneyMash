//
//  PortfolioSummaryCard.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

struct PortfolioSummaryCard: View {
    @Query private var accounts: [FinancialAccount]
    
    @Binding var includePensions: Bool
    @Binding var includeMortgage: Bool
    @Binding var showingOptions: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Row 1: Net Worth with options button in top right
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("Net Worth")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        if includePensions || includeMortgage {
                            Text(netWorthInclusionText)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    Text(totalNetWorth.formatted(.currency(code: "GBP")))
                        .font(.system(.largeTitle, weight: .bold))
                        .foregroundColor(.white)
                    
                    if hasChangeData {
                        ChangeIndicator(change: netWorthChange, isDebtAccount: false)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Options button in top right
                Button(action: { showingOptions.toggle() }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding(.top, 2) // Slight adjustment to align with text
            }
            
            // Row 2: Assets and Debt columns
            HStack(spacing: 16) {
                // Left Column: Total Assets (conditional)
                if shouldShowAssets {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Assets")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text(totalAssets.formatted(.currency(code: "GBP")))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        if hasChangeData {
                            ChangeIndicator(change: totalAssetsChange, isDebtAccount: false)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Right Column: Total Debt (conditional)
                if hasAnyDebt {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(hasOnlyMortgage ? "Mortgage" : "Total Debt")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text(totalDebt.formatted(.currency(code: "GBP")))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.standardRed)
                        
                        if hasChangeData {
                            ChangeIndicator(change: totalDebtChange, isDebtAccount: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else if shouldShowAssets {
                    // Empty space to maintain grid structure when assets are shown
                    VStack {
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            ZStack {
                // Base gradient - dark navy to bright cyan
                ColorTheme.navyGradient
                
                // Highlight radial gradient
                ColorTheme.radialNavyGradient
                    .blendMode(.screen)
                
                // Shadow radial gradient for depth
                ColorTheme.shadowRadialGradient
                    .blendMode(.multiply)
            }
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Calculations
    
    private var totalNetWorth: Decimal {
        accounts
            .filter { account in
                // Include assets based on toggles
                if isDebtAccount(account.type) {
                    // Include debt only if it should be included (respects mortgage toggle)
                    return account.type != .mortgage || includeMortgage
                } else {
                    // Include assets based on assets logic
                    return shouldIncludeInAssets(account.type)
                }
            }
            .reduce(0) { total, account in
                total + account.currentBalance
            }
    }
    
    // MARK: - Change Tracking
    
    private var mostRecentUpdateDate: Date? {
        accounts.compactMap { $0.lastUpdateDate }.max()
    }
    
    private var previousUpdateDate: Date? {
        guard let mostRecentDate = mostRecentUpdateDate else { return nil }
        
        // Find all update dates except the most recent
        let allUpdateDates = accounts.flatMap { account in
            account.balanceUpdates.map { $0.date }
        }.filter { $0 != mostRecentDate }
        
        return allUpdateDates.max()
    }
    
    private func getBalanceAt(date: Date, for account: FinancialAccount) -> Decimal {
        // Find the most recent balance update at or before the given date
        let updatesAtOrBefore = account.balanceUpdates
            .filter { $0.date <= date }
            .sorted { $0.date > $1.date }
        
        return updatesAtOrBefore.first?.balance ?? 0
    }
    
    private var previousNetWorth: Decimal {
        guard let previousDate = previousUpdateDate else { return totalNetWorth }
        
        return accounts
            .filter { account in
                // Same filtering logic as current net worth
                if isDebtAccount(account.type) {
                    return account.type != .mortgage || includeMortgage
                } else {
                    return shouldIncludeInAssets(account.type)
                }
            }
            .reduce(0) { total, account in
                total + getBalanceAt(date: previousDate, for: account)
            }
    }
    
    private var previousTotalAssets: Decimal {
        guard let previousDate = previousUpdateDate else { return totalAssets }
        
        return accounts
            .filter { shouldIncludeInAssets($0.type) }
            .reduce(0) { total, account in
                total + getBalanceAt(date: previousDate, for: account)
            }
    }
    
    private var previousTotalDebt: Decimal {
        guard let previousDate = previousUpdateDate else { return totalDebt }
        
        return accounts
            .filter { account in
                if hasOnlyMortgage {
                    return isDebtAccount(account.type)
                }
                return isDebtAccount(account.type) && (account.type != .mortgage || includeMortgage)
            }
            .reduce(0) { total, account in
                total + getBalanceAt(date: previousDate, for: account)
            }
    }
    
    private var netWorthChange: Decimal {
        totalNetWorth - previousNetWorth
    }
    
    private var totalAssetsChange: Decimal {
        totalAssets - previousTotalAssets
    }
    
    private var totalDebtChange: Decimal {
        totalDebt - previousTotalDebt
    }
    
    private var hasChangeData: Bool {
        previousUpdateDate != nil
    }
    
    private var totalAssets: Decimal {
        accounts
            .filter { account in
                shouldIncludeInAssets(account.type)
            }
            .reduce(0) { total, account in
                total + account.currentBalance
            }
    }
    
    private var totalDebt: Decimal {
        accounts
            .filter { account in
                // For mortgage-only scenario, always include mortgage
                if hasOnlyMortgage {
                    return isDebtAccount(account.type)
                }
                // For mixed debt, respect the mortgage toggle
                return isDebtAccount(account.type) && (account.type != .mortgage || includeMortgage)
            }
            .reduce(0) { total, account in
                total + account.currentBalance
            }
    }
    
    // MARK: - Debt Situation Detection
    
    private var hasAnyDebt: Bool {
        accounts.contains { isDebtAccount($0.type) }
    }
    
    private var hasOnlyMortgage: Bool {
        let debtAccounts = accounts.filter { isDebtAccount($0.type) }
        return !debtAccounts.isEmpty && debtAccounts.allSatisfy { $0.type == .mortgage }
    }
    
    private var hasMixedDebt: Bool {
        let debtAccounts = accounts.filter { isDebtAccount($0.type) }
        let hasMortgage = debtAccounts.contains { $0.type == .mortgage }
        let hasOtherDebt = debtAccounts.contains { $0.type != .mortgage }
        return hasMortgage && hasOtherDebt
    }
    
    // MARK: - Helper Functions
    
    private var netWorthInclusionText: String {
        switch (includePensions, includeMortgage) {
        case (true, true):
            return "(inc. pension & mortgage)"
        case (true, false):
            return "(inc. pension)"
        case (false, true):
            return "(inc. mortgage)"
        case (false, false):
            return ""
        }
    }
    
    private var shouldShowAssets: Bool {
        // Hide assets when net worth equals total assets (no debt to subtract)
        return totalAssets != totalNetWorth
    }
    
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
    
    private func shouldIncludeInAssets(_ accountType: AccountType) -> Bool {
        // Exclude debt accounts
        if isDebtAccount(accountType) {
            return false
        }
        
        // Include pension accounts only if toggle is on
        if isPensionAccount(accountType) {
            return includePensions
        }
        
        // Include all other asset types (including investments)
        return true
    }
}