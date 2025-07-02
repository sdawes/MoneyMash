//
//  BaseChart.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 02/07/2025.
//

import SwiftUI
import Charts

struct BaseChart<T: ChartDataSource>: View {
    let dataSource: T
    let configuration: ChartConfiguration
    @Binding var selectedTimePeriod: ChartTimePeriod
    @Binding var showingTimeFilter: Bool
    
    init(dataSource: T, 
         configuration: ChartConfiguration = .assetChart,
         selectedTimePeriod: Binding<ChartTimePeriod>,
         showingTimeFilter: Binding<Bool>) {
        self.dataSource = dataSource
        self.configuration = configuration
        self._selectedTimePeriod = selectedTimePeriod
        self._showingTimeFilter = showingTimeFilter
    }
    
    private var filteredDataPoints: [T.DataPoint] {
        dataSource.filteredDataPoints(for: selectedTimePeriod)
    }
    
    private var sortedDataPoints: [T.DataPoint] {
        filteredDataPoints.sorted { dataSource.getDate(from: $0) < dataSource.getDate(from: $1) }
    }
    
    private var dataTimeSpanInMonths: Int {
        guard !sortedDataPoints.isEmpty,
              let firstDate = sortedDataPoints.first.map({ dataSource.getDate(from: $0) }),
              let lastDate = sortedDataPoints.last.map({ dataSource.getDate(from: $0) }) else {
            return 0
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: firstDate, to: lastDate)
        return max(1, components.month ?? 1)
    }
    
    private var selectedDataPoints: [Date] {
        let allDates = sortedDataPoints.map { dataSource.getDate(from: $0) }
        let dataPointCount = allDates.count
        
        // Smart thinning based on number of data points
        switch dataPointCount {
        case 0...6:
            return allDates
        case 7...12:
            return Array(allDates.enumerated().compactMap { index, date in
                index % 2 == 0 ? date : nil
            })
        case 13...24:
            return Array(allDates.enumerated().compactMap { index, date in
                index % 3 == 0 ? date : nil
            })
        case 25...60:
            return Array(allDates.enumerated().compactMap { index, date in
                index % 6 == 0 ? date : nil
            })
        default:
            return Array(allDates.enumerated().compactMap { index, date in
                index % 12 == 0 ? date : nil
            })
        }
    }
    
    private func formatDateLabel(for date: Date, monthsSpan: Int) -> String {
        let dataPointCount = sortedDataPoints.count
        
        switch dataPointCount {
        case 0...6, 7...12, 13...24:
            let month = date.formatted(.dateTime.month(.abbreviated))
            let year = date.formatted(.dateTime.year(.twoDigits))
            return "\(month)\n\(year)"
        default:
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
    
    private var yAxisDomain: ClosedRange<Double> {
        guard !sortedDataPoints.isEmpty else {
            return 0...1000
        }
        
        let values = sortedDataPoints.map { dataSource.getValue(from: $0) }
        let minValue = values.min()!
        let maxValue = values.max()!
        
        // Add 10% padding above and below the data range
        let range = maxValue - minValue
        let padding = max(range * 0.1, abs(maxValue) * 0.05)
        
        let paddedMin = minValue - padding
        let paddedMax = maxValue + padding
        
        // For debt accounts, ensure we don't go above zero unless data requires it
        if configuration.isDebtChart && maxValue < 0 {
            return paddedMin...min(0, paddedMax)
        }
        // For positive accounts, don't go below zero unless data requires it  
        else if !configuration.isDebtChart && minValue > 0 {
            return max(0, paddedMin)...paddedMax
        }
        // Mixed range or data crosses zero
        else {
            return paddedMin...paddedMax
        }
    }
    
    private func getAreaBaseline() -> Double {
        guard !sortedDataPoints.isEmpty else { return 0 }
        
        let values = sortedDataPoints.map { dataSource.getValue(from: $0) }
        let minValue = values.min()!
        let maxValue = values.max()!
        
        if configuration.fillFromZero {
            // For asset charts, always fill from zero, but ensure baseline doesn't go below chart domain
            let domainMin = yAxisDomain.lowerBound
            return max(0, domainMin)
        }
        
        // For debt accounts, fill from zero down to the debt values
        if configuration.isDebtChart {
            return min(0, maxValue)
        }
        // For positive accounts, fill from zero up to the actual values
        else {
            return max(0, minValue)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Chart header with filter badge and options button
            HStack {
                Text(selectedTimePeriod.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(configuration.lineColor.opacity(0.1))
                    .foregroundColor(configuration.lineColor)
                    .cornerRadius(6)
                
                Spacer()
                
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
            
            if sortedDataPoints.isEmpty {
                Text("No historical data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(Array(sortedDataPoints.enumerated()), id: \.offset) { index, dataPoint in
                        let date = dataSource.getDate(from: dataPoint)
                        let value = dataSource.getValue(from: dataPoint)
                        
                        // Gradient area
                        AreaMark(
                            x: .value("Date", date),
                            yStart: .value("Baseline", getAreaBaseline()),
                            yEnd: .value("Value", value)
                        )
                        .foregroundStyle(configuration.gradientStyle)
                        
                        // Line mark
                        LineMark(
                            x: .value("Date", date),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(configuration.lineColor)
                        .lineStyle(StrokeStyle(lineWidth: 1))
                        
                        // Data point dots
                        PointMark(
                            x: .value("Date", date),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(configuration.lineColor)
                        .symbolSize(12)
                    }
                }
                .frame(height: 120)
                .chartXAxis {
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