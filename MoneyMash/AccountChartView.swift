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
                        LineMark(
                            x: .value("Date", update.date),
                            y: .value("Balance", Double(truncating: update.balance as NSNumber))
                        )
                        .foregroundStyle(.primary)
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
                                Text(Decimal(doubleValue).formatted(.currency(code: "GBP")))
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