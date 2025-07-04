//
//  ContentView.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        PortfolioView()
            .onAppear {
                setupDataIfNeeded()
            }
    }
    
    private func setupDataIfNeeded() {
        #if DEBUG
        // Populate sample data if needed
        SampleData.populateIfEmpty(context: context)
        #endif
    }
}


