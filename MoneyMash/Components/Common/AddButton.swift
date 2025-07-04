//
//  AddButton.swift
//  MoneyMash
//
//  Created by Stephen Dawes on 14/06/2025.
//

import SwiftUI

struct AddButton: View {
    let size: CGFloat
    
    init(size: CGFloat = 25) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.navyBlue)
                .frame(width: size, height: size)
            
            Image(systemName: "plus")
                .font(.system(size: size * 0.4, weight: .medium))
                .foregroundColor(.white)
        }
        .accessibilityLabel("Add new account")
        .accessibilityHint("Tap to create a new financial account")
    }
}


