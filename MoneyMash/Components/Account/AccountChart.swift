//
//  AccountChart.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import Charts

struct AccountChart: View {
    let account: FinancialAccount
    @Binding var selectedTimePeriod: ChartTimePeriod
    @Binding var showingTimeFilter: Bool
    
    private var sortedBalanceUpdates: [BalanceUpdate] {
        let allUpdates = account.balanceUpdates.sorted { $0.date < $1.date }
        
        // Filter by selected time period
        guard let days = selectedTimePeriod.days else {
            return allUpdates // Return all data for "Max"
        }
        
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return allUpdates.filter { $0.date >= cutoffDate }
    }
    
    private var dataTimeSpanInMonths: Int {
        guard let firstDate = sortedBalanceUpdates.first?.date,
              let lastDate = sortedBalanceUpdates.last?.date else {
            return 0
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: firstDate, to: lastDate)
        let monthSpan = max(1, components.month ?? 1)
        
        #if DEBUG
        print("Account: \(account.type.rawValue) - \(account.provider)")
        print("First date: \(firstDate), Last date: \(lastDate)")
        print("Month span: \(monthSpan)")
        print("Updates count: \(sortedBalanceUpdates.count)")
        #endif
        
        return monthSpan
    }
    
    private var selectedDataPoints: [Date] {
        let allDates = sortedBalanceUpdates.map { $0.date }
        let dataPointCount = allDates.count
        
        // Smart thinning based on number of data points
        switch dataPointCount {
        case 0...6:
            // Show all data points (6 or fewer)
            return allDates
        case 7...12:
            // Show every other point (7-12 data points)
            return Array(allDates.enumerated().compactMap { index, date in
                index % 2 == 0 ? date : nil
            })
        case 13...24:
            // Show every 3rd point (13-24 data points) 
            return Array(allDates.enumerated().compactMap { index, date in
                index % 3 == 0 ? date : nil
            })
        case 25...60:
            // Show every 6th point (25-60 data points)
            return Array(allDates.enumerated().compactMap { index, date in
                index % 6 == 0 ? date : nil
            })
        default:
            // Show every 12th point (60+ data points)
            return Array(allDates.enumerated().compactMap { index, date in
                index % 12 == 0 ? date : nil
            })
        }
    }
    
    private func formatDateLabel(for date: Date, monthsSpan: Int) -> String {
        let dataPointCount = sortedBalanceUpdates.count
        
        switch dataPointCount {
        case 0...6:
            // Few data points: Show full month with year for clarity
            let month = date.formatted(.dateTime.month(.abbreviated))
            let year = date.formatted(.dateTime.year(.twoDigits))
            return "\(month)\n\(year)"
        case 7...12:
            // Medium data points: Abbreviated month with year  
            let month = date.formatted(.dateTime.month(.abbreviated))
            let year = date.formatted(.dateTime.year(.twoDigits))
            return "\(month)\n\(year)"
        case 13...24:
            // More data points: Compact month/year
            let month = date.formatted(.dateTime.month(.abbreviated))
            let year = date.formatted(.dateTime.year(.twoDigits))
            return "\(month)\n\(year)"
        default:
            // Many data points: Very compact - just month and year
            let month = date.formatted(.dateTime.month(.abbreviated))
            let year = date.formatted(.dateTime.year(.twoDigits))
            return "\(month)\n\(year)"
        }
    }
    
    private func formatCompactCurrency(_ value: Double) -> String {
        let absValue = abs(value)
        
        if absValue >= 1_000_000 {
            return "£\(Int(value / 1_000_000))M"
        } else if absValue >= 1_000 {
            return "£\(Int(value / 1_000))K"
        } else {
            return "£\(Int(value))"
        }
    }
    
    private var isDebtAccount: Bool {
        switch account.type {
        case .mortgage, .loan, .creditCard:
            return true
        default:
            return false
        }
    }
    
    private var lineColor: Color {
        isDebtAccount ? .red : .blue
    }
    
    private var gradientStyle: LinearGradient {
        if isDebtAccount {
            return LinearGradient(
                colors: [.red.opacity(0.15), .red.opacity(0)],
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            return LinearGradient(
                colors: [.blue.opacity(0.15), .blue.opacity(0)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var yAxisDomain: ClosedRange<Double> {
        guard !sortedBalanceUpdates.isEmpty else {
            return 0...1000
        }
        
        let values = sortedBalanceUpdates.map { Double(truncating: $0.balance as NSNumber) }
        let minValue = values.min()!
        let maxValue = values.max()!
        
        // Add 10% padding above and below the data range
        let range = maxValue - minValue
        let padding = max(range * 0.1, abs(maxValue) * 0.05) // At least 5% of max value
        
        let paddedMin = minValue - padding
        let paddedMax = maxValue + padding
        
        // For debt accounts, ensure we don't go above zero unless data requires it
        if isDebtAccount && maxValue < 0 {
            return paddedMin...min(0, paddedMax)
        }
        // For positive accounts, don't go below zero unless data requires it  
        else if !isDebtAccount && minValue > 0 {
            return max(0, paddedMin)...paddedMax
        }
        // Mixed range or data crosses zero
        else {
            return paddedMin...paddedMax
        }
    }
    
    private func getAreaBaseline() -> Double {
        guard !sortedBalanceUpdates.isEmpty else { return 0 }
        
        let values = sortedBalanceUpdates.map { Double(truncating: $0.balance as NSNumber) }
        let minValue = values.min()!
        let maxValue = values.max()!
        
        // For debt accounts (negative values), fill from zero down to the debt values
        if isDebtAccount {
            return min(0, maxValue) // Fill from zero or the highest (least negative) value
        }
        // For positive accounts, fill from zero up to the actual values
        else {
            return max(0, minValue) // Fill from zero or the lowest positive value
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Chart header with filter badge and options button
            HStack {
                // Current filter badge
                Text(selectedTimePeriod.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
                
                Spacer()
                
                // Time filter options button
                Button(action: { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showingTimeFilter.toggle()
                    }
                }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            if sortedBalanceUpdates.isEmpty {
                Text("No historical data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(sortedBalanceUpdates, id: \.date) { update in
                        // Gradient area - only fill to the baseline, not the chart bounds
                        AreaMark(
                            x: .value("Date", update.date),
                            yStart: .value("Baseline", getAreaBaseline()),
                            yEnd: .value("Balance", Double(truncating: update.balance as NSNumber))
                        )
                        .foregroundStyle(gradientStyle)
                        
                        // Line mark
                        LineMark(
                            x: .value("Date", update.date),
                            y: .value("Balance", Double(truncating: update.balance as NSNumber))
                        )
                        .foregroundStyle(lineColor)
                        .lineStyle(StrokeStyle(lineWidth: 1))
                        
                        // Data point dots
                        PointMark(
                            x: .value("Date", update.date),
                            y: .value("Balance", Double(truncating: update.balance as NSNumber))
                        )
                        .foregroundStyle(lineColor)
                        .symbolSize(12)
                    }
                }
                .frame(height: 120)
                .chartXAxis {
                    // Data-driven approach: show actual data points with smart thinning
                    AxisMarks(values: selectedDataPoints) { value in
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(formatDateLabel(for: date, monthsSpan: dataTimeSpanInMonths))
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        AxisGridLine()
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text(formatCompactCurrency(doubleValue))
                                    .font(.caption2)
                            }
                        }
                        AxisGridLine()
                    }
                }
                .chartYScale(domain: yAxisDomain)
            }
        }
        .padding(.top, 8)
    }
}