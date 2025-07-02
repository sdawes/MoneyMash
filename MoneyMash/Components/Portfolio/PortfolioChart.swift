//
//  PortfolioChart.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 02/07/2025.
//

import SwiftUI
import SwiftData

struct PortfolioChart: View {
    // SwiftData best practice: Use specific query optimized for performance
    @Query(animation: .default) private var accounts: [FinancialAccount]
    
    @Binding var selectedTimePeriod: ChartTimePeriod
    @Binding var showingTimeFilter: Bool
    @Binding var includePensions: Bool
    @Binding var includeMortgage: Bool
    
    // Use @State to maintain stable data source and avoid recreation
    @State private var dataSource: PortfolioChartDataSource?
    @State private var lastSettingsHash: String = ""
    
    private var currentSettingsHash: String {
        "accounts:\(accounts.count)_pension:\(includePensions)"
    }
    
    private func updateDataSourceIfNeeded() {
        let currentHash = currentSettingsHash
        
        // Only recreate if accounts data or settings changed
        if dataSource == nil || lastSettingsHash != currentHash {
            dataSource = PortfolioChartDataSource(
                accounts: accounts,
                includePensions: includePensions,
                includeMortgage: includeMortgage
            )
            lastSettingsHash = currentHash
        }
    }
    
    var body: some View {
        Group {
            if let dataSource = dataSource {
                BaseChart(
                    dataSource: dataSource,
                    configuration: .portfolioChart,
                    selectedTimePeriod: $selectedTimePeriod,
                    showingTimeFilter: $showingTimeFilter
                )
            } else {
                Text("Loading chart...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 120)
            }
        }
        .onAppear {
            updateDataSourceIfNeeded()
        }
        .onChange(of: currentSettingsHash) { _, _ in
            // Efficiently update data source only when settings actually change
            updateDataSourceIfNeeded()
        }
    }
}