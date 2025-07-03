//
//  PortfolioChartDataSource.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 02/07/2025.
//

import Foundation
import SwiftData

class PortfolioChartDataSource: ChartDataSource {
    typealias DataPoint = ChartDataPoint
    
    private let accounts: [FinancialAccount]
    private let includePensions: Bool
    private let includeMortgage: Bool
    
    // Cache key based on settings to invalidate when toggles change
    private var cacheKey: String {
        "pension:\(includePensions)_accounts:\(accounts.count)"
    }
    
    // Cache the calculated data points to avoid recalculation
    private var _cachedDataPoints: [ChartDataPoint]?
    private var _cacheKey: String?
    
    init(accounts: [FinancialAccount], includePensions: Bool, includeMortgage: Bool) {
        self.accounts = accounts
        self.includePensions = includePensions
        self.includeMortgage = includeMortgage
    }
    
    var allDataPoints: [ChartDataPoint] {
        // Use cached data if available and cache key matches
        if let cached = _cachedDataPoints, _cacheKey == cacheKey {
            return cached
        }
        
        // Calculate new data and cache it
        let newData = calculateCumulativeNetWorthPoints()
        _cachedDataPoints = newData
        _cacheKey = cacheKey
        return newData
    }
    
    func filteredDataPoints(for timePeriod: ChartTimePeriod) -> [ChartDataPoint] {
        let points = allDataPoints
        
        guard let days = timePeriod.days else {
            return points // Return all data for "Max"
        }
        
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let filteredPoints = points.filter { $0.date >= cutoffDate }
        
        // If no data points exist in the time period, return empty
        guard !filteredPoints.isEmpty else { return [] }
        
        // If the first data point is after the cutoff date, extend the data backwards
        // using the earliest available value to fill the gap
        let firstDataPoint = filteredPoints.first!
        let allPointsSorted = points.sorted { $0.date < $1.date }
        
        if firstDataPoint.date > cutoffDate {
            // Find the last known value before the time period starts
            let lastKnownValue: Double
            if let lastPointBeforePeriod = allPointsSorted.last(where: { $0.date < cutoffDate }) {
                lastKnownValue = lastPointBeforePeriod.value
            } else {
                // No historical data, use the first available value
                lastKnownValue = firstDataPoint.value
            }
            
            // Create a data point at the start of the time period with the last known value
            let startPoint = ChartDataPoint(date: cutoffDate, value: lastKnownValue)
            return [startPoint] + filteredPoints
        }
        
        return filteredPoints
    }
    
    func getValue(from dataPoint: ChartDataPoint) -> Double {
        dataPoint.value
    }
    
    func getDate(from dataPoint: ChartDataPoint) -> Date {
        dataPoint.date
    }
    
    private func calculateCumulativeNetWorthPoints() -> [ChartDataPoint] {
        // Get all balance updates from included asset accounts only
        var allUpdates: [(date: Date, account: FinancialAccount, balance: Decimal)] = []
        
        for account in accounts {
            guard shouldIncludeInAssets(account.type) else { continue }
            
            for update in account.balanceUpdates {
                // Only positive asset balances (no debt)
                allUpdates.append((date: update.date, account: account, balance: update.balance))
            }
        }
        
        // Sort all updates by date
        allUpdates.sort { $0.date < $1.date }
        
        // Build cumulative points efficiently
        var cumulativePoints: [ChartDataPoint] = []
        var accountBalances: [FinancialAccount: Decimal] = [:]
        var lastProcessedDate: Date?
        
        for update in allUpdates {
            // Update the balance for this account
            accountBalances[update.account] = update.balance
            
            // Only create a data point if this is a new date
            if lastProcessedDate != update.date {
                let cumulativeTotal = accountBalances.values.reduce(0, +)
                let point = ChartDataPoint(
                    date: update.date, 
                    value: Double(truncating: cumulativeTotal as NSNumber)
                )
                cumulativePoints.append(point)
                lastProcessedDate = update.date
            } else {
                // Update the last point if multiple updates on same date
                if let lastIndex = cumulativePoints.indices.last {
                    let cumulativeTotal = accountBalances.values.reduce(0, +)
                    cumulativePoints[lastIndex] = ChartDataPoint(
                        date: update.date,
                        value: Double(truncating: cumulativeTotal as NSNumber)
                    )
                }
            }
        }
        
        return cumulativePoints
    }
    
    private func isDebtAccount(_ accountType: AccountType) -> Bool {
        switch accountType {
        case .mortgage, .loan, .creditCard:
            return true
        default:
            return false
        }
    }
    
    private func isPensionAccount(_ accountType: AccountType) -> Bool {
        switch accountType {
        case .pension, .juniorSIPP:
            return true
        default:
            return false
        }
    }
    
    private func shouldIncludeInAssets(_ accountType: AccountType) -> Bool {
        // Exclude all debt accounts from portfolio chart
        if isDebtAccount(accountType) {
            return false
        }
        
        // Include pension accounts only if toggle is on
        if isPensionAccount(accountType) {
            return includePensions
        }
        
        // Include all other asset types (savings, investments, etc.)
        return true
    }
}