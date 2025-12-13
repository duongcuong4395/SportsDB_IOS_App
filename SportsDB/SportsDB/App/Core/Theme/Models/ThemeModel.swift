//
//  ThemeModel.swift
//  SportsDB
//
//  Created by Macbook on 13/12/25.
//

import SwiftUI
import GlassEffect

enum ThemeMaterial {
    case none
    case ultraThin
}

enum Theme {
    case Header(height: CGFloat)
    case Card(material: ThemeMaterial)
    case Button
    
}

extension Theme {
    var glassEffect: GlassEffect {
        switch self {
        case .Header(height: _):
                .init(
                    cornerRadius: 20,
                    intensity: 6.15,
                    tintColor: .white,
                    isInteractive: false,
                    hasShimmer: false,
                    hasGlow: false,
                    gradientType: .linear,
                    gradientStart: UnitPoint(x: 0.00, y: 0.00),
                    gradientEnd: UnitPoint(x: 0.53, y: 0.00),
                    borderType: .gradient,
                    borderColor: .white,
                    borderOpacity: 0.39,
                    borderWidth: 0.5,
                    blurRadius: 1,
                    enableAnimations: false,
                    shimmerSpeed: 2.0,
                    shimmerDelay: 0.0,
                    glowSpeed: 1.5,
                    glowDelay: 0.0,
                    hoverAnimationSpeed: 0.2
                )
            
        case .Card(material: _):
                .init(
                    cornerRadius: 20,
                    intensity: 6.15,
                    tintColor: .white,
                    isInteractive: false,
                    hasShimmer: false,
                    hasGlow: false,
                    gradientType: .linear,
                    gradientStart: UnitPoint(x: 0.00, y: 0.00),
                    gradientEnd: UnitPoint(x: 0.53, y: 0.00),
                    borderType: .gradient,
                    borderColor: .white,
                    borderOpacity: 0.39,
                    borderWidth: 0.5,
                    blurRadius: 1,
                    enableAnimations: false,
                    shimmerSpeed: 2.0,
                    shimmerDelay: 0.0,
                    glowSpeed: 1.5,
                    glowDelay: 0.0,
                    hoverAnimationSpeed: 0.2
                )
        case .Button:
                .init(
                    cornerRadius: 50,
                    intensity: 0.8,
                    tintColor: .orange,
                    isInteractive: false,
                    hasShimmer: true,
                    hasGlow: true,
                    gradientType: .radial,
                    gradientCenterX: 0.50,
                    gradientCenterY: 0.50,
                    gradientStartRadius: 54,
                    gradientEndRadius: 168,
                    borderType: .gradient,
                    borderColor: .white,
                    borderOpacity: 0.50,
                    borderWidth: 0.0,
                    blurRadius: 3,
                    enableAnimations: true,
                    shimmerSpeed: 2.0,
                    shimmerDelay: 0.0,
                    glowSpeed: 1.5,
                    glowDelay: 0.0,
                    hoverAnimationSpeed: 0.2
                )
        }
    }
}
