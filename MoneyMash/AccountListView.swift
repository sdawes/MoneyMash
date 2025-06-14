//
//  AccountListView.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

struct AccountListView: View {
    @Environment(\.modelContext) private var context
    @Query private var accounts: [FinancialAccount]

    var body: some View {
        NavigationStack {
            List {
                // Total Value Summary as first item
                Section {
                    TotalValueView()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                } header: {
                    EmptyView()
                } footer: {
                    EmptyView()
                }
                .listSectionSeparator(.hidden)
                
                // Financial Accounts Section
                Section {
                    ForEach(accounts, id: \.self) { account in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(account.type.rawValue)
                                .font(.headline)
                            Text("Provider: \(account.provider)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Balance: \(account.balance.formatted(.currency(code: "GBP")))")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete(perform: deleteAccounts)
                }
            }
            .navigationTitle("Accounts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add", destination: AddAccountView())
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
    
    private func deleteAccounts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(accounts[index])
            }
        }
    }
}