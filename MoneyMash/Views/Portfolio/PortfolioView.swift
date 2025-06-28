//
//  PortfolioView.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

struct PortfolioView: View {
    @Environment(\.modelContext) private var context
    @Query private var accounts: [FinancialAccount]
    
    private var sortedAccounts: [FinancialAccount] {
        accounts.sorted { $0.currentBalance > $1.currentBalance }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Financial Summary Header
                    PortfolioSummaryCard()
                        .padding(.horizontal)
                    
                    // Account Cards Section
                    LazyVStack(spacing: 12) {
                        ForEach(sortedAccounts, id: \.self) { account in
                            NavigationLink(destination: AccountDetailView(account: account)) {
                                FinancialAccountCard(account: account)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .background(Color.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("MoneyMash")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddAccountView()) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                }
            }
            .onAppear {
                #if DEBUG
                // Populate with sample data if database is empty (debug only)
                SampleData.populateIfEmpty(context: context)
                #endif
            }
        }
    }
}