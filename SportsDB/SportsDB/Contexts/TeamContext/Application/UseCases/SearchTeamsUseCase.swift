//
//  SearchTeamsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct SearchTeamsUseCase {
    let repository: TeamRepository
    
    func execute(teamName: String) async throws -> [Team] {
        try await repository.searchTeams(teamName: teamName)
    }
}
