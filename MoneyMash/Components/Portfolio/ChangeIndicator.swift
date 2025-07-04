//
//  ChangeIndicator.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 29/06/2025.
//

import SwiftUI

struct ChangeIndicator: View {
    let change: Decimal
    let isDebtAccount: Bool
    
    private var isPositiveChange: Bool {
        if isDebtAccount {
            // For debt: positive when debt decreases (becomes less negative)
            return change > 0
        } else {
            // For assets: positive when value increases
            return change > 0
        }
    }
    
    private var changeColor: Color {
        if change == 0 {
            return .secondary
        }
        return isPositiveChange ? .green : .red
    }
    
    private var changeIcon: String {
        if change == 0 {
            return "minus"
        }
        return isPositiveChange ? "arrow.up.right" : "arrow.down.right"
    }
    
    private var formattedChange: String {
        if change == 0 {
            return "No change"
        }
        
        let prefix = change > 0 ? "+" : ""
        return "\(prefix)\(change.formatted(.currency(code: "GBP")))"
    }
    
    var body: some View {
        if change == 0 {
            Text("No change")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.5))
        } else {
            HStack(spacing: 3) {
                Image(systemName: changeIcon)
                    .font(.caption2)
                    .foregroundColor(changeColor)
                
                Text(formattedChange)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(changeColor)
            }
        }
    }
}


