//
//  FloatingTabBar.swift
//  SportsDB
//
//  Created by Macbook on 31/7/25.
//

import SwiftUI

// MARK: - Protocol để định nghĩa yêu cầu cho tab items
protocol TabItem: CaseIterable, Hashable, RawRepresentable where RawValue == String {
    func getIcon() -> AnyView
    var displayName: String { get }
    var isHidden: Bool { get }
}

// MARK: - Extension mặc định cho TabItem
extension TabItem {
    var displayName: String {
        return self.rawValue
    }
    
    var isHidden: Bool {
        return false
    }
}


// MARK: - Generic CustomTabBar
struct FloatingTabBar<T: TabItem>: View {
    var activeForeground: Color = .white
    var activeBackground: Color = .blue
    @Binding var activeTab: T
    var touchTabBar: (T) -> Void
    
    @Namespace private var animation
    @State private var tabLocation: CGRect = .zero

    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(T.allCases), id: \.self) { tab in
                        if !tab.isHidden {
                            Button {
                                touchTabBar(tab)
                            } label: {
                                HStack(spacing: 5) {
                                    tab.getIcon()
                                        .font(.title3)
                                        .frame(width: 30, height: 30)
                                    if activeTab == tab {
                                        Text(tab.displayName)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                    }
                                }
                                .foregroundStyle(activeTab == tab ? activeForeground : .black)
                                .padding(.vertical, 2)
                                .padding(.leading, 10)
                                .padding(.trailing, 15)
                                .contentShape(.rect)
                                .background {
                                    if activeTab == tab {
                                        Capsule()
                                            .fill(.clear)
                                            .onGeometryChange(for: CGRect.self, of: {
                                                $0.frame(in: .named("TABBARVIEW"))
                                            }, action: { newVL in
                                                tabLocation = newVL
                                            })
                                            .matchedGeometryEffect(id: "ActiveTab", in: animation)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .background(alignment: .leading) {
                    Capsule()
                        .fill(activeBackground.gradient)
                        .frame(width: tabLocation.width, height: tabLocation.height)
                        .offset(x: tabLocation.minX)
                }
                .coordinateSpace(.named("TABBARVIEW"))
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 45)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
    }
}

