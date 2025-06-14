//
//  FinancialAccount.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

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