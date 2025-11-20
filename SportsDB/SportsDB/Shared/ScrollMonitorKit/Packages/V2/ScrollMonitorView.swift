//
//  ScrollMonitorView.swift
//  SportsDB
//
//  Created by Macbook on 19/11/25.
//

import SwiftUI

// MARK: - ScrollMonitorView.swift (FIXED)
public struct ScrollMonitorView<Content: View>: View {
    
    @ObservedObject private var viewModel: ScrollViewModel
    private let content: Content
    private let scrollToBottomAnchor: String
    private let scrollToTopAnchor: String
    private let showButtons: ButtonVisibility
    private let bottomButtonStyle: ScrollButtonStyle
    private let topButtonStyle: ScrollButtonStyle
    private let onScrollToBottom: (() -> Void)?
    private let onScrollToTop: (() -> Void)?
    
    public init(
        viewModel: ScrollViewModel,
        scrollToBottomAnchor: String = "scrollBottom",
        scrollToTopAnchor: String = "scrollTop",
        showButtons: ButtonVisibility = .bottom,
        bottomButtonStyle: ScrollButtonStyle = .defaultBottom,
        topButtonStyle: ScrollButtonStyle = .defaultTop,
        onScrollToBottom: (() -> Void)? = nil,
        onScrollToTop: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content()
        self.scrollToBottomAnchor = scrollToBottomAnchor
        self.scrollToTopAnchor = scrollToTopAnchor
        self.showButtons = showButtons
        self.bottomButtonStyle = bottomButtonStyle
        self.topButtonStyle = topButtonStyle
        self.onScrollToBottom = onScrollToBottom
        self.onScrollToTop = onScrollToTop
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            GeometryReader { _ in
                ZStack(alignment: .center) {
                    ScrollView(viewModel.configuration.axis.swiftUIAxis) {
                        content
                            .background(GeometryReader { contentGeo in
                                Color.clear.preference(
                                    key: ContentHeightKey.self,
                                    value: contentGeo.size.height
                                )
                            })
                    }
                    .background(GeometryReader { scrollGeo in
                        Color.clear.preference(
                            key: ScrollOffsetKey.self,
                            value: scrollGeo.frame(in: .named("scrollSpace")).minY
                        )
                    })
                    .coordinateSpace(name: "scrollSpace")
                    .onPreferenceChange(ContentHeightKey.self) { height in
                        viewModel.updateContentHeight(height)
                    }
                    .onPreferenceChange(ScrollOffsetKey.self) { offset in
                        viewModel.updateOffset(offset)
                    }
                    .background(GeometryReader { containerGeo in
                        Color.clear.preference(
                            key: ContainerHeightKey.self,
                            value: containerGeo.size.height
                        )
                    })
                    .onPreferenceChange(ContainerHeightKey.self) { height in
                        viewModel.updateContainerHeight(height)
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in viewModel.setDragging(true) }
                            .onEnded { _ in viewModel.setDragging(false) }
                    )
                    .refreshable {
                        if viewModel.configuration.enablePullToRefresh {
                            await viewModel.triggerRefresh()
                        }
                    }
                    
                    buttonsOverlay(proxy: proxy)
                }
            }
        }
    }
    
    @ViewBuilder
    private func buttonsOverlay(proxy: ScrollViewProxy) -> some View {
        ZStack {
            if showButtons.showsBottom && viewModel.showScrollToBottomButton {
                ZStack {
                    Color.clear
                    bottomButtonStyle.makeButton {
                        onScrollToBottom?()
                        viewModel.scrollToBottom()
                        withAnimation(.easeInOut(duration: viewModel.configuration.scrollAnimationDuration)) {
                            proxy.scrollTo(scrollToBottomAnchor, anchor: .bottom)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: bottomButtonStyle.position.alignment)
                .offset(x: bottomButtonStyle.offset.x, y: bottomButtonStyle.offset.y)
                .transition(.scale.combined(with: .opacity))
            }
            
            if showButtons.showsTop && viewModel.showScrollToTopButton {
                ZStack {
                    Color.clear
                    topButtonStyle.makeButton {
                        onScrollToTop?()
                        viewModel.scrollToTop()
                        withAnimation(.easeInOut(duration: viewModel.configuration.scrollAnimationDuration)) {
                            proxy.scrollTo(scrollToTopAnchor, anchor: .top)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: topButtonStyle.position.alignment)
                .offset(x: topButtonStyle.offset.x, y: topButtonStyle.offset.y)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    public struct ButtonVisibility {
        let showsBottom: Bool
        let showsTop: Bool
        
        public static var both: ButtonVisibility { .init(showsBottom: true, showsTop: true) }
        public static var bottom: ButtonVisibility { .init(showsBottom: true, showsTop: false) }
        public static var top: ButtonVisibility { .init(showsBottom: false, showsTop: true) }
        public static var none: ButtonVisibility { .init(showsBottom: false, showsTop: false) }
    }
}



// MARK: - Axis Extension
extension ScrollConfiguration.Axis {
    var swiftUIAxis: Axis.Set {
        switch self {
        case .vertical: return .vertical
        case .horizontal: return .horizontal
        case .both: return [.vertical, .horizontal]
        }
    }
}
