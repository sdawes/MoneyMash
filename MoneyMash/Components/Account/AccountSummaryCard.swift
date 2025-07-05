//
//  AccountSummaryCard.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI

struct AccountSummaryCard: View {
    let account: FinancialAccount
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    AccountTypeIcon(accountType: account.type, size: 36)
                    
                    Text(account.type.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Text(account.provider)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Balance")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(account.currentBalance.formatted(.currency(code: "GBP")))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(account.currentBalance >= 0 ? .white : Color.standardRed)
            }
            
            if account.lastUpdateDate != nil {
                Text(account.formattedLastUpdateDate)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
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
        .padding(.horizontal)
    }
}