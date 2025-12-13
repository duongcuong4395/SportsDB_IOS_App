//
//  BackgroundOfTabContentView.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

struct BackgroundByThemeViewModifier: ViewModifier {

    var theme: Theme
    
    func body(content: Content) -> some View {
        switch theme {
        case .Header(let height):
            content
                .frame(height: height)
                .background {
                    Color.clear
                        .modifier(self.theme.glassEffect)
                        .ignoresSafeArea(.all)
                }
        case .Card(tintColor: _, material: let material, cornerRadius: let cornerRadius):
            switch material {
            case .none:
                content
                    .modifier(self.theme.glassEffect)
            case .ultraThin:
                content
                    .modifier(self.theme.glassEffect)
                    .background(.ultraThinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: cornerRadius.rawValue, style: .continuous))
            }
        case .Button(material: let material, cornerRadius: let cornerRadius):
            switch material {
            case .none:
                content
                    .modifier(self.theme.glassEffect)
            case .ultraThin:
                content
                    .modifier(self.theme.glassEffect)
                    .background(.ultraThinMaterial.opacity(0.6), in: RoundedRectangle(cornerRadius: cornerRadius.rawValue, style: .continuous))
            }
            
        
        case .ItemSelected(isSelected: let isSelected, cornerRadius: _, animation: let animation):
            content
                .background{
                    if isSelected {
                        Color.clear
                            .modifier(self.theme.glassEffect)
                            .matchedGeometryEffect(id: "season", in: animation)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: isSelected)
        }
    }
}


extension View {
    func backgroundByTheme(for theme: Theme) -> some View {
        self.modifier(BackgroundByThemeViewModifier(theme: theme))
    }
}


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
