//
//  AIManageKitDemoApp.swift
//  SportsDB
//
//  Created by Macbook on 15/11/25.
//

// AIManageKitDemoApp.swift

import SwiftUI
import AIManageKit

// MARK: - Root View
struct AIManageKitDemoApp: View {
    @State private var aiManager = AIManager(useKeychain: true)
    //@Environment(AIManager.self) private var aiManager
    
    var body: some View {
        Group {
            if aiManager.keyStatus == .valid {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut, value: aiManager.keyStatus)
        .environment(aiManager)
    }
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @Environment(AIManager.self) private var aiManager
    
    var body: some View {
        NavigationStack {
            AIKeySetupView(aiManager: aiManager)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            
            PlaygroundView()
                .tabItem {
                    Label("Playground", systemImage: "play.circle.fill")
                }
            
            ImageAnalysisView()
                .tabItem {
                    Label("Vision", systemImage: "photo.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
