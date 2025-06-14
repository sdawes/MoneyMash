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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Total Debt
            VStack(alignment: .leading, spacing: 2) {
                Text("Total Debt")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(totalDebt.formatted(.currency(code: "GBP")))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.9))
            }
            
            // Liquid Assets
            VStack(alignment: .leading, spacing: 2) {
                Text("Liquid Assets")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(liquidAssets.formatted(.currency(code: "GBP")))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.cyan)
            }
            
            // Total Net Worth
            VStack(alignment: .leading, spacing: 2) {
                Text("Total Net Worth")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(totalNetWorth.formatted(.currency(code: "GBP")))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(totalNetWorth >= 0 ? .white : .pink)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(red: 0.15, green: 0.35, blue: 0.45))
    }
    
    // MARK: - Calculations
    
    private var totalNetWorth: Decimal {
        accounts.reduce(0) { total, account in
            total + account.currentBalance
        }
    }
    
    private var liquidAssets: Decimal {
        accounts
            .filter { account in
                // Include everything except pensions and debt accounts
                !isDebtAccount(account.type) && !isPensionAccount(account.type)
            }
            .reduce(0) { total, account in
                total + account.currentBalance
            }
    }
    
    private var totalDebt: Decimal {
        accounts
            .filter { account in
                isDebtAccount(account.type)
            }
            .reduce(0) { total, account in
                total + account.currentBalance
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
}