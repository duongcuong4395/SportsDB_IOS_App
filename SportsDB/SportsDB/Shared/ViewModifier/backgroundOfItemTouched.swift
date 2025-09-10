//
//  backgroundOfItemTouched.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

struct BackgroundOfItemTouchedModifier: ViewModifier {
    var padding: CGFloat
    var tintColor: Color
    var cornerRadius: Double
    var intensity: Double
    var hasGlow: Bool
    var hasShimmer: Bool
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background{
                Color.clear
                    .liquidGlass(intensity: intensity, tintColor: tintColor, hasShimmer: hasShimmer, hasGlow: hasGlow)
            }
            .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

extension View {
    func backgroundOfItemTouched(padding: CGFloat = 5, color: Color = .orange, cornerRadius: Double = 20, intensity: Double = 0.8, hasGlow: Bool = true, hasShimmer: Bool = true) -> some View {
        self.modifier(BackgroundOfItemTouchedModifier(padding: padding, tintColor: color, cornerRadius: cornerRadius, intensity: intensity, hasGlow: hasGlow, hasShimmer: hasShimmer))
    }
}
