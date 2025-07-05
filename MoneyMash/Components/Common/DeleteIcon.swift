//
//  DeleteIcon.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI

struct DeleteIcon: View {
    let size: CGFloat
    
    init(size: CGFloat = 25) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.darkRed)
                .frame(width: size, height: size)
            
            Image(systemName: "trash")
                .font(.system(size: size * 0.4, weight: .medium))
                .foregroundColor(.white)
        }
        .accessibilityLabel("Delete")
        .accessibilityHint("Tap to delete this item")
    }
}

#Preview {
    VStack(spacing: 20) {
        DeleteIcon(size: 24)
        DeleteIcon(size: 32)
        DeleteIcon(size: 40)
    }
    .padding()
}