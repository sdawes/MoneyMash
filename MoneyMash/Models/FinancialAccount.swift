//
//  FinancialAccount.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData
import Foundation

@Model
class FinancialAccount {
    var type: AccountType
    var provider: String
    @Relationship(deleteRule: .cascade, inverse: \BalanceUpdate.account) var balanceUpdates: [BalanceUpdate] = []

    init(type: AccountType, provider: String) {
        self.type = type
        self.provider = provider
    }
    
    // MARK: - Computed Properties
    
    var currentBalance: Decimal {
        balanceUpdates.sorted { $0.date > $1.date }.first?.balance ?? 0
    }
    
    var lastUpdateDate: Date? {
        balanceUpdates.sorted { $0.date > $1.date }.first?.date
    }
    
    var formattedLastUpdateDate: String {
        guard let lastUpdate = lastUpdateDate else { return "No updates" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yy"
        return "Last updated: " + formatter.string(from: lastUpdate)
    }
    
    // MARK: - Performance Metrics
    
    var previousUpdateBalance: Decimal? {
        let sortedUpdates = balanceUpdates.sorted { $0.date > $1.date }
        // Return the second most recent balance (previous update)
        return sortedUpdates.count > 1 ? sortedUpdates[1].balance : nil
    }
    
    var updateChange: Decimal {
        guard let previousBalance = previousUpdateBalance else { return 0 }
        return currentBalance - previousBalance
    }
    
    var updateChangePercentage: Double {
        guard let previousBalance = previousUpdateBalance, previousBalance != 0 else { return 0 }
        let change = updateChange
        let percentage = change / previousBalance
        return NSDecimalNumber(decimal: percentage).doubleValue * 100
    }
    
    var isDebtAccount: Bool {
        switch type {
        case .mortgage, .loan, .creditCard:
            return true
        default:
            return false
        }
    }
    
    var isPositiveTrend: Bool {
        if isDebtAccount {
            // For debt accounts: positive trend when debt decreases (balance becomes less negative)
            return updateChange > 0
        } else {
            // For asset accounts: positive trend when balance increases
            return updateChange > 0
        }
    }
    
    var trendDirection: String {
        if isDebtAccount {
            // For debt accounts: down arrow for debt reduction (good), up arrow for debt increase (bad)
            return updateChange > 0 ? "arrow.down.right" : "arrow.up.right"
        } else {
            // For asset accounts: up arrow for increase (good), down arrow for decrease (bad)
            return updateChange > 0 ? "arrow.up.right" : "arrow.down.right"
        }
    }
    
    var formattedUpdateChange: String {
        if isDebtAccount {
            if updateChange > 0 {
                return "Debt reduced by \(updateChange.formatted(.currency(code: "GBP")))"
            } else {
                let increase = abs(updateChange)
                return "Debt increased by \(increase.formatted(.currency(code: "GBP")))"
            }
        } else {
            let prefix = updateChange >= 0 ? "+" : ""
            return "\(prefix)\(updateChange.formatted(.currency(code: "GBP")))"
        }
    }
    
    var formattedUpdateChangePercentage: String {
        let prefix = updateChangePercentage >= 0 ? "+" : ""
        return "\(prefix)\(updateChangePercentage.formatted(.number.precision(.fractionLength(1))))%"
    }
}

enum AccountType: String, CaseIterable, Identifiable, Codable {
    case currentAccount = "Current Account"
    case savingsAccount = "Savings Account"
    case cashISA = "Cash ISA"
    case stocksAndSharesISA = "Stocks & Shares ISA"
    case lifetimeISA = "Lifetime ISA"
    case generalInvestmentAccount = "General Investment Account"
    case pension = "Pension"
    case juniorISA = "Junior ISA"
    case juniorSIPP = "Junior SIPP"
    case mortgage = "Mortgage"
    case loan = "Loan"
    case creditCard = "Credit Card"
    case crypto = "Cryptocurrency Wallet"
    case foreignCurrency = "Foreign Currency Account"
    case cash = "Cash"

    var id: String { self.rawValue }
    
}