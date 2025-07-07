//
//  GetEventsOfTeamByScheduleAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 4/6/25.
//

struct GetEventsOfTeamByNextAPIResponse: Codable {
    var events: [EventDTO]?
    
    enum CodingKeys: String, CodingKey {
        case events = "events"
    }
}

struct GetEventsOfTeamByPreviousAPIResponse: Codable {
    var events: [EventDTO]?
    
    enum CodingKeys: String, CodingKey {
        case events = "results"
    }
}
