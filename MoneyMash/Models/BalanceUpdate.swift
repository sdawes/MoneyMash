//
//  BalanceUpdate.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData
import Foundation

@Model
class BalanceUpdate {
    var balance: Decimal
    var date: Date
    var account: FinancialAccount?
    
    init(balance: Decimal, date: Date = Date(), account: FinancialAccount? = nil) {
        self.balance = balance
        self.date = date
        self.account = account
    }
}

// MARK: - Helper Extensions

extension BalanceUpdate {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    var formattedBalance: String {
        balance.formatted(.currency(code: "GBP"))
    }
}