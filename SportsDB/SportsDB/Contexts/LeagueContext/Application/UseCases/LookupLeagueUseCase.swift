//
//  LookupLeagueUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import SwiftUI

struct LookupLeagueUseCase {
    let repository: LeagueRepository
    
    func execute(with league_ID: String) async throws -> [League] {
        return try await repository.lookupLeague(by: league_ID)
    }
}
