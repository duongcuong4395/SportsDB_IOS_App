//
//  TeamAPIService.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

final class TeamAPIService: APIExecution, TeamRepository {
    
    
    
    
    func searchTeams(teamName: String) async throws -> [Team] {
        let response: SearchTeamsAPIResponse = try await sendRequest(for: TeamEndpoint<SearchTeamsAPIResponse>.SearchTeams(teamName: teamName))
        guard let teams = response.teams else {
            return []
        }
        
        return teams.map { $0.toDomain() }
    }
    
    func getListTeamsAPIResponse(leagueName: String, sportName: String, countryName: String) async throws -> [Team] {
        let response: GetListTeamsAPIResponse = try await sendRequest(for: TeamEndpoint<GetListTeamsAPIResponse>.GetListTeams(leagueName: leagueName, sportName: sportName, countryName: countryName))
        
        guard let teams = response.teams else {
            return []
        }
        
        return teams.map { $0.toDomain() }
    }
    
    func lookupEquipment(teamID: String) async throws -> [Equipment] {
        let response: LookupEquipmentAPIResponse = try await sendRequest(for: TeamEndpoint<LookupEquipmentAPIResponse>.LookupEquipment(teamID: teamID))
        guard let equipments = response.equipments else {
            return []
        }
        
        return equipments.map { $0.toDomain() }
    }
}
