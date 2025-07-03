//
//  ChartTimeFilterModal.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 29/06/2025.
//

import SwiftUI

enum ChartTimePeriod: String, CaseIterable {
    case oneDay = "1D"
    case oneWeek = "1W"
    case oneMonth = "1M"
    case threeMonths = "3M"
    case oneYear = "1Y"
    case fiveYears = "5Y"
    case max = "Max"
    
    var days: Int? {
        switch self {
        case .oneDay: return 1
        case .oneWeek: return 7
        case .oneMonth: return 30
        case .threeMonths: return 90
        case .oneYear: return 365
        case .fiveYears: return 1825
        case .max: return nil
        }
    }
    
    var displayName: String {
        switch self {
        case .oneDay: return "1 Day"
        case .oneWeek: return "1 Week"
        case .oneMonth: return "1 Month"
        case .threeMonths: return "3 Months"
        case .oneYear: return "1 Year"
        case .fiveYears: return "5 Years"
        case .max: return "All Time"
        }
    }
    
    // Get the start date for this time period (going back from today)
    var startDate: Date {
        guard let days = days else {
            // For "Max", return a very early date
            return Calendar.current.date(byAdding: .year, value: -10, to: Date()) ?? Date()
        }
        return Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }
    
    // Get the end date for this time period (always today)
    var endDate: Date {
        return Date()
    }
    
    // Get the full date range for this time period
    var dateRange: ClosedRange<Date> {
        return startDate...endDate
    }
    
    // Get appropriate x-axis interval for this time period
    var xAxisInterval: Calendar.Component {
        switch self {
        case .oneDay:
            return .hour
        case .oneWeek:
            return .day
        case .oneMonth:
            return .weekOfYear
        case .threeMonths:
            return .weekOfYear
        case .oneYear:
            return .month
        case .fiveYears, .max:
            return .year
        }
    }
    
    // Get the number of intervals for x-axis marks
    var xAxisIntervalCount: Int {
        switch self {
        case .oneDay:
            return 4 // Every 6 hours
        case .oneWeek:
            return 7 // Daily
        case .oneMonth:
            return 4 // Weekly
        case .threeMonths:
            return 6 // Bi-weekly
        case .oneYear:
            return 12 // Monthly
        case .fiveYears:
            return 5 // Yearly
        case .max:
            return 10 // Distributed across all data
        }
    }
    
    // Generate evenly spaced x-axis mark dates for this time period
    func generateXAxisDates() -> [Date] {
        guard self != .max else { return [] } // Let max handle this differently
        
        let periodStart = startDate
        let periodEnd = endDate
        let count = xAxisIntervalCount
        
        // Calculate the total time span in seconds
        let totalSeconds = periodEnd.timeIntervalSince(periodStart)
        
        // Divide by count-1 to get intervals between count points
        let intervalSeconds = totalSeconds / Double(Swift.max(1, count - 1))
        
        var dates: [Date] = []
        
        // Generate evenly spaced dates
        for i in 0..<count {
            let date = periodStart.addingTimeInterval(Double(i) * intervalSeconds)
            dates.append(date)
        }
        
        return dates
    }
}

struct ChartTimeFilterModal: View {
    @Binding var selectedPeriod: ChartTimePeriod
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with close button
            HStack {
                Text("Chart Time Range")
                    .font(.headline)
                Spacer()
                Button(action: { 
                    withAnimation(.easeOut(duration: 0.2)) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Time period options
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                ForEach(ChartTimePeriod.allCases, id: \.self) { period in
                    Button(action: {
                        selectedPeriod = period
                        withAnimation(.easeOut(duration: 0.2)) {
                            isPresented = false
                        }
                    }) {
                        Text(period.rawValue)
                            .font(.headline)
                            .fontWeight(selectedPeriod == period ? .bold : .medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(selectedPeriod == period ? Color.blue.opacity(0.1) : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedPeriod == period ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .frame(width: 280)
    }
}

#Preview {
    @Previewable @State var selectedPeriod = ChartTimePeriod.max
    @Previewable @State var isPresented = true
    
    return ChartTimeFilterModal(selectedPeriod: $selectedPeriod, isPresented: $isPresented)
        .padding()
}