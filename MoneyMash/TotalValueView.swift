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
                    .foregroundColor(.secondary)
                
                Text(totalDebt.formatted(.currency(code: "GBP")))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
            }
            
            // Liquid Assets
            VStack(alignment: .leading, spacing: 2) {
                Text("Liquid Assets")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(liquidAssets.formatted(.currency(code: "GBP")))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
            
            // Total Net Worth
            VStack(alignment: .leading, spacing: 2) {
                Text("Total Net Worth")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(totalNetWorth.formatted(.currency(code: "GBP")))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(totalNetWorth >= 0 ? .primary : .red)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
    }
    
    // MARK: - Calculations
    
    private var totalNetWorth: Decimal {
        accounts.reduce(0) { total, account in
            total + account.balance
        }
    }
    
    private var liquidAssets: Decimal {
        accounts
            .filter { account in
                // Include everything except pensions and debt accounts
                !isDebtAccount(account.type) && !isPensionAccount(account.type)
            }
            .reduce(0) { total, account in
                total + account.balance
            }
    }
    
    private var totalDebt: Decimal {
        accounts
            .filter { account in
                isDebtAccount(account.type)
            }
            .reduce(0) { total, account in
                total + account.balance
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