//
//  EventVenueDTO.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//



// MARK: - Venue
struct VenueDTO: Codable {
    var idVenue: String
    var idDupe: String?
    var venue, venueAlternate, venueSponsor, sport: String
    var descriptionEN, architect, capacity, cost: String
    var country, location, timezone, formedYear: String
    var fanart1, fanart2, fanart3, fanart4: String
    var thumb: String?
    var logo: String?
    var map, website, facebook, instagram: String
    var twitter, youtube, locked: String
    
    enum CodingKeys: String, CodingKey {
        case idVenue
        case idDupe
        case venue = "strVenue", venueAlternate = "strVenueAlternate"
        case venueSponsor = "strVenueSponsor", sport = "strSport"
        case descriptionEN = "strDescriptionEN", architect = "strArchitect"
        case capacity = "intCapacity", cost = "strCost"
        case country = "strCountry", location = "strLocation"
        case timezone = "strTimezone", formedYear = "intFormedYear"
        case fanart1 = "strFanart1", fanart2 = "strFanart2"
        case fanart3 = "strFanart3", fanart4 = "strFanart4"
        case thumb = "strThumb", logo = "strLogo"
        case map = "strMap", website = "strWebsite"
        case facebook = "strFacebook", instagram = "strInstagram"
        case twitter = "strTwitter", youtube = "strYoutube", locked = "strLocked"
    }
    
    func toDomain() -> Venue {
        Venue(idVenue: idVenue, venue: venue, venueAlternate: venueAlternate, venueSponsor: venueSponsor, sport: sport, descriptionEN: descriptionEN, architect: architect, capacity: capacity, cost: cost, country: country, location: location, timezone: timezone, formedYear: formedYear, fanart1: fanart1, fanart2: fanart2, fanart3: fanart3, fanart4: fanart4, thumb: thumb, logo: logo, map: map, website: website, facebook: facebook, instagram: instagram, twitter: twitter, youtube: youtube, locked: locked)
    }
}
