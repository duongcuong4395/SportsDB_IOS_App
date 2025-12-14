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

enum CornerRadius: CGFloat {
    case none = 0.0
    case moderateAngle = 20
    case roundedCorners = 50
}

struct ItemModel {
    var isSelected: Bool
    var tintColor: Color
    var cornerRadius: CornerRadius = .moderateAngle
    var animationID: Namespace.ID
    var animationName: String
}

enum Theme {
    case Header(tintColor: Color = Color(red: 0.839216, green: 0.839216, blue: 0.839216, opacity: 1.000000), height: CGFloat)
    case Card(tintColor: Color = Color(red: 0.839216, green: 0.839216, blue: 0.839216, opacity: 1.000000)
              , material: ThemeMaterial = .ultraThin, cornerRadius: CornerRadius = .moderateAngle)
    case Button(tintColor: Color = .orange
                , material: ThemeMaterial = .ultraThin, cornerRadius: CornerRadius = .moderateAngle)
    case ItemSelected(item: ItemModel)
}

extension Theme {
    var glassEffect: GlassEffect {
        switch self {
        case .Header(tintColor: let tintColor, height: _):
                .init(
                    cornerRadius: 20,
                    intensity: 6.15,
                    tintColor: tintColor,
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
        case .Card(tintColor: let tintColor, material: _, cornerRadius: let cornerRadius):
                .init(
                    cornerRadius: cornerRadius.rawValue,
                    intensity: 4.5,
                    tintColor:  tintColor,
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
        case .Button(tintColor: let tintColor, material: _, cornerRadius: let cornerRadius):
                .init(
                    cornerRadius: cornerRadius.rawValue,
                    intensity: 0.8,
                    tintColor: tintColor,
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
        case .ItemSelected(item: let model):
                .init(
                    cornerRadius: model.cornerRadius.rawValue,
                    intensity: 1.8,
                    tintColor: model.tintColor,
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
