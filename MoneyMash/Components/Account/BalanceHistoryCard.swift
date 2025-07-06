//
//  BalanceHistoryCard.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

struct BalanceHistoryCard: View {
    @Environment(\.modelContext) private var modelContext
    let account: FinancialAccount
    
    @State private var showingDeleteAlert = false
    @State private var updateToDelete: BalanceUpdate?
    @State private var deleteError: String?
    
    private var sortedUpdates: [BalanceUpdate] {
        account.balanceUpdates.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Balance History")
                .font(.headline)
            
            List {
                ForEach(sortedUpdates, id: \.id) { update in
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
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Delete", role: .destructive) {
                            updateToDelete = update
                            showingDeleteAlert = true
                        }
                        .disabled(sortedUpdates.count <= 1)
                    }
                }
            }
            .listStyle(.plain)
            .frame(height: CGFloat(min(sortedUpdates.count * 60, 300)))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
        .confirmationDialog(
            "Delete Balance Update",
            isPresented: $showingDeleteAlert,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let update = updateToDelete {
                    deleteBalanceUpdate(update)
                }
            }
            Button("Cancel", role: .cancel) {
                updateToDelete = nil
            }
        } message: {
            if let update = updateToDelete {
                Text("Are you sure you want to delete the balance update of \(update.formattedBalance) from \(update.formattedDate)? This will also update all portfolio charts and totals.")
            }
        }
        .alert("Delete Error", isPresented: .constant(deleteError != nil)) {
            Button("OK") {
                deleteError = nil
            }
        } message: {
            if let error = deleteError {
                Text(error)
            }
        }
    }
    
    private func deleteBalanceUpdate(_ update: BalanceUpdate) {
        let deletionManager = BalanceUpdateDeletionManager(modelContext: modelContext)
        
        do {
            try deletionManager.deleteBalanceUpdate(update, from: account)
            updateToDelete = nil
            print("✅ Successfully deleted balance update")
        } catch {
            deleteError = error.localizedDescription
            print("❌ Failed to delete balance update: \(error)")
        }
    }
}