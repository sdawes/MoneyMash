//
//  TotalValueView.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

struct TotalValueView: View {
    @Query private var accounts: [FinancialAccount]
    
    @State private var includePensions = true
    @State private var includeMortgage = true
    
    var body: some View {
        VStack(spacing: 8) {
            // Toggle Controls
            HStack {
                if hasMixedDebt {
                    Toggle("Include Mortgage in Debt", isOn: $includeMortgage)
                        .font(.caption)
                    Spacer()
                }
                Toggle("Include Pensions in Wealth", isOn: $includePensions)
                    .font(.caption)
                if !hasMixedDebt {
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Summary Card
            VStack(spacing: 12) {
                // Row 1: Debt (conditional)
                if hasAnyDebt {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(hasOnlyMortgage ? "Mortgage" : "Total Debt")
                            .foregroundColor(.secondary)
                        
                        Text(totalDebt.formatted(.currency(code: "GBP")))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Row 2: Assets and Net Worth
                HStack(spacing: 12) {
                    // Total Assets
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Total Assets")
                            .foregroundColor(.secondary)
                        
                        Text(totalAssets.formatted(.currency(code: "GBP")))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Net Worth
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Net Worth")
                            .foregroundColor(.secondary)
                        
                        Text(totalNetWorth.formatted(.currency(code: "GBP")))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
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