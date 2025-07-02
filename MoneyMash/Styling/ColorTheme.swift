//
//  ColorTheme.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 29/06/2025.
//

import SwiftUI

struct ColorTheme {
    // MARK: - Custom Gradient Colors
    
    /// Deep navy base
    static let deepNavy = Color(hex: "#07246D")
    
    /// Rich blue primary
    static let richBlue = Color(hex: "#2048C5")
    
    /// Bright cyan accent
    static let brightCyan = Color(hex: "#00A7C9")
    
    /// Medium blue
    static let mediumBlue = Color(hex: "#0067A2")
    
    /// Light cyan
    static let lightCyan = Color(hex: "#00ADCB")
    
    // MARK: - Semantic Colors
    
    /// Bright red-orange for debt values - vibrant and attention-grabbing
    static let debtRed = Color(hex: "#FF5722")
    
    // MARK: - Icon Colors
    
    /// Banking accounts - vibrant blue
    static let bankingBlue = Color(hex: "#2196F3")
    
    /// Investment accounts - vibrant green
    static let investmentGreen = Color(hex: "#4CAF50")
    
    /// Property/Mortgage - vibrant orange
    static let propertyOrange = Color(hex: "#FF9800")
    
    /// Pensions/Long-term savings - vibrant purple
    static let pensionPurple = Color(hex: "#9C27B0")
    
    /// Debt accounts - vibrant red
    static let debtIconRed = Color(hex: "#F44336")
    
    /// Crypto - vibrant yellow
    static let cryptoYellow = Color(hex: "#FFC107")
    
    /// Foreign currency - vibrant teal
    static let foreignTeal = Color(hex: "#00BCD4")
    
    /// Cash - medium gray
    static let cashGray = Color(hex: "#757575")
    
    // MARK: - Gradient Definitions
    
    /// Primary gradient - deep navy to bright cyan
    static let navyGradient = LinearGradient(
        colors: [deepNavy, richBlue, brightCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Enhanced multi-color gradient
    static let deepNavyGradient = LinearGradient(
        colors: [deepNavy, richBlue, mediumBlue, lightCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Radial highlight overlay
    static let radialNavyGradient = RadialGradient(
        colors: [lightCyan.opacity(0.3), Color.clear],
        center: .bottomTrailing,
        startRadius: 50,
        endRadius: 250
    )
    
    /// Shadow radial for depth
    static let shadowRadialGradient = RadialGradient(
        colors: [Color.clear, deepNavy.opacity(0.4)],
        center: .topLeading,
        startRadius: 100,
        endRadius: 300
    )
}

// MARK: - Color Extension for Hex Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}