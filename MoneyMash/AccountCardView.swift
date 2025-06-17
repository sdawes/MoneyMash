//
//  AccountCardView.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI

struct AccountCardView: View {
    let account: FinancialAccount
    
    var body: some View {
        NavigationLink(destination: AccountDetailView(account: account)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(account.type.rawValue)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
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
                        
                        Text(account.formattedLastUpdateDate.replacingOccurrences(of: "Last updated: ", with: ""))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}