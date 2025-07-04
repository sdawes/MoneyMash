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
                .frame(width: 25, height: 25)
            
            // Black outline circle
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 25, height: 25)
            
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
            return ColorTheme.bankingBlue.opacity(0.2)
        case .stocksAndSharesISA, .generalInvestmentAccount:
            return ColorTheme.investmentGreen.opacity(0.2)
        case .lifetimeISA, .mortgage:
            return ColorTheme.propertyOrange.opacity(0.2)
        case .pension, .juniorISA, .juniorSIPP:
            return ColorTheme.pensionPurple.opacity(0.2)
        case .loan, .creditCard:
            return ColorTheme.debtIconRed.opacity(0.2)
        case .crypto:
            return ColorTheme.cryptoYellow.opacity(0.2)
        case .foreignCurrency:
            return ColorTheme.foreignTeal.opacity(0.2)
        case .cash:
            return ColorTheme.cashGray.opacity(0.2)
        }
    }
}
