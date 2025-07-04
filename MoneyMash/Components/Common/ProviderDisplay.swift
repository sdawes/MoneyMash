//
//  ProviderDisplay.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI

struct ProviderDisplay: View {
    let provider: String
    let size: DisplaySize
    
    enum DisplaySize {
        case small, large
        
        var imageSize: CGFloat {
            switch self {
            case .small: return 24
            case .large: return 32
            }
        }
        
        var font: Font {
            switch self {
            case .small: return .subheadline
            case .large: return .title3
            }
        }
    }
    
    init(provider: String, size: DisplaySize = .small) {
        self.provider = provider
        self.size = size
    }
    
    private var assetName: String {
        // Convert provider name to asset name format
        // "HL" -> "provider_logo_hl"
        // "Trading 212" -> "provider_logo_trading212"
        // "Vanguard" -> "provider_logo_vanguard"
        let cleanProvider = provider
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "&", with: "and")
        return "provider_logo_\(cleanProvider)"
    }
    
    private var hasLogo: Bool {
        UIImage(named: assetName) != nil
    }
    
    var body: some View {
        if hasLogo {
            Image(assetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.imageSize, height: size.imageSize)
                .cornerRadius(4)
        } else {
            Text(provider)
                .font(size.font)
                .foregroundColor(.secondary)
        }
    }
}


