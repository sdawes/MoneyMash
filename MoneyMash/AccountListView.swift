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
    
    private var sortedAccounts: [FinancialAccount] {
        accounts.sorted { $0.currentBalance > $1.currentBalance }
    }

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
                    ForEach(sortedAccounts, id: \.self) { account in
                        NavigationLink(destination: AccountDetailView(account: account)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(account.type.rawValue)
                                    .font(.headline)
                                Text("Provider: \(account.provider)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                HStack {
                                    Text("Balance: \(account.currentBalance.formatted(.currency(code: "GBP")))")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    Text(account.formattedLastUpdateDate.replacingOccurrences(of: "Last updated: ", with: ""))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 2)
                        }
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
                context.delete(sortedAccounts[index])
            }
        }
    }
}