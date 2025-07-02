//
//  ChartConfiguration.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 02/07/2025.
//

import SwiftUI

struct ChartConfiguration {
    let lineColor: Color
    let gradientStyle: LinearGradient
    let fillFromZero: Bool
    let isDebtChart: Bool
    
    init(lineColor: Color = .blue, 
         gradientStyle: LinearGradient? = nil, 
         fillFromZero: Bool = true,
         isDebtChart: Bool = false) {
        self.lineColor = lineColor
        self.fillFromZero = fillFromZero
        self.isDebtChart = isDebtChart
        
        if let gradientStyle = gradientStyle {
            self.gradientStyle = gradientStyle
        } else if isDebtChart {
            self.gradientStyle = LinearGradient(
                colors: [lineColor.opacity(0.15), lineColor.opacity(0)],
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            self.gradientStyle = LinearGradient(
                colors: [lineColor.opacity(0.15), lineColor.opacity(0)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    // Preset configurations
    static let assetChart = ChartConfiguration(
        lineColor: .blue,
        fillFromZero: true,
        isDebtChart: false
    )
    
    static let debtChart = ChartConfiguration(
        lineColor: .red,
        fillFromZero: true,
        isDebtChart: true
    )
    
    static let portfolioChart = ChartConfiguration(
        lineColor: .blue,
        gradientStyle: LinearGradient(
            colors: [Color.blue.opacity(0.15), Color.blue.opacity(0)],
            startPoint: .top,
            endPoint: .bottom
        ),
        fillFromZero: true,
        isDebtChart: false
    )
}