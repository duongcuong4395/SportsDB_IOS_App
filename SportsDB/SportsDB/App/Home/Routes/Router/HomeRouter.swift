//
//  HomeRouter.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

enum SportRoute: Hashable {
    case ListCountry
    case ListLeague(by: String, and: String)
    case LeagueDetail(by: String)
    case TeamDetail
    case Notification
    case Like
    case EventDetail
}

extension SportRoute {
    @ViewBuilder
    func destinationView() -> some View {
        VStack {
            switch self {
            case .ListCountry:
                ListCountryRouteView()
            case .ListLeague(by: _, and: _):
                ListLeagueRouteView()
            case .LeagueDetail(by: _):
                LeagueDetailRouteView()
            case .TeamDetail:
                TeamDetailRouteView()
            case .Notification:
                NotificationRouteView()
            case .Like:
                LikeRouteView()
            case .EventDetail:
                EventDetailRouteView()
            }
        }
        .navigationBarHidden(true)
        .backgroundOfPage(by: .Gradient)
    }
}

// MARK: - Specific Routers
class SportRouter: BaseRouter<SportRoute> {
    func navigateToListLeague(by countryName: String, and sportName: String) {
        push(.ListLeague(by: countryName, and: sportName))
    }
    
    func navigateToLeagueDetail(by leagueID: String) {
        push(.LeagueDetail(by: leagueID))
    }
    
    func navigateToTeamDetail() {
        push(.TeamDetail)
    }
    
    func navigateToReplaceTeamDetail() {
        replace(with: .TeamDetail)
    }
    
    func navigateToNotification() {
        navigateToOrPush(.Notification)
        //push(.Notification)
    }
    
    func navigateToLike() {
        navigateToOrPush(.Like)
        //push(.Like)
    }
    
    func navigateToEventDetail() {
        push(.EventDetail)
    }
    
    
    
    // Convenience methods để check current route
    
    var isAtLike: Bool {
        return isCurrentRoute(.Like)
    }
    
    var isAtNotification: Bool {
        return isCurrentRoute(.Notification)
    }
    
    var isAtListCountry: Bool {
        return isCurrentRoute(.ListCountry)
    }
    
    var isAtEventDetail: Bool {
        return isCurrentRoute(.EventDetail)
    }
    
    func isAtListLeague(countryName: String, sportName: String) -> Bool {
        return isCurrentRoute(.ListLeague(by: countryName, and: sportName))
    }
    
    func isAtLeagueDetail(leagueID: String) -> Bool {
        return isCurrentRoute(.LeagueDetail(by: leagueID))
    }
    
    func isAtTeamDetail() -> Bool {
        return isCurrentRoute(.TeamDetail)
    }
}
