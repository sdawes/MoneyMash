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