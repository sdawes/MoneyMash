//
//  MoneyMashApp.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

@main
struct MoneyMashApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [FinancialAccount.self, BalanceUpdate.self, PortfolioSnapshot.self])
    }
}
