//
//  Venue.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

struct Venue: Equatable {
    var idVenue: String
    var idDupe: String?
    var venue, venueAlternate, venueSponsor, sport: String?
    var descriptionEN, architect, capacity, cost: String?
    var country, location, timezone, formedYear: String?
    var fanart1, fanart2, fanart3, fanart4: String?
    
    var thumb: String?
    var logo: String?
    var map, website, facebook, instagram: String?
    var twitter, youtube, locked: String?
    var creativeCommons: String?
}
