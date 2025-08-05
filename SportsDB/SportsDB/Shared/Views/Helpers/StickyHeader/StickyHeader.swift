//
//  StickyHeader.swift
//  SportsDB
//
//  Created by Macbook on 4/8/25.
//

import SwiftUI

struct DemoStickyHeader: View {
    var body: some View {
        ExpandedStickyHeaderView()
    }
}

import SwiftUI

struct ExpandedStickyHeaderView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var previousOffset: CGFloat = 0
    @State private var scrollVelocity: CGFloat = 0
    @State private var headerHeight: CGFloat = HEADER_HEIGHT
    @State private var isHeaderVisible: Bool = true

    var body: some View {
        TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollOffset) {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    HeaderView(offset: scrollOffset)
                        .opacity(isHeaderVisible ? 1 : 0)
                        .frame(height: headerHeight)
                        .background(Color.blue)
                        .clipped()

                    ForEach(1...30, id: \.self) { index in
                        Text("Row \(index)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .onChange(of: scrollOffset) { newValue in
            let delta = newValue - previousOffset
            scrollVelocity = delta / 0.016
            previousOffset = newValue

            // Collapse/Expand Header
            withAnimation(.easeOut(duration: 0.25)) {
                if scrollVelocity < -20 {
                    // Kéo lên: hiện header
                    isHeaderVisible = true
                    headerHeight = min(HEADER_HEIGHT, headerHeight + abs(delta))
                } else if scrollVelocity > 20 {
                    // Kéo xuống: ẩn header
                    isHeaderVisible = false
                    headerHeight = max(HEADER_MIN_HEIGHT, headerHeight - abs(delta))
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - Constants
private let HEADER_HEIGHT: CGFloat = 300
private let HEADER_MIN_HEIGHT: CGFloat = 100

// MARK: - Header View with Blur & Parallax
struct HeaderView: View {
    var offset: CGFloat

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geo in
                let parallaxOffset = -offset > 0 ? -offset / 2 : 0
                Image("headerImage") // Replace with your image asset
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height + (offset > 0 ? offset : 0))
                    .clipped()
                    .offset(y: parallaxOffset)
            }

            VStack(alignment: .leading) {
                Text("Advanced Sticky Header")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }
            .padding()
        }
        .background(.ultraThinMaterial)
        .overlay(
            // Blur overlay when scrolling down
            Color.black
                //.opacity(min(max(offset / 300, 0), 0.4))
        )
    }
}


struct TrackableScrollView<Content: View>: View {
    let axes: Axis.Set
    let showIndicators: Bool
    let content: Content
    @Binding var contentOffset: CGFloat

    init(_ axes: Axis.Set = .vertical,
         showIndicators: Bool = true,
         contentOffset: Binding<CGFloat>,
         @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        self._contentOffset = contentOffset
        self.content = content()
    }

    var body: some View {
        ScrollView(axes, showsIndicators: showIndicators) {
            GeometryReader { geo in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self,
                                value: geo.frame(in: .named("scroll")).minY)
            }
            .frame(height: 0)
            content
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            contentOffset = value
        }
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
