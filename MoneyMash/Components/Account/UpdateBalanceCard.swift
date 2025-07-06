//
//  UpdateBalanceCard.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

struct UpdateBalanceCard: View {
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    let account: FinancialAccount
    
    @State private var balanceString: String = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Update Balance")
                .font(.headline)
            
            HStack {
                TextField(balanceFieldLabel, text: $balanceString)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: balanceString) { _, newValue in
                        balanceString = formatCurrency(newValue)
                    }
                
                Button("Update") {
                    updateBalance()
                }
                .disabled(!isValidInput)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Computed Properties
    
    private var balanceFieldLabel: String {
        switch account.type {
        case .mortgage, .loan, .creditCard:
            return "Amount owed (e.g. 1200.50)"
        default:
            return "New balance (e.g. 45.50)"
        }
    }
    
    private var isDebtAccount: Bool {
        switch account.type {
        case .mortgage, .loan, .creditCard:
            return true
        default:
            return false
        }
    }
    
    private var isValidInput: Bool {
        !balanceString.trimmingCharacters(in: .whitespaces).isEmpty &&
        parseCurrency(balanceString) != nil
    }
    
    // MARK: - Helper Functions
    
    private func updateBalance() {
        guard let rawBalance = parseCurrency(balanceString), rawBalance > 0 else {
            errorMessage = isDebtAccount ? "Please enter a valid amount owed" : "Please enter a valid balance amount"
            showingError = true
            return
        }
        
        // For debt accounts, convert positive input to negative balance
        let finalBalance = isDebtAccount ? -rawBalance : rawBalance
        
        let update = BalanceUpdate(balance: finalBalance, account: account)
        context.insert(update)
        
        // Clear the input field
        balanceString = ""
        
        do {
            try context.save()
            
            // Create portfolio snapshot with current portfolio settings
            let snapshotManager = PortfolioSnapshotManager(modelContext: context)
            snapshotManager.createTodaysSnapshot(includePensions: true, includeMortgage: true)
            
            // Stay on account detail view after successful update
        } catch {
            errorMessage = "Failed to save balance update: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    private func formatCurrency(_ input: String) -> String {
        // Remove all non-numeric characters except decimal point
        let cleaned = input.filter { $0.isNumber || $0 == "." }
        
        // Prevent multiple decimal points (keep only first two components)
        let components = cleaned.components(separatedBy: ".")
        let filtered = components.count > 2 ? components[0] + "." + components[1] : cleaned
        
        // Limit to 2 decimal places maximum
        if let decimalIndex = filtered.firstIndex(of: ".") {
            let decimalPart = filtered[filtered.index(after: decimalIndex)...]
            if decimalPart.count > 2 {
                let truncated = String(decimalPart.prefix(2))
                let wholePart = String(filtered[..<decimalIndex])
                return formatWithCommas("£" + wholePart + "." + truncated)
            }
        }
        
        return formatWithCommas("£" + filtered)
    }
    
    private func formatWithCommas(_ text: String) -> String {
        guard text.count > 1 else { return text }
        
        let withoutPound = text.dropFirst() // Remove £ symbol
        let components = String(withoutPound).components(separatedBy: ".")
        let wholePart = components[0]
        
        // Add commas to whole number part using NumberFormatter
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        if let number = Int(wholePart), let formatted = formatter.string(from: NSNumber(value: number)) {
            // Reassemble with £ symbol and decimal part if present
            let result = "£" + formatted + (components.count > 1 ? "." + components[1] : "")
            return result
        }
        
        return text
    }
    
    private func parseCurrency(_ string: String) -> Decimal? {
        let clean = string
            .replacingOccurrences(of: "£", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespaces)
        return Decimal(string: clean)
    }
}