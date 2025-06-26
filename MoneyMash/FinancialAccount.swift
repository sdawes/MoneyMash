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
    
    var previousMonthBalance: Decimal? {
        let calendar = Calendar.current
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        // Find the balance update closest to one month ago
        let sortedUpdates = balanceUpdates.sorted { $0.date < $1.date }
        
        for update in sortedUpdates.reversed() {
            if update.date <= oneMonthAgo {
                return update.balance
            }
        }
        
        // If no update found from a month ago, return the earliest balance
        return sortedUpdates.first?.balance
    }
    
    var monthlyChange: Decimal {
        guard let previousBalance = previousMonthBalance else { return 0 }
        return currentBalance - previousBalance
    }
    
    var monthlyChangePercentage: Double {
        guard let previousBalance = previousMonthBalance, previousBalance != 0 else { return 0 }
        let change = monthlyChange
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
            return monthlyChange > 0
        } else {
            // For asset accounts: positive trend when balance increases
            return monthlyChange > 0
        }
    }
    
    var trendDirection: String {
        if isDebtAccount {
            // For debt accounts: down arrow for debt reduction (good), up arrow for debt increase (bad)
            return monthlyChange > 0 ? "arrow.down.right" : "arrow.up.right"
        } else {
            // For asset accounts: up arrow for increase (good), down arrow for decrease (bad)
            return monthlyChange > 0 ? "arrow.up.right" : "arrow.down.right"
        }
    }
    
    var formattedMonthlyChange: String {
        if isDebtAccount {
            if monthlyChange > 0 {
                return "Debt reduced by \(monthlyChange.formatted(.currency(code: "GBP")))"
            } else {
                let increase = abs(monthlyChange)
                return "Debt increased by \(increase.formatted(.currency(code: "GBP")))"
            }
        } else {
            let prefix = monthlyChange >= 0 ? "+" : ""
            return "\(prefix)\(monthlyChange.formatted(.currency(code: "GBP")))"
        }
    }
    
    var formattedMonthlyChangePercentage: String {
        let prefix = monthlyChangePercentage >= 0 ? "+" : ""
        return "\(prefix)\(monthlyChangePercentage.formatted(.number.precision(.fractionLength(1))))%"
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
    
    var sfSymbol: String {
        switch self {
        case .currentAccount:
            return "creditcard"
        case .savingsAccount:
            return "banknote"
        case .cashISA:
            return "banknote.fill"
        case .stocksAndSharesISA:
            return "chart.line.uptrend.xyaxis"
        case .lifetimeISA:
            return "house.fill"
        case .generalInvestmentAccount:
            return "chart.pie.fill"
        case .pension:
            return "person.2.fill"
        case .juniorISA:
            return "figure.child"
        case .juniorSIPP:
            return "graduationcap.fill"
        case .mortgage:
            return "house"
        case .loan:
            return "doc.text"
        case .creditCard:
            return "creditcard.fill"
        case .crypto:
            return "bitcoinsign.circle.fill"
        case .foreignCurrency:
            return "dollarsign.circle"
        case .cash:
            return "banknote"
        }
    }
}