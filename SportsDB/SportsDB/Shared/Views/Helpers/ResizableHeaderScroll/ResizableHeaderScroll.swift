//
//  ResizableHeaderScroll.swift
//  SportsDB
//
//  Created by Macbook on 2/8/25.
//

import SwiftUI

import SwiftUI

// MARK: - Universal ResizableHeaderScrollView
struct ResizableHeaderScrollView<Header: View, Content: View>: View {
    var minimumHeight: CGFloat
    var maximumHeight: CGFloat
    var ignoresSafeAreaTop: Bool = false
    var isSticky: Bool = false
    
    @ViewBuilder var header: (CGFloat, EdgeInsets) -> Header
    @ViewBuilder var content: Content
    
    @State private var scrollOffset: CGFloat = 0
    @State private var safeAreaInsets: EdgeInsets = .init()
    
    var body: some View {
        GeometryReader { geometry in
            let safeArea = ignoresSafeAreaTop ? geometry.safeAreaInsets : .init()
            
            ZStack(alignment: .top) {
                // Custom ScrollView that tracks offset
                ScrollViewWithOffset(
                    axes: .vertical,
                    showsIndicators: true,
                    onOffsetChange: { offset in
                        scrollOffset = offset
                    }
                ) {
                    VStack(spacing: 0) {
                        // Spacer for header area
                        Color.clear
                            .frame(height: maximumHeight + (ignoresSafeAreaTop ? safeArea.top : 0))
                        
                        // Content
                        content
                    }
                }
                
                // Header overlay
                VStack(spacing: 0) {
                    let progress = calculateProgress(offset: scrollOffset, safeArea: safeArea)
                    let headerHeight = calculateHeaderHeight(progress: progress, safeArea: safeArea)
                    let stickyOffset = calculateStickyOffset(offset: scrollOffset, safeArea: safeArea)
                    
                    header(progress, safeArea)
                        .frame(height: headerHeight, alignment: .bottom)
                        .offset(y: stickyOffset)
                        .animation(.easeInOut(duration: 0.1), value: isSticky)
                    
                    Spacer()
                }
            }
            .onAppear {
                safeAreaInsets = safeArea
            }
            .ignoresSafeArea(.container, edges: ignoresSafeAreaTop ? [.top] : [])
        }
    }
    
    private func calculateProgress(offset: CGFloat, safeArea: EdgeInsets) -> CGFloat {
        let adjustedOffset = offset + (ignoresSafeAreaTop ? safeArea.top : 0)
        return min(max(adjustedOffset / (maximumHeight - minimumHeight), 0), 1)
    }
    
    private func calculateHeaderHeight(progress: CGFloat, safeArea: EdgeInsets) -> CGFloat {
        let baseHeight = maximumHeight - (maximumHeight - minimumHeight) * progress
        return baseHeight + (ignoresSafeAreaTop ? safeArea.top : 0)
    }
    
    private func calculateStickyOffset(offset: CGFloat, safeArea: EdgeInsets) -> CGFloat {
        if !isSticky { return 0 }
        
        let maxShrinkage = maximumHeight - minimumHeight
        let adjustedOffset = offset + (ignoresSafeAreaTop ? safeArea.top : 0)
        
        if adjustedOffset > maxShrinkage {
            return adjustedOffset - maxShrinkage
        }
        return 0
    }
}

// MARK: - Custom ScrollView with Offset Tracking
struct ScrollViewWithOffset<Content: View>: UIViewRepresentable {
    let axes: Axis.Set
    let showsIndicators: Bool
    let onOffsetChange: (CGFloat) -> Void
    let content: Content
    
    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        onOffsetChange: @escaping (CGFloat) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.onOffsetChange = onOffsetChange
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.showsVerticalScrollIndicator = showsIndicators && axes.contains(.vertical)
        scrollView.showsHorizontalScrollIndicator = showsIndicators && axes.contains(.horizontal)
        scrollView.alwaysBounceVertical = axes.contains(.vertical)
        scrollView.alwaysBounceHorizontal = axes.contains(.horizontal)
        
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = UIColor.clear
        
        scrollView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        return scrollView
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        // Update content if needed
        if let hostingController = scrollView.subviews.first?.next as? UIHostingController<Content> {
            hostingController.rootView = content
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onOffsetChange: onOffsetChange)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let onOffsetChange: (CGFloat) -> Void
        
        init(onOffsetChange: @escaping (CGFloat) -> Void) {
            self.onOffsetChange = onOffsetChange
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            onOffsetChange(scrollView.contentOffset.y)
        }
    }
}

// MARK: - Demo Views
struct DemoResizableHeaderScrollView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Universal Example") {
                    UniversalExampleView()
                }
                NavigationLink("Ignore Safe Area Example") {
                    IgnoreSafeAreaExampleView()
                }
                NavigationLink("Complex Header Example") {
                    ComplexHeaderExampleView()
                }
            }
            .navigationTitle("Resizable Header Demo")
        }
    }
}

struct UniversalExampleView: View {
    @State private var isSticky: Bool = false
    
    var body: some View {
        ResizableHeaderScrollView(
            minimumHeight: 80,
            maximumHeight: 200,
            ignoresSafeAreaTop: false,
            isSticky: isSticky
        ) { progress, safeArea in
            LinearGradient(
                colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                VStack(spacing: 8) {
                    Text("Universal Header")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Text("Progress: \(String(format: "%.2f", progress))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Height: \(String(format: "%.0f", 200 - (200-80) * progress))pt")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 16)
            .padding(.top, 8)
        } content: {
            VStack(spacing: 16) {
                // Controls
                VStack(spacing: 12) {
                    Toggle("Sticky Header", isOn: $isSticky)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack {
                        Text("Scroll to see header resize")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Content
                DummyContent()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IgnoreSafeAreaExampleView: View {
    @State private var isSticky: Bool = true
    
    var body: some View {
        ResizableHeaderScrollView(
            minimumHeight: 60,
            maximumHeight: 250,
            ignoresSafeAreaTop: true,
            isSticky: isSticky
        ) { progress, safeArea in
            ZStack {
                LinearGradient(
                    colors: [.orange, .red],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Full Screen Header")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                            Text("Ignores safe area")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(String(format: "%.0f", progress * 100))%")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            Text("shrunk")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
            }
        } content: {
            VStack(spacing: 20) {
                Toggle("Sticky Header", isOn: $isSticky)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                
                DummyContent()
            }
        }
        .navigationBarHidden(true)
    }
}

struct ComplexHeaderExampleView: View {
    @State private var isSticky: Bool = false
    @State private var selectedTab = 0
    
    var body: some View {
        ResizableHeaderScrollView(
            minimumHeight: 120,
            maximumHeight: 280,
            ignoresSafeAreaTop: false,
            isSticky: isSticky
        ) { progress, safeArea in
            VStack(spacing: 0) {
                // Top section
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Complex Header")
                            .font(.title.bold())
                            .foregroundColor(.primary)
                        
                        Text("Multiple elements resize")
                            //.font(.subheadline)
                            //.foregroundColor(.secondary)
                            //.opacity(1 - progress * 0.7)
                    }
                    
                    Spacer()
                    
                    // Profile image that shrinks
                    Circle()
                        .fill(LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(
                            width: 60 - progress * 20,
                            height: 60 - progress * 20
                        )
                        .overlay(
                            Text("👤")
                                .font(.system(size: 24 - progress * 8))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Bottom tabs (always visible)
                HStack(spacing: 0) {
                    ForEach(["Home", "Profile", "Settings"], id: \.self) { tab in
                        Button(action: {
                            selectedTab = ["Home", "Profile", "Settings"].firstIndex(of: tab) ?? 0
                        }) {
                            Text(tab)
                                .font(.subheadline.weight(.medium))
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(selectedTab == ["Home", "Profile", "Settings"].firstIndex(of: tab) ? .blue : .secondary)
                        }
                    }
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 16)
            .padding(.top, 8)
        } content: {
            VStack(spacing: 16) {
                Toggle("Sticky Header", isOn: $isSticky)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                
                DummyContent()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Helper Views
struct DummyContent: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            ForEach(1...50, id: \.self) { index in
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.gray.opacity(0.2), .gray.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120 + CGFloat(index % 3) * 20)
                    .overlay(
                        VStack {
                            Text("Item")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.secondary)
                            Text("\(index)")
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                        }
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 100) // Extra space at bottom
    }
}
