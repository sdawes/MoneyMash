//
//  AddAccountView.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI
import SwiftData

struct AddAccountView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var selectedType: AccountType = .currentAccount
    @State private var provider: String = ""
    @State private var balanceString: String = ""
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account Details")) {
                    Picker("Account Type", selection: $selectedType) {
                        ForEach(AccountType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }

                    TextField("Provider (e.g. HL, Vanguard)", text: $provider)
                        .textInputAutocapitalization(.words)

                    TextField("Balance (e.g. 45.50)", text: $balanceString)
                        .keyboardType(.decimalPad)
                        .onChange(of: balanceString) { _, newValue in
                            balanceString = formatCurrency(newValue)
                        }
                }
            }
            .navigationTitle("Add Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAccount()
                    }
                    .disabled(!isFormValid)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !provider.trimmingCharacters(in: .whitespaces).isEmpty &&
        !balanceString.trimmingCharacters(in: .whitespaces).isEmpty &&
        parseCurrency(balanceString) != nil
    }
    
    private func saveAccount() {
        guard let balance = parseCurrency(balanceString), balance > 0 else {
            errorMessage = "Please enter a valid balance amount"
            showingError = true
            return
        }
        
        let trimmedProvider = provider.trimmingCharacters(in: .whitespaces)
        guard !trimmedProvider.isEmpty else {
            errorMessage = "Please enter a provider name"
            showingError = true
            return
        }
        
        let account = FinancialAccount(
            type: selectedType,
            provider: trimmedProvider,
            balance: balance
        )
        
        context.insert(account)
        dismiss()
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