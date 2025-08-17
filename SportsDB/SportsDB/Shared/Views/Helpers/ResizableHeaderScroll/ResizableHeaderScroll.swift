//
//  ResizableHeaderScroll.swift
//  SportsDB
//
//  Created by Macbook on 2/8/25.
//

import SwiftUI

// MARK: Version 1

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


// MARK: Version 2

// MARK: - Enhanced ResizableHeaderScrollView for TabView
struct ResizableHeaderScrollView_New<Header: View, Content: View>: View {
    var minimumHeight: CGFloat
    var maximumHeight: CGFloat
    var ignoresSafeAreaTop: Bool = false
    var isSticky: Bool = false
    
    @ViewBuilder var header: (CGFloat, EdgeInsets) -> Header
    @ViewBuilder var content: Content
    
    @State private var scrollOffset: CGFloat = 0
    @State private var safeAreaInsets: EdgeInsets = .init()
    @State private var contentHeight: CGFloat = 0
    @State private var selectedTab: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            let safeArea = ignoresSafeAreaTop ? geometry.safeAreaInsets : .init()
            
            ZStack(alignment: .top) {
                // Custom ScrollView with dynamic content
                ScrollViewWithOffset_New(
                    axes: .vertical,
                    showsIndicators: true,
                    onOffsetChange: { offset in
                        scrollOffset = offset
                    },
                    onContentSizeChange: { size in
                        contentHeight = size.height
                    }
                ) {
                    VStack(spacing: 0) {
                        // Dynamic spacer for header area
                        Color.clear
                            .frame(height: maximumHeight + (ignoresSafeAreaTop ? safeArea.top : 0))
                        
                        // Content with intrinsic height
                        content
                            .background(
                                GeometryReader { contentGeometry in
                                    Color.clear
                                        .onAppear {
                                            contentHeight = contentGeometry.size.height
                                        }
                                        .onChange(of: contentGeometry.size.height) { newHeight in
                                            contentHeight = newHeight
                                        }
                                }
                            )
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
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSticky)
                    
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
        let range = maximumHeight - minimumHeight
        guard range > 0 else { return 0 }
        return min(max(adjustedOffset / range, 0), 1)
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

// MARK: - Enhanced ScrollView with Content Size Tracking
struct ScrollViewWithOffset_New<Content: View>: UIViewRepresentable {
    let axes: Axis.Set
    let showsIndicators: Bool
    let onOffsetChange: (CGFloat) -> Void
    let onContentSizeChange: ((CGSize) -> Void)?
    let content: Content
    
    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        onOffsetChange: @escaping (CGFloat) -> Void,
        onContentSizeChange: ((CGSize) -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.onOffsetChange = onOffsetChange
        self.onContentSizeChange = onContentSizeChange
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
        context.coordinator.hostingController = hostingController
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Observe content size changes
        scrollView.addObserver(context.coordinator, forKeyPath: "contentSize", options: [.new], context: nil)
        
        return scrollView
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        if let hostingController = context.coordinator.hostingController {
            hostingController.rootView = content
            
            // Force layout update
            DispatchQueue.main.async {
                hostingController.view.setNeedsLayout()
                hostingController.view.layoutIfNeeded()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onOffsetChange: onOffsetChange, onContentSizeChange: onContentSizeChange)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let onOffsetChange: (CGFloat) -> Void
        let onContentSizeChange: ((CGSize) -> Void)?
        weak var hostingController: UIHostingController<Content>?
        
        init(onOffsetChange: @escaping (CGFloat) -> Void, onContentSizeChange: ((CGSize) -> Void)?) {
            self.onOffsetChange = onOffsetChange
            self.onContentSizeChange = onContentSizeChange
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            onOffsetChange(scrollView.contentOffset.y)
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "contentSize", let scrollView = object as? UIScrollView {
                onContentSizeChange?(scrollView.contentSize)
            }
        }
        
        deinit {
            // Clean up observer
            if let hostingController = hostingController {
                hostingController.view.superview?.removeObserver(self, forKeyPath: "contentSize")
            }
        }
    }
}

// MARK: - TabView-specific ResizableHeaderScrollView
struct TabResizableHeaderScrollView<Header: View>: View {
    var minimumHeight: CGFloat
    var maximumHeight: CGFloat
    var ignoresSafeAreaTop: Bool = true
    var isSticky: Bool = false
    @Binding var selectedTab: Int
    var tabs: [TabItem]
    
    @ViewBuilder var header: (CGFloat, EdgeInsets) -> Header
    
    @State private var scrollOffset: CGFloat = 0
    @State private var tabHeights: [CGFloat] = []
    
    @State var toggleColor: Bool = false
    struct TabItem {
        let title: String
        let content: AnyView
        
        init<Content: View>(title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = AnyView(content())
        }
    }
    
    var body: some View {
        ResizableHeaderScrollView_New(
            minimumHeight: minimumHeight,
            maximumHeight: maximumHeight,
            ignoresSafeAreaTop: ignoresSafeAreaTop,
            isSticky: isSticky,
            header: header
        ) {
            VStack(spacing: 0) {
                Button(action: {
                    self.toggleColor.toggle()
                }, label: {
                    Text("change color")
                        .foregroundStyle(toggleColor ? .blue : .black)
                })
                
                // Tab selector - BUG FIX: Remove animation conflicts
                HStack {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            Text(tabs[index].title)
                                .foregroundColor(selectedTab == index ? .primary : .secondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTab == index ? .blue.opacity(0.1) : Color.clear)
                        )
                        // BUG FIX: Move animation to the parent level
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .background(Color(UIColor.systemBackground))
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                
                // Tab content
                TabView(selection: $selectedTab) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        tabs[index].content
                            .tag(index)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            updateTabHeight(for: index, height: geometry.size.height)
                                        }
                                        .onChange(of: geometry.size.height) { newHeight in
                                            updateTabHeight(for: index, height: newHeight)
                                        }
                                }
                            )
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: currentTabHeight)
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
        }
    }
    
    private var currentTabHeight: CGFloat {
        guard selectedTab < tabHeights.count else { return 600 } // Default height
        return tabHeights[selectedTab]
    }
    
    private func updateTabHeight(for index: Int, height: CGFloat) {
        if tabHeights.count <= index {
            tabHeights = Array(repeating: 600, count: tabs.count) // Initialize with default
        }
        // BUG FIX: Ensure we don't set unrealistic heights
        let validHeight = max(height, 100) // Minimum height
        tabHeights[index] = validHeight
    }
}


struct DemoTabResizableHeaderScrollView: View {
    @State var selectedTab: Int = 0
    var body: some View {
        TabResizableHeaderScrollView(
            minimumHeight: 80,
            maximumHeight: 300,
            ignoresSafeAreaTop: true,
            isSticky: false,
            selectedTab: $selectedTab,
            tabs: [
                .init(title: "Short") {
                    VStack {
                        ForEach(0..<5) { i in
                            Text("Short content \(i)")
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                },
                .init(title: "Long") {
                    VStack {
                        ForEach(0..<20) { i in
                            Text("Long content \(i)")
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            ]
        ) { progress, safeArea in
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack {
                    Spacer()
                    Text("Dynamic Header")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .scaleEffect(1 - progress * 0.3)
                    
                    Text("Progress: \(Int(progress * 100))%")
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(1 - progress)
                    
                    Spacer()
                }
            }
        }
    }
}


// MARK: - Improved ScrollView with Content Size Tracking
struct ImprovedScrollViewWithOffset<Content: View>: UIViewRepresentable {
    let axes: Axis.Set
    let showsIndicators: Bool
    let onOffsetChange: (CGFloat) -> Void
    let onContentSizeChange: (CGSize) -> Void
    let onScrollViewSizeChange: (CGSize) -> Void
    let content: Content
    
    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        onOffsetChange: @escaping (CGFloat) -> Void,
        onContentSizeChange: @escaping (CGSize) -> Void,
        onScrollViewSizeChange: @escaping (CGSize) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.onOffsetChange = onOffsetChange
        self.onContentSizeChange = onContentSizeChange
        self.onScrollViewSizeChange = onScrollViewSizeChange
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
        
        // Store hosting controller reference
        context.coordinator.hostingController = hostingController
        
        return scrollView
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        // Update content and force layout if needed
        if let hostingController = context.coordinator.hostingController {
            hostingController.rootView = content
            
            // Force layout update
            DispatchQueue.main.async {
                hostingController.view.setNeedsLayout()
                hostingController.view.layoutIfNeeded()
                
                // Update content size after layout
                let contentSize = hostingController.view.systemLayoutSizeFitting(
                    CGSize(width: scrollView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
                )
                
                if scrollView.contentSize != contentSize {
                    scrollView.contentSize = contentSize
                    context.coordinator.onContentSizeChange(contentSize)
                }
                
                context.coordinator.onScrollViewSizeChange(scrollView.bounds.size)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            onOffsetChange: onOffsetChange,
            onContentSizeChange: onContentSizeChange,
            onScrollViewSizeChange: onScrollViewSizeChange
        )
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let onOffsetChange: (CGFloat) -> Void
        let onContentSizeChange: (CGSize) -> Void
        let onScrollViewSizeChange: (CGSize) -> Void
        var hostingController: UIHostingController<Content>?
        
        init(
            onOffsetChange: @escaping (CGFloat) -> Void,
            onContentSizeChange: @escaping (CGSize) -> Void,
            onScrollViewSizeChange: @escaping (CGSize) -> Void
        ) {
            self.onOffsetChange = onOffsetChange
            self.onContentSizeChange = onContentSizeChange
            self.onScrollViewSizeChange = onScrollViewSizeChange
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            onOffsetChange(scrollView.contentOffset.y)
        }
        
        func scrollViewDidLayoutSubviews(_ scrollView: UIScrollView) {
            onContentSizeChange(scrollView.contentSize)
            onScrollViewSizeChange(scrollView.bounds.size)
        }
    }
}

// MARK: DEMO

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
