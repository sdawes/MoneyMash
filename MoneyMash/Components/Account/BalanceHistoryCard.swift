//
//  BalanceHistoryCard.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI

struct BalanceHistoryCard: View {
    let account: FinancialAccount
    
    private var sortedUpdates: [BalanceUpdate] {
        account.balanceUpdates.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Balance History")
                .font(.headline)
            
            VStack(spacing: 0) {
                ForEach(sortedUpdates.indices, id: \.self) { index in
                    let update = sortedUpdates[index]
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(update.formattedBalance)
                                .fontWeight(.medium)
                            
                            Text("Updated on: \(update.formattedDate)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if update.date == account.lastUpdateDate {
                            Text("Current")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    
                    if index < sortedUpdates.count - 1 {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}