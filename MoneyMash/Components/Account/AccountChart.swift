//
//  AccountChartView.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import Charts

struct AccountChartView: View {
    let account: FinancialAccount
    
    private var sortedBalanceUpdates: [BalanceUpdate] {
        account.balanceUpdates.sorted { $0.date < $1.date }
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
                colors: [.red, .red.opacity(0)],
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            return LinearGradient(
                colors: [.blue, .blue.opacity(0)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Balance History")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if sortedBalanceUpdates.isEmpty {
                Text("No historical data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(sortedBalanceUpdates, id: \.date) { update in
                        // Gradient area
                        AreaMark(
                            x: .value("Date", update.date),
                            y: .value("Balance", Double(truncating: update.balance as NSNumber))
                        )
                        .foregroundStyle(gradientStyle)
                        
                        // Line mark
                        LineMark(
                            x: .value("Date", update.date),
                            y: .value("Balance", Double(truncating: update.balance as NSNumber))
                        )
                        .foregroundStyle(lineColor)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                }
                .frame(height: 120)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .month)) { value in
                        AxisValueLabel(format: .dateTime.month(.abbreviated))
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
            }
        }
        .padding(.top, 8)
    }
}