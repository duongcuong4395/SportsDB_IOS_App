//
//  GlassKit.swift
//  SportsDB
//
//  Created by Macbook on 7/11/25.
//

import SwiftUI
import Combine

// MARK: - 🚀 OPTIMIZED LiquidGlassMaterial
@available(iOS 13.0, *)
public struct OptimizedLiquidGlassMaterial: ViewModifier {
    let cornerRadius: Double
    let intensity: Double
    let tintColor: Color
    let hasShimmer: Bool
    let hasGlow: Bool
    
    @State private var glowIntensity: Double = 0.0
    @State private var shimmerOffset: CGFloat = -1.0
    
    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // ✅ FIX: Combine animations into single layer
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
                        .overlay(
                            // Shimmer as overlay instead of separate layer
                            hasShimmer ?
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ],
                                startPoint: UnitPoint(x: shimmerOffset, y: 0),
                                endPoint: UnitPoint(x: shimmerOffset + 0.3, y: 1)
                            ) : nil
                        )
                    
                    // Border as separate layer (doesn't animate)
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
            // ✅ FIX: Use withAnimation instead of .animation modifier
            .task {
                if hasShimmer {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        shimmerOffset = 1.0
                    }
                }
                if hasGlow {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        glowIntensity = 1.0
                    }
                }
            }
    }
}

// MARK: - 🚀 OPTIMIZED ParticleGlass
@available(iOS 13.0, *)
public struct OptimizedParticleGlass: View {
    @State private var particles: [Particle] = []
    @State private var timer: AnyCancellable?
    let particleCount = 15 // ✅ Reduced from 20
    
    public var body: some View {
        Canvas { context, size in
            // ✅ FIX: Use Canvas instead of ForEach for better performance
            for particle in particles {
                var path = Path()
                path.addEllipse(in: CGRect(
                    x: particle.position.x - particle.size / 2,
                    y: particle.position.y - particle.size / 2,
                    width: particle.size,
                    height: particle.size
                ))
                context.fill(path, with: .color(Color.white.opacity(particle.opacity)))
            }
        }
        .task {
            createParticles()
            startAnimation()
        }
        .onDisappear {
            // ✅ FIX: Cleanup timer
            timer?.cancel()
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
    
    private func startAnimation() {
        // ✅ FIX: Use Combine Timer with proper cleanup
        timer = Timer.publish(every: 0.05, on: .main, in: .common) // ✅ Reduced frequency
            .autoconnect()
            .sink { _ in
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

// MARK: - 🚀 OPTIMIZED NavigationBar
@available(iOS 13.0, *)
public struct OptimizedLiquidGlassNavigationBar<Content: View>: View {
    let title: String
    let content: Content
    
    @State private var scrollOffset: CGFloat = 0
    
    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                // ✅ FIX: Only apply material when needed
                Group {
                    if abs(scrollOffset) > 10 {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(min(0.15, abs(scrollOffset) / CGFloat(500))),
                                        Color.white.opacity(min(0.05, abs(scrollOffset) / CGFloat(1000)))
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            
            ScrollView {
                // ✅ FIX: Use ScrollViewReader + PreferenceKey instead of GeometryReader
                content
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: geo.frame(in: .named("scroll")).minY
                                )
                        }
                    )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                // ✅ FIX: Throttle updates
                if abs(value - scrollOffset) > 5 {
                    scrollOffset = value
                }
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/*
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
*/


// MARK: - 🚀 OPTIMIZED MorphingShape
struct OptimizedMorphingShape: Shape {
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
        
        // ✅ FIX: Reduce iterations dramatically
        let step: CGFloat = 5 // Instead of 1
        for x in stride(from: CGFloat(0), through: width, by: step) {
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

// MARK: - 📊 PERFORMANCE MONITORING
@available(iOS 13.0, *)
class PerformanceMonitor: ObservableObject {
    @Published var fps: Double = 0
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var frameCount = 0
    
    func startMonitoring() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func update(displayLink: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = displayLink.timestamp
            return
        }
        
        frameCount += 1
        let elapsed = displayLink.timestamp - lastTimestamp
        
        if elapsed >= 1.0 {
            fps = Double(frameCount) / elapsed
            frameCount = 0
            lastTimestamp = displayLink.timestamp
        }
    }
    
    func stopMonitoring() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

// MARK: - 💡 BEST PRACTICES EXAMPLE
@available(iOS 13.0, *)
struct PerformanceGuidelines: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ Performance Best Practices")
                .font(.headline)
            
            Group {
                Text("✅ DO:")
                    .fontWeight(.bold)
                
                Text("• Use .task instead of .onAppear for async work")
                Text("• Cleanup timers in .onDisappear")
                Text("• Use Canvas for many similar views")
                Text("• Throttle scroll offset updates")
                Text("• Reduce particle count on lower-end devices")
                Text("• Use drawingGroup() for complex animations")
                
                Text("\n❌ DON'T:")
                    .fontWeight(.bold)
                
                Text("• Stack multiple .animation() modifiers")
                Text("• Use GeometryReader in ScrollView without throttling")
                Text("• Create timers without cleanup")
                Text("• Animate on every pixel of scroll")
                Text("• Use ForEach for 20+ animated views")
            }
            .font(.caption)
        }
        .padding()
    }
}

// MARK: - 🎯 USAGE EXAMPLE
@available(iOS 13.0, *)
struct OptimizedUsageExample: View {
    @StateObject private var perfMonitor = PerformanceMonitor()
    
    var body: some View {
        ZStack {
            // ✅ Optimized particle background
            OptimizedParticleGlass()
                .ignoresSafeArea()
                .drawingGroup() // GPU acceleration
            
            VStack {
                Text("FPS: \(Int(perfMonitor.fps))")
                    .padding()
                    .modifier(OptimizedLiquidGlassMaterial(
                        cornerRadius: 12,
                        intensity: 0.8,
                        tintColor: .blue,
                        hasShimmer: false, // ✅ Disable when not needed
                        hasGlow: false
                    ))
                
                Spacer()
            }
        }
        .onAppear {
            perfMonitor.startMonitoring()
        }
        .onDisappear {
            perfMonitor.stopMonitoring()
        }
    }
}


