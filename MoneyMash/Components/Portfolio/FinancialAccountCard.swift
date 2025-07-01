//
//  FinancialAccountCard.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI

struct FinancialAccountCard: View {
    let account: FinancialAccount
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        AccountIcon(accountType: account.type)
                        
                        Text(account.type.rawValue)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    Text("Provider: \(account.provider)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(account.currentBalance.formatted(.currency(code: "GBP")))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(account.currentBalance >= 0 ? .primary : .red)
                    
                    // Change indicator since last update
                    if account.updateChange != 0 {
                        VStack(alignment: .trailing, spacing: 2) {
                            HStack(spacing: 4) {
                                Image(systemName: account.trendDirection)
                                    .font(.caption2)
                                    .foregroundColor(account.isPositiveTrend ? .green : .red)
                                
                                Text("(\(account.formattedUpdateChangePercentage))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(account.formattedUpdateChange)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(account.isPositiveTrend ? .green : .red)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    Text(account.formattedLastUpdateDate.replacingOccurrences(of: "Last updated: ", with: ""))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
