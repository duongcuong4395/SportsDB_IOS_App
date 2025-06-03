//
//  LookupEventResultsAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

// MARK: - EventResultsAPIResponse
struct LookupEventResultsAPIResponse: Codable {
    var results: [EventResultDTO]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}
