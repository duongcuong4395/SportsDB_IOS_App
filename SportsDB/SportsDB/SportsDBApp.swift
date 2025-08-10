//
//  SportsDBApp.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import SwiftUI

@main
struct SportsDBApp: App {
    private let container = SwiftDataContainer.shared
    
    var body: some Scene {
        WindowGroup {
            SportDBView()
        }
        //.modelContainer(MainDB.shared)
        .modelContainer(container.container)
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
    
