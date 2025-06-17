//
//  AccountCardView.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import Charts

struct AccountCardView: View {
    let account: FinancialAccount
    @State private var showChart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main account details
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
                
                // Chart toggle button
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showChart.toggle()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text("see chart")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: showChart ? "chevron.up" : "chevron.down")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
            
            // Chart view (conditionally shown)
            if showChart {
                AccountChartView(account: account)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}