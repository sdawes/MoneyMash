//
//  PortfolioOptionsModal.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 28/06/2025.
//

import SwiftUI
import SwiftData

struct PortfolioOptionsModal: View {
    @Query private var accounts: [FinancialAccount]
    
    @Binding var includePensions: Bool
    @Binding var includeMortgage: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with close button
            HStack {
                Text("Portfolio Options")
                    .font(.headline)
                Spacer()
                Button(action: { 
                    withAnimation(.easeOut(duration: 0.2)) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom, 4)
            
            // Include Pensions toggle
            HStack {
                Text("Include Pensions")
                    .font(.body)
                Spacer()
                Toggle("", isOn: $includePensions)
                    .controlSize(.regular)
            }
            
            // Include Mortgage toggle (conditional)
            if hasMixedDebt {
                HStack {
                    Text("Include Mortgage")
                        .font(.body)
                    Spacer()
                    Toggle("", isOn: $includeMortgage)
                        .controlSize(.regular)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .frame(width: 220)
    }
    
    // MARK: - Helper Properties
    
    private var hasMixedDebt: Bool {
        let debtAccounts = accounts.filter { isDebtAccount($0.type) }
        let hasMortgage = debtAccounts.contains { $0.type == .mortgage }
        let hasOtherDebt = debtAccounts.contains { $0.type != .mortgage }
        return hasMortgage && hasOtherDebt
    }
    
    private func isDebtAccount(_ accountType: AccountType) -> Bool {
        switch accountType {
        case .mortgage, .loan, .creditCard:
            return true
        default:
            return false
        }
    }
}