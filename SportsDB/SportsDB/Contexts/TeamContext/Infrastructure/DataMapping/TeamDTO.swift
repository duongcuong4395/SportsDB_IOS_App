//
//  TeamDTO.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//



// MARK: - Team
struct TeamDTO: Codable {
    
    var idTeam: String? = ""
    var idSoccerXML: String? = ""
    var idAPIfootball: String? = ""
    
    var loved: String? = ""
    var teamName: String = ""
    var teamAlternate: String? = ""
    
    var sportType: SportType? = .AmericanFootball
    var leagueName: String?  = ""
    var leagueAlternate: String? = ""
    var division: String? = ""
    var idCup: String? = ""
    
    var currentSeason: String? = ""
    var formedYear: String? = ""
    var dateFirstEvent: String? = ""
    
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
    
    var colour1: String? = ""
    var colour2: String? = ""
    var colour3: String? = ""
    
    var gender: String? = ""
    var country: String? = ""
    
    var banner: String? = ""
    var badge: String? = ""
    var logo: String? = ""
    
    var fanart1: String? = ""
    var fanart2: String? = ""
    var fanart3: String? = ""
    var fanart4: String? = ""
    
    var equipment: String? = ""
    var locked: String? = ""
    
    var teamShort: String? = ""
    
    var idLeague: String? = ""
    var league2Name: String? = ""
    var idLeague2: String? = ""
    var league3Name: String? = ""
    var idLeague3: String? = ""
    var league4Name: String? = ""
    var idLeague4: String? = ""
    var league5Name:String? = ""
    var idLeague5: String? = ""
    var league6Name: String? = ""
    var idLeague6: String? = ""
    var league7Name: String? = ""
    var idLeague7: String? = ""
    
    var divisionName: String? = ""
    var idVenue: String? = ""
    var stadiumName: String? = ""
    var keywords: String? = ""
    
    var locationName: String? = ""
    var stadiumCapacity: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case idTeam, idSoccerXML
        case idAPIfootball
        
        case loved = "intLoved"
        case teamName = "strTeam"
        case teamAlternate = "strTeamAlternate"
        
        
        case sportType = "strSport"
        case leagueName = "strLeague"
        case leagueAlternate = "strLeagueAlternate"
        case division = "intDivision"
        case idCup
        
        case currentSeason = "strCurrentSeason"
        case formedYear = "intFormedYear"
        case dateFirstEvent
        
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
        
        case colour1 = "strColour1"
        case colour2 = "strColour2"
        case colour3 = "strColour3"
        
        case gender = "strGender"
        case country = "strCountry"
        
        case fanart1 = "strFanart1"
        case fanart2 = "strFanart2"
        case fanart3 = "strFanart3"
        case fanart4 = "strFanart4"
        
        case badge = "strBadge"
        case banner = "strBanner"
        case logo = "strLogo"
        
        case equipment = "strEquipment"
        case locked = "strLocked"
        
        case teamShort = "strTeamShort"
        case idLeague = "idLeague"
        case league2Name = "strLeague2"
        case idLeague2 = "idLeague2"
        case league3Name = "strLeague3"
        case idLeague3 = "idLeague3"
        case league4Name = "strLeague4"
        case idLeague4 = "idLeague4"
        case league5Name = "strLeague5"
        case idLeague5 = "idLeague5"
        case league6Name = "strLeague6"
        case idLeague6 = "idLeague6"
        case league7Name = "strLeague7"
        case idLeague7 = "idLeague7"
        
        case divisionName = "strDivision"
        case idVenue = "idVenue"
        case stadiumName = "strStadium"
        case keywords = "strKeywords"
                    
        case locationName = "strLocation"
        case stadiumCapacity = "intStadiumCapacity"
    }
    
    func toDomain() -> Team {
        Team(
            idTeam:idTeam,
            idSoccerXML: idSoccerXML,
            idAPIfootball: idAPIfootball,
            loved: loved,
            teamName: teamName,
            teamAlternate: teamAlternate,
            sportType: sportType,
            leagueName: leagueName,
            leagueAlternate: leagueAlternate,
            division: division,
            idCup: idCup,
            currentSeason: currentSeason,
            formedYear: formedYear,
            dateFirstEvent: dateFirstEvent,
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
            colour1: colour1,
            colour2: colour2,
            colour3: colour3,
            gender: gender,
            country: country,
            banner: banner,
            badge: badge,
            logo: logo,
            fanart1: fanart1,
            fanart2: fanart2,
            fanart3: fanart3,
            fanart4: fanart4,
            equipment: equipment,
            locked: locked,
            teamShort: teamShort,
            idLeague: idLeague,
            league2Name: league2Name,
            idLeague2: idLeague2,
            league3Name: league3Name,
            idLeague3: idLeague3,
            league4Name: league4Name,
            idLeague4: idLeague4,
            league5Name: league5Name,
            idLeague5: idLeague5,
            league6Name: league6Name,
            idLeague6: idLeague6,
            league7Name: league7Name,
            idLeague7: idLeague7,
            divisionName: divisionName,
            idVenue: idVenue,
            stadiumName: stadiumName,
            keywords: keywords,
            locationName: locationName,
            stadiumCapacity: stadiumCapacity
        )
    }
}
