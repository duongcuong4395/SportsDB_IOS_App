//
//  LookupEventTimelineAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

struct LookupEventTimelineAPIResponse: Codable {
    var timelines: [EventTimelineDTO]?
    
    enum CodingKeys: String, CodingKey {
        case timelines = "timeline"
    }
}
