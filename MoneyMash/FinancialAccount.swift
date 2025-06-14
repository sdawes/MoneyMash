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
    var balance: Decimal

    init(type: AccountType, provider: String, balance: Decimal) {
        self.type = type
        self.provider = provider
        self.balance = balance
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