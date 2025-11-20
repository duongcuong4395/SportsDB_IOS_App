//
//  ScrollButtonStyle.swift
//  SportsDB
//
//  Created by Macbook on 19/11/25.
//

import SwiftUI

// MARK: - ScrollButtonStyle.swift (Complete)
public struct ScrollButtonStyle {
    public var icon: String
    public var label: String
    public var backgroundColor: Color
    public var foregroundColor: Color
    public var cornerRadius: CGFloat
    public var padding: EdgeInsets
    public var shadow: ShadowStyle
    public var material: Material?
    public var position: Position
    public var offset: CGPoint
    
    public init(
        icon: String = "arrow.down.circle.fill",
        label: String = "Scroll Down",
        backgroundColor: Color = .clear,
        foregroundColor: Color = .primary,
        cornerRadius: CGFloat = 12,
        padding: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
        shadow: ShadowStyle = .default,
        material: Material? = .regularMaterial,
        position: Position = .bottomTrailing,
        offset: CGPoint = CGPoint(x: -20, y: -20)
    ) {
        self.icon = icon
        self.label = label
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.shadow = shadow
        self.material = material
        self.position = position
        self.offset = offset
    }
    
    public static let defaultBottom = ScrollButtonStyle()
    public static let defaultTop = ScrollButtonStyle(
        icon: "arrow.up.circle.fill",
        label: "Scroll Up",
        position: .topTrailing
    )
    public static let minimal = ScrollButtonStyle(
        icon: "arrow.down",
        label: "Down",
        backgroundColor: .black.opacity(0.1),
        cornerRadius: 20,
        padding: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10),
        shadow: .none,
        material: nil
    )
    public static let floating = ScrollButtonStyle(
        icon: "arrow.down.circle.fill",
        label: "",
        backgroundColor: .accentColor,
        foregroundColor: .white,
        cornerRadius: 25,
        padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
        shadow: .prominent,
        material: nil
    )
    
    public enum Position {
        case topLeading, top, topTrailing
        case leading, center, trailing
        case bottomLeading, bottom, bottomTrailing
        
        var alignment: Alignment {
            switch self {
            case .topLeading: return .topLeading
            case .top: return .top
            case .topTrailing: return .topTrailing
            case .leading: return .leading
            case .center: return .center
            case .trailing: return .trailing
            case .bottomLeading: return .bottomLeading
            case .bottom: return .bottom
            case .bottomTrailing: return .bottomTrailing
            }
        }
    }
    
    public enum ShadowStyle {
        case none, `default`, prominent
        
        var radius: CGFloat {
            switch self {
            case .none: return 0
            case .default: return 4
            case .prominent: return 8
            }
        }
        
        var opacity: Double {
            switch self {
            case .none: return 0
            case .default: return 0.2
            case .prominent: return 0.3
            }
        }
    }
    
    @ViewBuilder
    func makeButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(label, systemImage: icon)
                .labelStyle(.iconOnly)
                .padding(padding)
                .background(
                    Group {
                        if let material = material {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(material)
                        } else {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(backgroundColor)
                        }
                    }
                )
                .foregroundStyle(foregroundColor)
                .shadow(
                    color: .black.opacity(shadow.opacity),
                    radius: shadow.radius,
                    x: 0,
                    y: 2
                )
        }
        .buttonStyle(.plain)
    }
}
