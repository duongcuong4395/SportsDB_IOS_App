//
//  SportsDBApp.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import SwiftUI

@main
struct SportsDBApp: App {
    @StateObject var notificationListVM = NotificationListViewModel()
    //private let container = SwiftDataContainer.shared
    
    init() {
        // Notification
        let center = UNUserNotificationCenter.current()
        center.delegate = NotificationDelegate.shared
    }
    
    var body: some Scene {
        WindowGroup {
            SportDBView()
                .onAppear{
                    Task {
                        await notificationListVM.loadNotifications()
                    }
                }
        }
        .modelContainer(MainDB.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(notificationListVM)
        
        
        //.modelContainer(container.container)
    }
}

//
  //



    // ContentView()
    // DemoResizableHeaderScrollView()
    // AutoScrollingTabView()
    // DemoStickyHeader()
    
    // LiquidGlassExamples()
    // LiquidGlassDemoApp()
    
    
    //DemoFlexibleMorphingButtonView()
    // DemoMorphingView()
    
