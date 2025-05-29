//
//  TeamRepository.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

protocol TeamRepository {
    func getListTeamsAPIResponse(leagueName: String, sportName: String, countryName: String) async throws -> [Team]
    func searchTeams(teamName: String) async throws -> [Team]
    
    //func lookupTeam(teamID: String) async throws -> [Team]
    
    func lookupEquipment(teamID: String) async throws -> [Equipment]
}
