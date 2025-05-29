//
//  SeasonDTO.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//



// MARK: - Season
struct SeasonDTO: Codable {
    var season: String
    
    enum CodingKeys: String, CodingKey {
        case season = "strSeason"
    }
    func toDomain() -> Season {
        Season(season: season)
    }
}
