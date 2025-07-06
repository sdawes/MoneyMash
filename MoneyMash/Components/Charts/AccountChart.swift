//
//  AccountChart.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 05/07/2025.
//

import SwiftUI
import Charts

struct AccountChart: View {
    let account: FinancialAccount
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Balance History")
                .font(.headline)
                .fontWeight(.semibold)
            
            if account.balanceUpdates.isEmpty {
                Text("No balance history available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(sortedBalanceUpdates, id: \.date) { update in
                        LineMark(
                            x: .value("Date", update.date),
                            y: .value("Balance", Double(truncating: update.balance as NSDecimalNumber))
                        )
                        .foregroundStyle(Color.navyBlue)
                    }
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
    
    private var sortedBalanceUpdates: [BalanceUpdate] {
        account.balanceUpdates.sorted { $0.date < $1.date }
    }
}