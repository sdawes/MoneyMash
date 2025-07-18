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
    
    @State private var showingPortfolioOptions = false
    @State private var includePensions = true
    @State private var includeMortgage = true
    
    private var sortedAccounts: [FinancialAccount] {
        accounts.sorted { $0.currentBalance > $1.currentBalance }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Financial Summary Header
                    PortfolioSummaryCard(
                        includePensions: $includePensions,
                        includeMortgage: $includeMortgage,
                        showingOptions: $showingPortfolioOptions
                    )
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Portfolio Chart
                    PortfolioChart(
                        includePensions: includePensions,
                        includeMortgage: includeMortgage
                    )
                    .padding(.top, 16)
                    
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
            .overlay(
                // Modals overlay
                Group {
                    if showingPortfolioOptions {
                        ZStack {
                            // Background dimming with tap to dismiss
                            Color.black.opacity(0.1)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        showingPortfolioOptions = false
                                    }
                                }
                            
                            // Portfolio Options Modal positioned below top-right icon
                            VStack {
                                HStack {
                                    Spacer()
                                    PortfolioOptionsModal(
                                        includePensions: $includePensions,
                                        includeMortgage: $includeMortgage,
                                        isPresented: $showingPortfolioOptions
                                    )
                                    .offset(x: -16, y: 50)
                                }
                                Spacer()
                            }
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.8).combined(with: .opacity),
                                removal: .scale(scale: 0.9).combined(with: .opacity)
                            ))
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showingPortfolioOptions)
                    }
                    
                }
                .allowsHitTesting(showingPortfolioOptions)
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("MoneyMash")
                        .font(.appTitle)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddAccountView()) {
                        AddButton()
                    }
                }
            }
            .onAppear {
                // Sample data population is now handled in ContentView
                
                // Create portfolio snapshots if they don't exist
                let snapshotManager = PortfolioSnapshotManager(modelContext: context)
                snapshotManager.createSnapshotsIfNeeded(includePensions: includePensions, includeMortgage: includeMortgage)
            }
        }
    }
}
