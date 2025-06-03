//
//  GenericNavigationStack.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI
import Combine



// MARK: - Generic Navigation Stack
struct GenericNavigationStack<Route: Hashable, Content: View, Destination: View>: View {
    @ObservedObject var router: BaseRouter<Route>
    let rootContent: () -> Content
    let destination: (Route) -> Destination
    
    init(
        router: BaseRouter<Route>,
        @ViewBuilder rootContent: @escaping () -> Content,
        @ViewBuilder destination: @escaping (Route) -> Destination
    ) {
        self.router = router
        self.rootContent = rootContent
        self.destination = destination
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            rootContent()
                .navigationDestination(for: Route.self) { route in
                    destination(route)
                        .environmentObject(router)
                }
        }
        .environmentObject(router)
    }
}
