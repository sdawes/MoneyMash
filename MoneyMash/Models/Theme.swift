//
//  Theme.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 16/06/2025.
//

import SwiftUI

// MARK: - Theme Colors
extension Color {
    // App Brand Colors
    static let navyBlue = Color(red: 0.11, green: 0.25, blue: 0.49)
    static let darkRed = Color(red: 0.7, green: 0.2, blue: 0.2)
    static let standardRed = Color.red
    
    // Currently using system defaults, but ready for custom theming
    // Example: static let textPrimary = Color.black
    // Example: static let surface = Color.white
}

// MARK: - Theme Fonts  
extension Font {
    // App Brand Fonts
    static let appTitle = Font.system(.title3, design: .monospaced, weight: .medium)
    
    // Currently using system defaults, but ready for custom fonts
    // Example: static let titleFont = Font.system(.title, design: .default)
}