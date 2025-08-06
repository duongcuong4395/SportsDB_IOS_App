//
//  LiquidGlassLibrary.swift
//  SportsDB
//
//  Created by Macbook on 6/8/25.
//

import SwiftUI

// MARK: - Liquid Glass Library for iOS < 18.0

@available(iOS 13.0, *)
public struct LiquidGlassLibrary {
    
    // MARK: - Glass Background View
    public struct GlassBackground: View {
        let intensity: Double
        let cornerRadius: CGFloat
        let borderColor: Color
        let borderWidth: CGFloat
        
        public init(
            intensity: Double = 0.3,
            cornerRadius: CGFloat = 20,
            borderColor: Color = Color.white.opacity(0.2),
            borderWidth: CGFloat = 1
        ) {
            self.intensity = intensity
            self.cornerRadius = cornerRadius
            self.borderColor = borderColor
            self.borderWidth = borderWidth
        }
        
        public var body: some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(intensity * 0.8),
                            Color.white.opacity(intensity * 0.3),
                            Color.white.opacity(intensity * 0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    // MARK: - Frosted Glass Effect
    public struct FrostedGlass: View {
        let blur: CGFloat
        let opacity: Double
        let cornerRadius: CGFloat
        
        public init(blur: CGFloat = 20, opacity: Double = 0.3, cornerRadius: CGFloat = 20) {
            self.blur = blur
            self.opacity = opacity
            self.cornerRadius = cornerRadius
        }
        
        public var body: some View {
            if #available(iOS 15.0, *) {
                // Sử dụng Material cho iOS 15+
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            } else {
                // Fallback cho iOS cũ hơn
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        Color.white.opacity(opacity)
                    )
                    .blur(radius: blur * 0.1)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.5),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            }
        }
    }
    
    // MARK: - Animated Liquid Effect
    public struct LiquidShape: Shape {
        public var animatableData: Double
        
        public init(phase: Double = 0) {
            self.animatableData = phase
        }
        
        public func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: 0, y: height * 0.3))
            
            path.addCurve(
                to: CGPoint(x: width * 0.3, y: height * 0.1),
                control1: CGPoint(x: width * 0.1, y: height * 0.2 + sin(animatableData) * 10),
                control2: CGPoint(x: width * 0.2, y: height * 0.05)
            )
            
            path.addCurve(
                to: CGPoint(x: width * 0.7, y: height * 0.15),
                control1: CGPoint(x: width * 0.5, y: height * 0.05 + cos(animatableData * 1.2) * 8),
                control2: CGPoint(x: width * 0.6, y: height * 0.1)
            )
            
            path.addCurve(
                to: CGPoint(x: width, y: height * 0.4),
                control1: CGPoint(x: width * 0.8, y: height * 0.2),
                control2: CGPoint(x: width * 0.9, y: height * 0.3 + sin(animatableData * 0.8) * 12)
            )
            
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
            
            return path
        }
    }
    
    // MARK: - Animated Liquid Glass View
    public struct AnimatedLiquidGlass: View {
        @State private var phase: Double = 0
        let colors: [Color]
        let duration: Double
        
        public init(
            colors: [Color] = [
                Color.blue.opacity(0.3),
                Color.purple.opacity(0.2),
                Color.pink.opacity(0.1)
            ],
            duration: Double = 3.0
        ) {
            self.colors = colors
            self.duration = duration
        }
        
        public var body: some View {
            ZStack {
                ForEach(0..<colors.count, id: \.self) { index in
                    LiquidShape(phase: phase + Double(index) * 0.5)
                        .fill(
                            LinearGradient(
                                colors: [colors[index], Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(1.0 + Double(index) * 0.1)
                        .rotationEffect(.degrees(Double(index) * 15))
                }
            }
            .onAppear {
                withAnimation(
                    Animation.linear(duration: duration)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = .pi * 2
                }
            }
        }
    }
    
    // MARK: - Glass Card Component
    public struct GlassCard<Content: View>: View {
        let content: Content
        let cornerRadius: CGFloat
        let intensity: Double
        
        public init(
            cornerRadius: CGFloat = 20,
            intensity: Double = 0.3,
            @ViewBuilder content: () -> Content
        ) {
            self.cornerRadius = cornerRadius
            self.intensity = intensity
            self.content = content()
        }
        
        public var body: some View {
            content
                .padding()
                .background(
                    GlassBackground(
                        intensity: intensity,
                        cornerRadius: cornerRadius
                    )
                )
        }
    }
    
    // MARK: - Shimmering Glass Effect
    public struct ShimmeringGlass: View {
        @State private var shimmerOffset: CGFloat = -1
        let cornerRadius: CGFloat
        
        public init(cornerRadius: CGFloat = 20) {
            self.cornerRadius = cornerRadius
        }
        
        public var body: some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white,
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .rotationEffect(.degrees(45))
                        .offset(x: shimmerOffset * 300)
                )
                .onAppear {
                    withAnimation(
                        Animation.linear(duration: 2)
                            .repeatForever(autoreverses: false)
                    ) {
                        shimmerOffset = 1
                    }
                }
        }
    }
}

// MARK: - View Extensions for Easy Usage
@available(iOS 13.0, *)
extension View {
    public func liquidGlass(
        intensity: Double = 0.3,
        cornerRadius: CGFloat = 20
    ) -> some View {
        self.background(
            LiquidGlassLibrary.GlassBackground(
                intensity: intensity,
                cornerRadius: cornerRadius
            )
        )
    }
    
    public func frostedGlass(
        blur: CGFloat = 20,
        opacity: Double = 0.3,
        cornerRadius: CGFloat = 20
    ) -> some View {
        self.background(
            LiquidGlassLibrary.FrostedGlass(
                blur: blur,
                opacity: opacity,
                cornerRadius: cornerRadius
            )
        )
    }
}

// MARK: - Example Usage Views
@available(iOS 13.0, *)
struct LiquidGlassExamples: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Basic Glass Card
                LiquidGlassLibrary.GlassCard {
                    VStack {
                        Text("Glass Card")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("This is a basic glass card with liquid effect")
                            .font(.body)
                            .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.primary)
                }
                
                // Animated Liquid Background
                VStack {
                    Text("Animated Liquid Glass")
                        .font(.headline)
                        .fontWeight(.medium)
                    Text("Dynamic flowing background")
                        .font(.subheadline)
                }
                .padding()
                .background(
                    LiquidGlassLibrary.AnimatedLiquidGlass()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                )
                
                // Shimmer Effect
                VStack {
                    Text("Shimmer Glass")
                        .font(.headline)
                    Text("With animated shimmer effect")
                        .font(.caption)
                }
                .padding()
                .background(
                    ZStack {
                        LiquidGlassLibrary.GlassBackground(intensity: 0.2)
                        LiquidGlassLibrary.ShimmeringGlass()
                    }
                )
                
                // Custom styled glass
                Text("Custom Glass")
                    .font(.title3)
                    .padding()
                    .liquidGlass(intensity: 0.5, cornerRadius: 15)
                
                // Frosted glass example
                Text("Frosted Glass")
                    .font(.title3)
                    .padding()
                    .frostedGlass(opacity: 0.4)
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.6),
                    Color.purple.opacity(0.8),
                    Color.pink.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}
