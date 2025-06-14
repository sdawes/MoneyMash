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
    
    @State private var animationPhase: Double = 0
    
    private var sortedAccounts: [FinancialAccount] {
        accounts.sorted { $0.currentBalance > $1.currentBalance }
    }
    
    private var animatedColors: [Color] {
        let phase1Colors: [(Double, Double, Double)] = [
            (0.9, 0.95, 0.92), (0.92, 0.94, 0.98), (0.94, 0.96, 0.98),
            (0.93, 0.96, 0.94), (0.98, 0.98, 0.98), (0.91, 0.94, 0.97),
            (0.90, 0.93, 0.96), (0.92, 0.95, 0.93), (0.93, 0.95, 0.97)
        ]
        
        let phase2Colors: [(Double, Double, Double)] = [
            (0.85, 0.90, 0.95), (0.88, 0.91, 0.96), (0.90, 0.93, 0.97),
            (0.87, 0.92, 0.96), (0.95, 0.95, 0.98), (0.89, 0.92, 0.97),
            (0.86, 0.89, 0.94), (0.91, 0.94, 0.89), (0.88, 0.91, 0.96)
        ]
        
        // Interpolate between the two color sets based on animation phase
        let t = (sin(animationPhase) + 1) / 2 // Normalize to 0-1
        
        return zip(phase1Colors, phase2Colors).map { color1, color2 in
            Color(
                red: color1.0 * (1 - t) + color2.0 * t,
                green: color1.1 * (1 - t) + color2.1 * t,
                blue: color1.2 * (1 - t) + color2.2 * t
            )
        }
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
                        colors: animatedColors
                    )
                    .ignoresSafeArea()
                }
                
                List {
                    // Total Value Summary as first item
                    Section {
                        TotalValueView()
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("MoneyMash")
                        .font(.headline)
                        .foregroundColor(.secondary)
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
                
                // Start gradient animation
                startGradientAnimation()
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
    
    private func startGradientAnimation() {
        withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
            animationPhase = .pi * 2
        }
    }
}