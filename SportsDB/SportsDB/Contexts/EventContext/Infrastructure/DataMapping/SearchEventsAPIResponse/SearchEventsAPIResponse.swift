//
//  SearchEventsAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation


struct SearchEventsAPIResponse: Codable {
    var events: [EventDTO]?
    
    enum CodingKeys: String, CodingKey {
        case events = "event"
    }
}

