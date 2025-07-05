//
//  AccountTypeIcon.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI

struct AccountTypeIcon: View {
    let accountType: AccountType
    let size: CGFloat
    
    init(accountType: AccountType, size: CGFloat = 28) {
        self.accountType = accountType
        self.size = size
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.navyBlue)
                .frame(width: size, height: size)
            
            Image(systemName: accountType.sfSymbol)
                .font(.system(size: size * 0.5, weight: .medium))
                .foregroundColor(.white)
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
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 16) {
            AccountTypeIcon(accountType: .currentAccount)
            AccountTypeIcon(accountType: .savingsAccount)
            AccountTypeIcon(accountType: .stocksAndSharesISA)
        }
        
        HStack(spacing: 16) {
            AccountTypeIcon(accountType: .pension)
            AccountTypeIcon(accountType: .mortgage)
            AccountTypeIcon(accountType: .creditCard)
        }
    }
    .padding()
}