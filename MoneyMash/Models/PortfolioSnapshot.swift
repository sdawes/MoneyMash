//
//  PortfolioSnapshot.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 05/07/2025.
//

import SwiftUI
import SwiftData
import Foundation

@Model
class PortfolioSnapshot {
    var date: Date
    var totalNetWorth: Decimal
    
    init(date: Date, totalNetWorth: Decimal) {
        self.date = date
        self.totalNetWorth = totalNetWorth
    }
}

// MARK: - Helper Extensions

extension PortfolioSnapshot {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    var formattedNetWorth: String {
        totalNetWorth.formatted(.currency(code: "GBP"))
    }
}