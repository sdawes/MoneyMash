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
            ZStack {
                // Mesh gradient background
                if #available(iOS 18.0, *) {
                    MeshGradient(
                        width: 3,
                        height: 3,
                        points: [
                            .init(0, 0), .init(0.5, 0), .init(1, 0),
                            .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                            .init(0, 1), .init(0.5, 1), .init(1, 1)
                        ],
                        colors: [
                            Color(red: 0.9, green: 0.95, blue: 0.92), Color(red: 0.92, green: 0.94, blue: 0.98), Color(red: 0.94, green: 0.96, blue: 0.98),
                            Color(red: 0.93, green: 0.96, blue: 0.94), Color(red: 0.98, green: 0.98, blue: 0.98), Color(red: 0.91, green: 0.94, blue: 0.97),
                            Color(red: 0.90, green: 0.93, blue: 0.96), Color(red: 0.92, green: 0.95, blue: 0.93), Color(red: 0.93, green: 0.95, blue: 0.97)
                        ]
                    )
                    .ignoresSafeArea()
                }
                
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
                .scrollContentBackground(.hidden)
            }
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