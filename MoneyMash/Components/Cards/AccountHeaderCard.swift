//
//  AccountHeaderCard.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI

struct AccountHeaderCard: View {
    let account: FinancialAccount
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(account.type.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(account.provider)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Balance")
                    .foregroundColor(.secondary)
                
                Text(account.currentBalance.formatted(.currency(code: "GBP")))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(account.currentBalance >= 0 ? .primary : .red)
            }
            
            if account.lastUpdateDate != nil {
                Text(account.formattedLastUpdateDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}