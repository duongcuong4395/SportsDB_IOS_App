//
//  LeagueDTO.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// Identifiable, Hashable
struct LeagueDTO: Codable {
    var id: String = "" //UUID = UUID()
    var idLeague: String? = ""
    var idSoccerXML: String? = ""
    var idAPIfootball: String? = ""
    
    var sportType: String
    var leagueName: String?  = ""
    var leagueAlternate: String? = ""
    var division: String? = ""
    var idCup: String? = ""
    
    var currentSeason: String? = ""
    var formedYear: String? = ""
    var dateFirstEvent: String? = ""
    var gender: String? = ""
    var country: String? = ""
    var website: String? = ""
    var facebook: String? = ""
    var instagram: String? = ""
    var twitter: String? = ""
    var youtube: String? = ""
    var rss: String? = ""
    
    var descriptionEN: String? = ""
    var descriptionDE: String? = ""
    var descriptionFR: String? = ""
    var descriptionIT: String? = ""
    
    var descriptionCN: String? = ""
    var descriptionJP: String? = ""
    var descriptionRU: String? = ""
    var descriptionES: String? = ""
    
    var descriptionPT: String? = ""
    var descriptionSE: String? = ""
    var descriptionNL: String? = ""
    var descriptionHU: String? = ""
    
    var descriptionNO: String? = ""
    var descriptionPL: String? = ""
    var descriptionIL: String? = ""
    var tvRights: String? = ""
    
    var fanart1: String? = ""
    var fanart2: String? = ""
    var fanart3: String? = ""
    var fanart4: String? = ""
    
    var banner: String? = ""
    var badge: String? = ""
    var logo: String? = ""
    var poster: String? = ""
    var trophy: String? = ""
    var naming: String? = ""
    var complete: String? = ""
    var locked: String? = ""
    
    
    
    enum CodingKeys: String, CodingKey {
        case idLeague, idSoccerXML
        case idAPIfootball
        
        case sportType = "strSport"
        case leagueName = "strLeague"
        case leagueAlternate = "strLeagueAlternate"
        case division = "intDivision"
        case idCup
        
        case currentSeason = "strCurrentSeason"
        case formedYear = "intFormedYear"
        case dateFirstEvent
        case gender = "strGender"
        case country = "strCountry"
        case website = "strWebsite"
        case facebook = "strFacebook"
        case instagram = "strInstagram"
        case twitter = "strTwitter"
        case youtube = "strYoutube"
        case rss = "strRSS"
        
        case descriptionEN = "strDescriptionEN"
        case descriptionDE = "strDescriptionDE"
        case descriptionFR = "strDescriptionFR"
        case descriptionIT = "strDescriptionIT"
        
        case descriptionCN = "strDescriptionCN"
        case descriptionJP = "strDescriptionJP"
        case descriptionRU = "strDescriptionRU"
        case descriptionES = "strDescriptionES"
        
        case descriptionPT = "strDescriptionPT"
        case descriptionSE = "strDescriptionSE"
        case descriptionNL = "strDescriptionNL"
        case descriptionHU = "strDescriptionHU"
        
        case descriptionNO = "strDescriptionNO"
        case descriptionPL = "strDescriptionPL"
        case descriptionIL = "strDescriptionIL"
        case tvRights = "strTvRights"
        
        case fanart1 = "strFanart1"
        case fanart2 = "strFanart2"
        case fanart3 = "strFanart3"
        case fanart4 = "strFanart4"
        
        case banner = "strBanner"
        case badge = "strBadge"
        case logo = "strLogo"
        case poster = "strPoster"
        case trophy = "strTrophy"
        case naming = "strNaming"
        case complete = "strComplete"
        case locked = "strLocked"
    }
    
    
    func toDomain() -> League {
        League(
             id:id,
            idLeague: idLeague,
            idSoccerXML: idSoccerXML,
            idAPIfootball: idAPIfootball,

            sportType: sportType,
            leagueName: leagueName,
            leagueAlternate: leagueAlternate,
            division: division,
            idCup: idCup,

            currentSeason: currentSeason,
            formedYear: formedYear,
            dateFirstEvent: dateFirstEvent,
            gender: gender,
            country: country,
            website: website,
            facebook: facebook,
            instagram: instagram,
            twitter: twitter,
            youtube: youtube,
            rss: rss,

            descriptionEN: descriptionEN,
            descriptionDE: descriptionDE,
            descriptionFR: descriptionFR,
            descriptionIT: descriptionIT,

            descriptionCN: descriptionCN,
            descriptionJP: descriptionJP,
            descriptionRU: descriptionRU,
            descriptionES: descriptionES,

            descriptionPT: descriptionPT,
            descriptionSE: descriptionSE,
            descriptionNL: descriptionNL,
            descriptionHU: descriptionHU,

            descriptionNO: descriptionNO,
            descriptionPL: descriptionPL,
            descriptionIL: descriptionIL,
            tvRights: tvRights,

            fanart1: fanart1,
            fanart2: fanart2,
            fanart3: fanart3,
            fanart4: fanart4,

            banner: banner,
            badge: badge,
            logo: logo,
            poster: poster,
            trophy: trophy,
            naming: naming,
            complete: complete,
            locked: locked
        )
    }
}


