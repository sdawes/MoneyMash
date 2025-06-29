//
//  AccountDetailView.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

struct AccountDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    let account: FinancialAccount
    
    @State private var showDeleteConfirmation = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingChartTimeFilter = false
    @State private var selectedChartTimePeriod: ChartTimePeriod = .max
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Account Header
                AccountSummaryCard(account: account)
                
                // Update Balance Form
                UpdateBalanceCard(account: account)
                
                // Account Chart
                AccountChart(
                    account: account,
                    selectedTimePeriod: $selectedChartTimePeriod,
                    showingTimeFilter: $showingChartTimeFilter
                )
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .padding(.horizontal)
                
                // Balance History
                BalanceHistoryCard(account: account)
            }
        }
        .onAppear {
            selectedChartTimePeriod = loadChartFilterPreference(for: account)
        }
        .navigationTitle("Account Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .alert("Delete Account", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this account? This action cannot be undone.")
        }
        .overlay(
            // Chart Time Filter Modal overlay
            Group {
                if showingChartTimeFilter {
                    ZStack {
                        // Background tap to dismiss (transparent)
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    showingChartTimeFilter = false
                                }
                            }
                        
                        VStack {
                            HStack {
                                Spacer()
                                ChartTimeFilterModal(
                                    selectedPeriod: Binding(
                                        get: { selectedChartTimePeriod },
                                        set: { newValue in
                                            selectedChartTimePeriod = newValue
                                            saveChartFilterPreference(for: account, timePeriod: newValue)
                                        }
                                    ),
                                    isPresented: $showingChartTimeFilter
                                )
                                .offset(x: -20, y: 340)
                            }
                            Spacer()
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 0.9).combined(with: .opacity)
                    ))
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showingChartTimeFilter)
                }
            }
        )
    }
    
    // MARK: - Helper Functions
    
    private func saveChartFilterPreference(for account: FinancialAccount, timePeriod: ChartTimePeriod) {
        let key = "chartFilter_\(account.id)"
        UserDefaults.standard.set(timePeriod.rawValue, forKey: key)
    }
    
    private func loadChartFilterPreference(for account: FinancialAccount) -> ChartTimePeriod {
        let key = "chartFilter_\(account.id)"
        if let savedValue = UserDefaults.standard.string(forKey: key),
           let timePeriod = ChartTimePeriod(rawValue: savedValue) {
            return timePeriod
        }
        return .max // Default to "Max" if no preference is saved
    }
    
    private func deleteAccount() {
        context.delete(account)
        do {
            try context.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            errorMessage = "Failed to delete account: \(error.localizedDescription)"
            showingError = true
        }
    }
}
