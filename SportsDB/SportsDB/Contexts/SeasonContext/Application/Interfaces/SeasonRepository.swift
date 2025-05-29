//
//  SeasonRepository.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

protocol SeasonRepository {
    func getListSeasons(leagueID: String) async throws -> [Season]
}
