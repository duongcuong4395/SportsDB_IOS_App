//
//  SeasonAPIService.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

class SeasonAPIService: APIExecution, SeasonRepository {
    func getListSeasons(leagueID: String) async throws -> [Season] {
        let respone: GetListSeasonsAPIResponse = try await sendRequest(for: SeasonEndpoint<GetListSeasonsAPIResponse>.GetListSeasons(leagueID: leagueID))
        
        return respone.seasons.map { $0.toDomain() }
    }
    
    
}
