//
//  BackgroundByTheme.swift
//  SportsDB
//
//  Created by Macbook on 14/12/25.
//

import SwiftUI

struct BackgroundByThemeViewModifier: ViewModifier {

    var theme: Theme
    
    func body(content: Content) -> some View {
        switch theme {
        case .Header(tintColor: _, let height):
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
        case .Button(tintColor: _, material: let material, cornerRadius: let cornerRadius):
            switch material {
            case .none:
                content
                    .modifier(self.theme.glassEffect)
            case .ultraThin:
                content
                    .modifier(self.theme.glassEffect)
                    .background(.ultraThinMaterial.opacity(0.6), in: RoundedRectangle(cornerRadius: cornerRadius.rawValue, style: .continuous))
            }
        case .ItemSelected(item: let item):
            content
                .background{
                    if item.isSelected {
                        Color.clear
                            .modifier(self.theme.glassEffect)
                            .matchedGeometryEffect(id: item.animationName, in: item.animationID)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: item.isSelected)
        }
    }
}


extension View {
    func backgroundByTheme(for theme: Theme) -> some View {
        self.modifier(BackgroundByThemeViewModifier(theme: theme))
    }
}
