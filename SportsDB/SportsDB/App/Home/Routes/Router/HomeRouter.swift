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
    case TeamDetail(by: String)
}

// MARK: - Specific Routers
class SportRouter: BaseRouter<SportRoute> {
    func navigateToListLeague(by countryName: String, and sportName: String) {
        push(.ListLeague(by: countryName, and: sportName))
    }
    
    func navigateToLeagueDetail(by leagueID: String) {
        push(.LeagueDetail(by: leagueID))
    }
    
    func navigateToTeamDetail(by teamID: String) {
        push(.TeamDetail(by: teamID))
    }
    
    func navigateToReplaceTeamDetail(by teamID: String) {
        replace(with: .TeamDetail(by: teamID))
    }
}
