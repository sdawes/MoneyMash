//
//  ChartDataSource.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 02/07/2025.
//

import Foundation

protocol ChartDataSource {
    associatedtype DataPoint
    
    var allDataPoints: [DataPoint] { get }
    func filteredDataPoints(for timePeriod: ChartTimePeriod) -> [DataPoint]
    func getValue(from dataPoint: DataPoint) -> Double
    func getDate(from dataPoint: DataPoint) -> Date
}

struct ChartDataPoint {
    let date: Date
    let value: Double
    
    init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}