//
//  PortfolioChartCard.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 02/07/2025.
//

import SwiftUI

struct PortfolioChartCard: View {
    @Binding var selectedTimePeriod: ChartTimePeriod
    @Binding var showingTimeFilter: Bool
    @Binding var includePensions: Bool
    @Binding var includeMortgage: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Asset Growth")
                .font(.headline)
                .fontWeight(.semibold)
            
            PortfolioChart(
                selectedTimePeriod: $selectedTimePeriod,
                showingTimeFilter: $showingTimeFilter,
                includePensions: $includePensions,
                includeMortgage: $includeMortgage
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}