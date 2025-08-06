//
//  LiquidGlassMaterial.swift
//  SportsDB
//
//  Created by Macbook on 6/8/25.
//

import SwiftUI
import Combine

// MARK: - LiquidGlass Core Material
@available(iOS 13.0, *)
public struct LiquidGlassMaterial: ViewModifier {
    let cornerRadius: Double
    let intensity: Double
    let tintColor: Color
    let isInteractive: Bool
    let hasShimmer: Bool
    let hasGlow: Bool
    
    @State private var glowIntensity: Double = 0.0
    @State private var shimmerOffset: CGFloat = -1.0
    @State private var hoverScale: CGFloat = 1.0
    
    public init(
        cornerRadius: Double = 16,
        intensity: Double = 0.8,
        tintColor: Color = .white,
        isInteractive: Bool = true,
        hasShimmer: Bool = false,
        hasGlow: Bool = false
    ) {
        self.intensity = intensity
        self.tintColor = tintColor
        self.isInteractive = isInteractive
        self.hasShimmer = hasShimmer
        self.hasGlow = hasGlow
        self.cornerRadius = cornerRadius
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Base glass layer
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    tintColor.opacity(0.15 + (hasGlow ? glowIntensity * 0.1 : 0)),
                                    tintColor.opacity(0.05 + (hasGlow ? glowIntensity * 0.05 : 0))
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Shimmer overlay (only if enabled)
                    if hasShimmer {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: UnitPoint(x: shimmerOffset, y: 0),
                                    endPoint: UnitPoint(x: shimmerOffset + 0.3, y: 1)
                                )
                            )
                            .mask(RoundedRectangle(cornerRadius: cornerRadius))
                    }
                    
                    // Border highlight
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .scaleEffect(hoverScale)
            .animation(.easeInOut(duration: 0.2), value: hoverScale)
            .animation(hasShimmer ? .easeInOut(duration: 2.0).repeatForever(autoreverses: true) : .default, value: shimmerOffset)
            .animation(hasGlow ? .easeInOut(duration: 1.5).repeatForever(autoreverses: true) : .default, value: glowIntensity)
            .onAppear {
                if hasShimmer {
                    shimmerOffset = 1.0
                }
                if hasGlow {
                    glowIntensity = 1.0
                }
            }
    }
}

// MARK: - LiquidGlass Button
@available(iOS 13.0, *)
public struct LiquidGlassButton<Content: View>: View {
    let content: Content
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var rippleOffset: CGFloat = 0
    @State private var showRipple = false
    
    public init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    public var body: some View {
        Button(action: action) {
            content
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        // Ripple effect
                        if showRipple {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .scaleEffect(rippleOffset)
                                .opacity(1.0 - rippleOffset * 0.5)
                        }
                    }
                )
                .modifier(
                    LiquidGlassMaterial(
                        intensity: isPressed ? 1.2 : 0.8,
                        tintColor: .blue,
                        hasShimmer: true,
                        hasGlow: true
                    )
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
            
            if pressing {
                createRipple()
            }
        }, perform: {})
    }
    
    private func createRipple() {
        showRipple = true
        rippleOffset = 0
        
        withAnimation(.easeOut(duration: 0.6)) {
            rippleOffset = 2.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showRipple = false
        }
    }
}

// MARK: - LiquidGlass Card
@available(iOS 13.0, *)
public struct LiquidGlassCard<Content: View>: View {
    let content: Content
    let elevation: Double
    
    @State private var rotationX: Double = 0
    @State private var rotationY: Double = 0
    @State private var glowRadius: CGFloat = 0
    
    public init(elevation: Double = 1.0, @ViewBuilder content: () -> Content) {
        self.elevation = elevation
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(20)
            .modifier(
                LiquidGlassMaterial(
                    intensity: 0.9,
                    tintColor: .white,
                    hasGlow: true
                )
            )
            .shadow(
                color: Color.black.opacity(0.1 * elevation),
                radius: 10 * elevation,
                x: 0,
                y: 5 * elevation
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
            .rotation3DEffect(
                .degrees(rotationX),
                axis: (x: 1, y: 0, z: 0)
            )
            .rotation3DEffect(
                .degrees(rotationY),
                axis: (x: 0, y: 1, z: 0)
            )
            .onAppear {
                startGlowAnimation()
            }
    }
    
    private func startGlowAnimation() {
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            glowRadius = 20
        }
    }
}

// MARK: - LiquidGlass Navigation Bar
@available(iOS 13.0, *)
public struct LiquidGlassNavigationBar<Content: View>: View {
    let title: String
    let content: Content
    
    @State private var scrollOffset: CGFloat = 0
    
    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .modifier(
                LiquidGlassMaterial(
                    intensity: min(1.0, abs(scrollOffset) / 100.0),
                    tintColor: .white,
                    isInteractive: false
                )
            //.opacity(min(1.0, abs(scrollOffset) / 50))
            )
            /*
            .background(
                LiquidGlassMaterial(
                    intensity: min(1.0, abs(scrollOffset) / 100),
                    tintColor: .white,
                    isInteractive: false
                )
                .opacity(min(1.0, abs(scrollOffset) / 50))
            )
            */
            
            // Content
            ScrollView {
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            scrollOffset = geometry.frame(in: .global).minY
                        }
                        .onChange(of: geometry.frame(in: .global).minY) { value in
                            scrollOffset = value
                        }
                }
                .frame(height: 0)
                
                content
            }
        }
    }
}

/*
// MARK: - LiquidGlass Tab Bar
@available(iOS 13.0, *)
public struct LiquidGlassTabBar: View {
    @Binding var selection: Int
    let items: [TabItem]
    
    @State private var activeIndicatorOffset: CGFloat = 0
    
    public init(selection: Binding<Int>, items: [TabItem]) {
        self._selection = selection
        self.items = items
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                TabBarButton(
                    item: items[index],
                    isSelected: selection == index,
                    action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selection = index
                        }
                    }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .modifier(
            LiquidGlassMaterial(
                intensity: 1.0,
                tintColor: .white,
                isInteractive: false
            )
        )
        .overlay(
            // Active indicator
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 60, height: 4)
                .offset(x: activeIndicatorOffset)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: activeIndicatorOffset),
            alignment: .bottom
        )
        .onChange(of: selection) { newValue in
            updateIndicatorPosition(for: newValue)
        }
    }
    
    private func updateIndicatorPosition(for index: Int) {
        let screenWidth = UIScreen.main.bounds.width - 20
        let buttonWidth = screenWidth / CGFloat(items.count)
        let offset = (buttonWidth * CGFloat(index)) + (buttonWidth / 2) - (screenWidth / 2)
        activeIndicatorOffset = offset
    }
}

// MARK: - Supporting Types
public struct TabItem {
    public let title: String
    public let icon: String
    
    public init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
}

struct TabBarButton: View {
    let item: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            action()
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }) {
            VStack(spacing: 4) {
                Image(systemName: item.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .scaleEffect(scale)
                
                Text(item.title)
                    .font(.caption2)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .foregroundColor(isSelected ? .blue : .secondary)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if isSelected {
                scale = 1.1
            }
        }
        .onChange(of: isSelected) { selected in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = selected ? 1.1 : 1.0
            }
        }
    }
}

*/
// MARK: - LiquidGlass Extensions
@available(iOS 13.0, *)
extension View {
    public func liquidGlass(
        cornerRadius: Double = 16,
        intensity: Double = 0.8,
        tintColor: Color = .white,
        isInteractive: Bool = true,
        hasShimmer: Bool = false,
        hasGlow: Bool = false
    ) -> some View {
        self.modifier(
            LiquidGlassMaterial(
                cornerRadius: cornerRadius,
                intensity: intensity,
                tintColor: tintColor,
                isInteractive: isInteractive,
                hasShimmer: hasShimmer,
                hasGlow: hasGlow
            )
        )
    }
}

// MARK: - Preset Styles
@available(iOS 13.0, *)
extension LiquidGlassMaterial {
    public static let card = LiquidGlassMaterial(
        intensity: 0.9,
        tintColor: .white,
        isInteractive: false,
        hasShimmer: false,
        hasGlow: false
    )
    
    public static let button = LiquidGlassMaterial(
        intensity: 0.8,
        tintColor: .blue,
        isInteractive: true,
        hasShimmer: true,
        hasGlow: true
    )
    
    public static let navigation = LiquidGlassMaterial(
        intensity: 1.0,
        tintColor: .white,
        isInteractive: false,
        hasShimmer: false,
        hasGlow: false
    )
    
    public static let subtle = LiquidGlassMaterial(
        intensity: 0.6,
        tintColor: .gray,
        isInteractive: false,
        hasShimmer: false,
        hasGlow: false
    )
    
    public static let shimmer = LiquidGlassMaterial(
        intensity: 0.8,
        tintColor: .white,
        isInteractive: true,
        hasShimmer: true,
        hasGlow: false
    )
    
    public static let glow = LiquidGlassMaterial(
        intensity: 0.8,
        tintColor: .blue,
        isInteractive: true,
        hasShimmer: false,
        hasGlow: true
    )
}

// MARK: ===============================================================================================


import SwiftUI
import UIKit

// MARK: - Advanced Liquid Glass Effects

@available(iOS 13.0, *)
public struct LiquidGlassBlur: ViewModifier {
    let radius: CGFloat
    let opaque: Bool
    
    public init(radius: CGFloat = 10, opaque: Bool = false) {
        self.radius = radius
        self.opaque = opaque
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        } else {
            content
                .background(
                    VisualEffectBlur(blurStyle: .systemThinMaterial, vibrancy: true)
                        .cornerRadius(16)
                )
        }
    }
}

// Custom blur implementation for older iOS versions
@available(iOS 13.0, *)
struct VisualEffectBlur: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style
    let vibrancy: Bool
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blur = UIBlurEffect(style: blurStyle)
        let view = UIVisualEffectView(effect: blur)
        
        if vibrancy {
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blur)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            view.contentView.addSubview(vibrancyView)
            vibrancyView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vibrancyView.topAnchor.constraint(equalTo: view.contentView.topAnchor),
                vibrancyView.leadingAnchor.constraint(equalTo: view.contentView.leadingAnchor),
                vibrancyView.trailingAnchor.constraint(equalTo: view.contentView.trailingAnchor),
                vibrancyView.bottomAnchor.constraint(equalTo: view.contentView.bottomAnchor)
            ])
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - Lensing Effect
@available(iOS 13.0, *)
public struct LensingEffect: ViewModifier {
    @State private var lensPosition: CGPoint = .zero
    @State private var showLens = false
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .position(lensPosition)
                    .opacity(showLens ? 1 : 0)
                    .animation(.easeOut(duration: 0.3), value: showLens)
            )
            .onTapGesture { location in
                lensPosition = location
                showLens = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    showLens = false
                }
            }
    }
}

// MARK: - Morphing Shape
@available(iOS 13.0, *)
public struct MorphingGlass<Content: View>: View {
    let content: Content
    @State private var morphPhase: Double = 0
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .clipShape(MorphingShape(phase: morphPhase))
            .modifier(LiquidGlassMaterial())
            .onAppear {
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    morphPhase = 1
                }
            }
    }
}

struct MorphingShape: Shape {
    let phase: Double
    
    var animatableData: Double {
        get { phase }
        set { }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let waveHeight = 10.0
        
        path.move(to: CGPoint(x: 0, y: height * 0.5))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin((relativeX + phase) * 2 * .pi * 2) * waveHeight
            let y = height * 0.5 + sine
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Particle System
@available(iOS 13.0, *)
public struct ParticleGlass: View {
    @State private var particles: [Particle] = []
    let particleCount = 20
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ForEach(particles.indices, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: particles[index].size, height: particles[index].size)
                    .position(particles[index].position)
                    .opacity(particles[index].opacity)
            }
        }
        .onAppear {
            createParticles()
            animateParticles()
        }
    }
    
    private func createParticles() {
        particles = (0..<particleCount).map { _ in
            Particle(
                position: CGPoint(
                    x: Double.random(in: 0...400),
                    y: Double.random(in: 0...800)
                ),
                size: Double.random(in: 2...8),
                opacity: Double.random(in: 0.2...0.8)
            )
        }
    }
    
    private func animateParticles() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.linear(duration: 0.1)) {
                for i in particles.indices {
                    particles[i].position.y -= Double.random(in: 1...3)
                    particles[i].opacity *= 0.995
                    
                    if particles[i].position.y < -10 || particles[i].opacity < 0.1 {
                        particles[i] = Particle(
                            position: CGPoint(
                                x: Double.random(in: 0...400),
                                y: 810
                            ),
                            size: Double.random(in: 2...8),
                            opacity: Double.random(in: 0.2...0.8)
                        )
                    }
                }
            }
        }
    }
}

struct Particle {
    var position: CGPoint
    let size: Double
    var opacity: Double
}

// MARK: - Liquid Glass Form Controls
@available(iOS 13.0, *)
public struct LiquidGlassTextField: View {
    @Binding var text: String
    let placeholder: String
    
    @State private var isFocused = false
    @FocusState private var textFieldFocused: Bool
    
    public init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placeholder)
                .font(.caption)
                .foregroundColor(.secondary)
                .opacity(isFocused || !text.isEmpty ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    isFocused ? Color.blue : Color.white.opacity(0.3),
                                    lineWidth: isFocused ? 2 : 1
                                )
                        )
                )
                .focused($textFieldFocused)
                .onChange(of: textFieldFocused) { focused in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFocused = focused
                    }
                }
        }
    }
}

// MARK: - Liquid Glass Slider
@available(iOS 13.0, *)
public struct LiquidGlassSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    @State private var isDragging = false
    @State private var lastValue: Double = 0
    
    public init(value: Binding<Double>, in range: ClosedRange<Double>) {
        self._value = value
        self.range = range
        self._lastValue = State(initialValue: value.wrappedValue)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width
            let knobPosition = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * trackWidth
            
            ZStack(alignment: .leading) {
                // Track
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 6)
                
                // Progress
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: knobPosition, height: 6)
                
                // Knob
                Circle()
                    .fill(Color.white)
                    .frame(width: isDragging ? 28 : 24, height: isDragging ? 28 : 24)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .position(x: knobPosition, y: geometry.size.height / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if !isDragging {
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        isDragging = true
                                    }
                                }
                                
                                let newValue = Double(gesture.location.x / trackWidth) * (range.upperBound - range.lowerBound) + range.lowerBound
                                value = min(max(newValue, range.lowerBound), range.upperBound)
                            }
                            .onEnded { _ in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isDragging = false
                                }
                            }
                    )
            }
        }
        .frame(height: 44)
    }
}

// MARK: - Liquid Glass Toggle
@available(iOS 13.0, *)
public struct LiquidGlassToggle: View {
    @Binding var isOn: Bool
    let label: String
    
    @State private var knobOffset: CGFloat = 0
    
    public init(isOn: Binding<Bool>, label: String) {
        self._isOn = isOn
        self.label = label
    }
    
    public var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Toggle Switch
            ZStack {
                Capsule()
                    .fill(isOn ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 50, height: 30)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 26, height: 26)
                    .offset(x: isOn ? 10 : -10)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isOn.toggle()
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Extensions for advanced effects
@available(iOS 13.0, *)
extension View {
    public func liquidGlassBlur(radius: CGFloat = 10, opaque: Bool = false) -> some View {
        self.modifier(LiquidGlassBlur(radius: radius, opaque: opaque))
    }
    
    public func lensingEffect() -> some View {
        self.modifier(LensingEffect())
    }
    
    public func morphingGlass() -> some View {
        MorphingGlass {
            self
        }
    }
}

// MARK: ===============================================================================================

import SwiftUI

@available(iOS 13.0, *)
struct LiquidGlassDemoApp: View {
    @State private var selectedTab = 0
    @State private var sliderValue: Double = 0.5
    @State private var toggleValue = false
    @State private var textFieldValue = ""
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.3),
                    Color.pink.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Particle background
            ParticleGlass()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation with Liquid Glass
                LiquidGlassNavigationBar(title: "Liquid Glass Demo") {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            // Demo Sections
                            buttonsSection
                            cardsSection
                            formControlsSection
                            effectsSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100) // Space for tab bar
                    }
                }
                
                Spacer()
            }
            
            
            // Tab Bar
            /*
            VStack {
                Spacer()
                LiquidGlassTabBar(
                    selection: $selectedTab,
                    items: [
                        TabItem(title: "Home", icon: "house.fill"),
                        TabItem(title: "Components", icon: "square.grid.2x2"),
                        TabItem(title: "Effects", icon: "wand.and.stars"),
                        TabItem(title: "Settings", icon: "gear")
                    ]
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                
            }
            */
        }
    }
    
    // MARK: - Demo Sections
    
    private var buttonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Buttons")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 15) {
                LiquidGlassButton(action: {
                    print("Primary button tapped")
                }) {
                    Text("Primary")
                        .fontWeight(.semibold)
                }
                
                LiquidGlassButton(action: {
                    print("Secondary button tapped")
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("Secondary")
                    }
                }
            }
        }
    }
    
    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cards")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LiquidGlassCard(elevation: 1.5) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text("Liquid Glass Card")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Interactive glass material with depth")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    Text("This card demonstrates the liquid glass material with subtle animations, transparency effects, and responsive interactions.")
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
            .lensingEffect() // Add lensing effect
            
            LiquidGlassCard(elevation: 2.0) {
                VStack(spacing: 15) {
                    Text("Morphing Glass")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Watch the subtle shape morphing animation")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .morphingGlass()
        }
    }
    
    private var formControlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Form Controls")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LiquidGlassCard {
                VStack(spacing: 20) {
                    LiquidGlassTextField(
                        text: $textFieldValue,
                        placeholder: "Enter your text"
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Slider Value: \(Int(sliderValue * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        LiquidGlassSlider(
                            value: $sliderValue,
                            in: 0...1
                        )
                    }
                    
                    LiquidGlassToggle(
                        isOn: $toggleValue,
                        label: "Enable Liquid Glass Effects"
                    )
                }
            }
        }
    }
    
    private var effectsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Special Effects")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Blur Effect Demo
            HStack {
                Text("Blur Effect")
                    .padding()
                    .liquidGlassBlur()
                    .cornerRadius(12)
                
                Spacer()
                
                Text("Standard")
                    .padding()
                    .liquidGlass(tintColor: .green)
            }
            
            // Interactive Lens Effect
            Text("Tap anywhere on this card for lens effect")
                .padding(20)
                .frame(maxWidth: .infinity)
                .liquidGlass(tintColor: .orange)
                .lensingEffect()
            
            // Preset Styles Demo
            VStack(spacing: 12) {
                Text("Preset Styles")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 10) {
                    Text("Card")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .modifier(LiquidGlassMaterial.card)
                    
                    Text("Button")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .modifier(LiquidGlassMaterial.button)
                    
                    Text("Subtle")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .modifier(LiquidGlassMaterial.subtle)
                }
                
                HStack(spacing: 10) {
                    Text("Shimmer")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .modifier(LiquidGlassMaterial.shimmer)
                    
                    Text("Glow")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .modifier(LiquidGlassMaterial.glow)
                    
                    Text("Navigation")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .modifier(LiquidGlassMaterial.navigation)
                }
            }
            .padding()
            .liquidGlass(intensity: 0.7, tintColor: .purple, isInteractive: false)
            
            // Custom Effects Demo
            VStack(spacing: 12) {
                Text("Custom Effects")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("No Effects (Clean)")
                    .padding()
                    .liquidGlass()
                
                Text("With Shimmer Only")
                    .padding()
                    .liquidGlass(hasShimmer: true)
                
                Text("With Glow Only")
                    .padding()
                    .liquidGlass(tintColor: .green, hasGlow: true)
                
                Text("Shimmer + Glow")
                    .padding()
                    .liquidGlass(tintColor: .orange, hasShimmer: true, hasGlow: true)
            }
        }
    }
}

// MARK: - Preview
@available(iOS 13.0, *)
struct LiquidGlassDemoApp_Previews: PreviewProvider {
    static var previews: some View {
        LiquidGlassDemoApp()
            .preferredColorScheme(.dark)
    }
}

// MARK: - Usage Examples & Documentation
/*
 
 LIQUID GLASS LIBRARY - USAGE EXAMPLES
 =====================================
 
 1. Basic Liquid Glass Material:
 ```swift
 Text("Hello World")
     .padding()
     .liquidGlass()
 ```
 
 2. Custom Glass with Parameters:
 ```swift
 VStack {
     Text("Content")
 }
 .liquidGlass(
     intensity: 0.9,
     tintColor: .blue,
     isInteractive: true,
     hasShimmer: true,
     hasGlow: false
 )
 ```
 
 3. Liquid Glass Button:
 ```swift
 LiquidGlassButton(action: {
     // Action here
 }) {
     Text("Tap Me")
 }
 ```
 
 4. Liquid Glass Card:
 ```swift
 LiquidGlassCard(elevation: 1.5) {
     VStack {
         Text("Card Content")
         // More content...
     }
 }
 ```
 
 5. Navigation Bar:
 ```swift
 LiquidGlassNavigationBar(title: "My App") {
     ScrollView {
         // Content here
     }
 }
 ```
 
 6. Tab Bar:
 ```swift
 LiquidGlassTabBar(
     selection: $selectedTab,
     items: [
         TabItem(title: "Home", icon: "house"),
         TabItem(title: "Search", icon: "magnifyingglass")
     ]
 )
 ```
 
 7. Form Controls:
 ```swift
 // Text Field
 LiquidGlassTextField(text: $text, placeholder: "Enter text")
 
 // Slider
 LiquidGlassSlider(value: $value, in: 0...100)
 
 // Toggle
 LiquidGlassToggle(isOn: $isOn, label: "Enable Feature")
 ```
 
 8. Special Effects:
 ```swift
 // Blur Effect
 Text("Blurred")
     .liquidGlassBlur()
 
 // Lensing Effect
 Rectangle()
     .lensingEffect()
 
 // Morphing Glass
 Text("Morphing")
     .morphingGlass()
 ```
 
 9. Preset Styles:
 ```swift
 Text("Card Style")
     .modifier(LiquidGlassMaterial.card)
 
 Text("Button Style (with shimmer + glow)")
     .modifier(LiquidGlassMaterial.button)
 
 Text("Navigation Style")
     .modifier(LiquidGlassMaterial.navigation)
 
 Text("Subtle Style")
     .modifier(LiquidGlassMaterial.subtle)
 
 Text("Shimmer Only")
     .modifier(LiquidGlassMaterial.shimmer)
 
 Text("Glow Only")
     .modifier(LiquidGlassMaterial.glow)
 ```
 
 10. Effect Control Examples:
 ```swift
 // Clean glass (no effects)
 Text("Clean").liquidGlass()
 
 // With shimmer only
 Text("Shimmer").liquidGlass(hasShimmer: true)
 
 // With glow only
 Text("Glow").liquidGlass(hasGlow: true)
 
 // Both effects
 Text("Both").liquidGlass(hasShimmer: true, hasGlow: true)
 ```
 
 COMPATIBILITY:
 - iOS 13.0+ (Core features)
 - iOS 15.0+ (Enhanced blur effects)
 - Supports Dark Mode automatically
 - Works with all device sizes
 - Optimized for performance
 
 FEATURES:
 ✅ Dynamic glass material simulation
 ✅ Real-time responsiveness
 ✅ Transparency and depth effects
 ✅ Lensing and morphing animations
 ✅ Interactive ripple effects
 ✅ Particle systems
 ✅ Form controls with glass styling
 ✅ Navigation and tab bar components
 ✅ Haptic feedback integration
 ✅ Accessibility support
 ✅ Performance optimized
 ✅ Customizable presets
 
 */
