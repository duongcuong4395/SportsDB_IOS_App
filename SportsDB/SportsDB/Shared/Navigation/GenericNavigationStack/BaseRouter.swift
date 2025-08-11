//
//  BaseRouter.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI


// MARK: - Base Implementation
class BaseRouter<Route: Hashable>: Router, ObservableObject {
    @Published var path = NavigationPath()
    
    
    // Maintain một array riêng để track routes
    @Published private var routeStack: [Route] = []
    
    // Current route là route cuối cùng trong stack
    var currentRoute: Route? {
        return routeStack.last
    }
    
    // Computed property để lấy tên route hiện tại
    var currentRouteName: String {
        if let current = currentRoute {
            return String(describing: current)
        }
        return "Root"
    }
    
    // Method để check xem có đang ở route cụ thể không
       func isCurrentRoute(_ route: Route) -> Bool {
           return currentRoute == route
       }
       
       // Method để lấy route history
       var routeHistory: [Route] {
           return routeStack
       }
       
       // Method để lấy depth của navigation stack
       var navigationDepth: Int {
           return routeStack.count
       }
       
       // Method để check xem có thể pop không
       var canPop: Bool {
           return !routeStack.isEmpty
       }
    
    
    func push(_ route: Route) {
        path.append(route)
        routeStack.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
            if !routeStack.isEmpty {
                routeStack.removeLast()
            }
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
        routeStack.removeAll()
    }
    
    func replace(with route: Route) {
        if !path.isEmpty {
            path.removeLast()
            if !routeStack.isEmpty {
                routeStack.removeLast()
            }
        }
        path.append(route)
        routeStack.append(route)
    }
    
    func replaceNew(with route: Route) {
        print("=== count path", path.count)
        path.append(route)
        //print("=== count path", path.removeLast(path.count - 1))
        
        
    }
}
