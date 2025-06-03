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
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func replace(with route: Route) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
}
