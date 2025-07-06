//
//  PortfolioChart.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 05/07/2025.
//

import SwiftUI
import SwiftData
import Charts

struct PortfolioChart: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \PortfolioSnapshot.date) private var snapshots: [PortfolioSnapshot]
    
    let includePensions: Bool
    let includeMortgage: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Net Worth History")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Debug info
            Text("Total snapshots: \(snapshots.count)")
                .font(.caption)
                .foregroundColor(.secondary)
                .onAppear {
                    print("📊 [Chart] PortfolioChart appeared - snapshots count: \(snapshots.count)")
                    for snapshot in snapshots {
                        print("📊 [Chart] Snapshot: date=\(snapshot.date), netWorth=\(snapshot.totalNetWorth)")
                    }
                    
                    // If no snapshots exist, create one now
                    if snapshots.isEmpty {
                        print("📊 [Chart] No snapshots found, creating one now...")
                        let snapshotManager = PortfolioSnapshotManager(modelContext: context)
                        snapshotManager.createTodaysSnapshot(includePensions: includePensions, includeMortgage: includeMortgage)
                    }
                }
            
            if snapshots.isEmpty {
                Text("No portfolio history available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                .frame(height: 200)
                .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(snapshots, id: \.date) { snapshot in
                        let doubleValue = Double(truncating: snapshot.totalNetWorth as NSDecimalNumber)
                        let _ = print("📊 [Chart] Rendering data point - date: \(snapshot.date), netWorth: \(snapshot.totalNetWorth), doubleValue: \(doubleValue)")
                        
                        LineMark(
                            x: .value("Date", snapshot.date),
                            y: .value("Net Worth", doubleValue)
                        )
                        .foregroundStyle(Color.navyBlue)
                        .lineStyle(.init(lineWidth: 2))
                    }
                }
                .frame(height: 200)
                .onAppear {
                    print("📊 [Chart] Chart component appeared with \(snapshots.count) snapshots")
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
    
}