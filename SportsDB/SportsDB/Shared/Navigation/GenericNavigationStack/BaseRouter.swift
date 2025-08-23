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
    
    // MARK: - Enhanced Navigation Methods
        
    /// Navigate to an existing route in stack or push if it doesn't exist
    /// - Parameter route: The route to navigate to
    /// - Returns: Bool indicating if route was found in stack (true) or pushed (false)
    @discardableResult
    func navigateToOrPush(_ route: Route) -> Bool {
        if let existingIndex = routeStack.firstIndex(of: route) {
            // Route exists in stack, navigate to it
            navigateToExisting(at: existingIndex)
            return true
        } else {
            // Route doesn't exist, push it
            push(route)
            return false
        }
    }
    
    /// Navigate to a route at specific index in the route stack
    /// - Parameter index: The index of the route in routeStack
    private func navigateToExisting(at index: Int) {
        guard index < routeStack.count else { return }
        
        // Calculate how many routes to pop
        let routesToPop = routeStack.count - index - 1
        
        if routesToPop > 0 {
            // Pop from path
            path.removeLast(routesToPop)
            // Update routeStack
            routeStack.removeLast(routesToPop)
        }
    }
    
    /// Check if a route exists in the current route stack
    /// - Parameter route: The route to check
    /// - Returns: Bool indicating if route exists
    func containsRoute(_ route: Route) -> Bool {
        return routeStack.contains(route)
    }
    
    /// Get the index of a route in the route stack
    /// - Parameter route: The route to find
    /// - Returns: Optional index of the route
    func indexOfRoute(_ route: Route) -> Int? {
        return routeStack.firstIndex(of: route)
    }
    
    /// Navigate to a specific route if it exists in the stack
    /// - Parameter route: The route to navigate to
    /// - Returns: Bool indicating success
    @discardableResult
    func navigateToExistingRoute(_ route: Route) -> Bool {
        if let index = routeStack.firstIndex(of: route) {
            navigateToExisting(at: index)
            return true
        }
        return false
    }
    
    /// Pop to a specific route if it exists in the stack
    /// - Parameter route: The route to pop to
    /// - Returns: Bool indicating success
    @discardableResult
    func popTo(_ route: Route) -> Bool {
        return navigateToExistingRoute(route)
    }
    
    /// Push route only if it doesn't already exist in the stack
    /// - Parameter route: The route to push
    /// - Returns: Bool indicating if route was pushed (true) or already existed (false)
    @discardableResult
    func pushIfNotExists(_ route: Route) -> Bool {
        if !containsRoute(route) {
            push(route)
            return true
        }
        return false
    }
    
    /// Get routes from current position to root
    var routesToRoot: [Route] {
        return Array(routeStack.reversed())
    }
    
    /// Get routes from root to current position
    var routesFromRoot: [Route] {
        return routeStack
    }
}
