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
    
    
    // Convenience methods để check current route
    var isAtListCountry: Bool {
        return isCurrentRoute(.ListCountry)
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
