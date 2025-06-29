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
                // Portfolio Options Modal overlay - floats above everything
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
                                    .offset(x: -16, y: 50) // Position below top-right icon
                                }
                                Spacer()
                            }
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.8).combined(with: .opacity),
                                removal: .scale(scale: 0.9).combined(with: .opacity)
                            ))
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showingPortfolioOptions)
                        .zIndex(1000) // Ensure it floats above everything
                    }
                }
                .allowsHitTesting(showingPortfolioOptions)
            )
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
