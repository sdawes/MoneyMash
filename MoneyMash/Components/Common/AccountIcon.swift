//
//  AccountIcon.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 29/06/2025.
//

import SwiftUI

struct AccountIcon: View {
    let accountType: AccountType
    
    var body: some View {
        ZStack {
            // Colored circle background
            Circle()
                .fill(accountType.circleColor)
                .frame(width: 24, height: 24)
            
            // Black outline circle
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 24, height: 24)
            
            // Black icon
            Image(systemName: accountType.sfSymbol)
                .font(.caption)
                .foregroundColor(Color.black)
        }
    }
}

extension AccountType {
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
    
    var circleColor: Color {
        switch self {
        case .currentAccount, .savingsAccount, .cashISA:
            return .blue.opacity(0.15)
        case .stocksAndSharesISA, .generalInvestmentAccount:
            return .green.opacity(0.15)
        case .lifetimeISA, .mortgage:
            return .orange.opacity(0.15)
        case .pension, .juniorISA, .juniorSIPP:
            return .purple.opacity(0.15)
        case .loan, .creditCard:
            return .red.opacity(0.15)
        case .crypto:
            return .yellow.opacity(0.15)
        case .foreignCurrency:
            return .teal.opacity(0.15)
        case .cash:
            return .gray.opacity(0.15)
        }
    }
}