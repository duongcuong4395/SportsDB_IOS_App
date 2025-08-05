//
//  AutoScrollingTabIndicators.swift
//  SportsDB
//
//  Created by Macbook on 2/8/25.
//

import SwiftUI

struct AutoScrollingTabView: View {
    @State private var selectedTab = 0
    @State private var timer: Timer?
    @State private var dragOffset: CGFloat = 0
    
    // Tắt auto scroll - đặt thành false để tắt
    let autoScrollEnabled: Bool = false
    let autoScrollInterval: TimeInterval = 3.0
    
    let tabs = LeagueDetailRouteMenu.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Bar với Scrolling Indicators
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<tabs.count, id: \.self) { index in
                            MenuTabIndicatorView(
                                menu: tabs[index],
                                isSelected: selectedTab == index
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedTab = index
                                }
                                
                                if autoScrollEnabled {
                                    stopAutoScroll()
                                    startAutoScroll()
                                }
                            }
                            .id(index)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .onChange(of: selectedTab) { newValue in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [Color.black.opacity(0.1), Color.clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Content Area
            TabView(selection: $selectedTab) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    MenuTabContentView(menu: tabs[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            //.animation(.easeInOut(duration: 0.4), value: selectedTab)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                        if autoScrollEnabled {
                            stopAutoScroll()
                        }
                    }
                    .onEnded { value in
                        dragOffset = 0
                        if autoScrollEnabled {
                            startAutoScroll()
                        }
                    }
            )
        }
        .onAppear {
            if autoScrollEnabled {
                startAutoScroll()
            }
        }
        .onDisappear {
            if autoScrollEnabled {
                stopAutoScroll()
            }
        }
    }
    
    private func startAutoScroll() {
       guard autoScrollEnabled else { return }
       timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
           // Không đặt animation ở đây, để TabView tự xử lý
           selectedTab = (selectedTab + 1) % tabs.count
       }
   }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}

struct MenuTabIndicatorView: View {
    var menu: any RouteMenu
    let isSelected: Bool
    
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon với animation
            Image(systemName: menu.icon)
                .font(.system(size: isSelected ? 24 : 20, weight: .semibold))
                .foregroundColor(isSelected ? menu.color : .gray)
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
            
            // Title
            Text(menu.title)
                .font(.system(size: isSelected ? 14 : 12, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? menu.color : .gray)
                .animation(.easeInOut(duration: 0.3), value: isSelected)
            
            // Animated Indicator Line
            Rectangle()
                .fill(menu.color)
                .frame(width: isSelected ? 40 : 0, height: 3)
                .cornerRadius(1.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isSelected)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        
    }
}

struct MenuTabContentView: View {
    let menu: LeagueDetailRouteMenu
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [
                        menu.color.opacity(0.3),
                        menu.color.opacity(0.1),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Large Icon
                    ZStack {
                        Circle()
                            .fill(menu.color.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: menu.icon)
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(menu.color)
                    }
                    
                    // Content based on menu type
                    VStack(spacing: 16) {
                        Text(menu.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(menu.color)
                        
                        Text(getContentText(for: menu))
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                }
                .padding(.top, 50)
            }
        }
    }
    
    private func getContentText(for menu: LeagueDetailRouteMenu) -> String {
        switch menu {
        case .General:
            return "Thông tin chung về giải đấu, bao gồm thống kê tổng quan và các thông tin cơ bản."
        case .Teams:
            return "Danh sách các đội tham gia giải đấu, thông tin về từng đội và thành tích."
        case .Events:
            return "Lịch thi đấu, kết quả các trận đấu và các sự kiện quan trọng của giải đấu."
        }
    }
}

// Preview
struct DemoContentView: View {
    var body: some View {
        AutoScrollingTabView()
            .preferredColorScheme(.light)
    }
}
