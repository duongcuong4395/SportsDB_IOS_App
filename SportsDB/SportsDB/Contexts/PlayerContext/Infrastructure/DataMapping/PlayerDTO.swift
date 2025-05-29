//
//  PlayerDTO.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//




// MARK: - Player
struct PlayerDTO: Codable {
    var idPlayer, idTeam: String?
    var idTeam2, idTeamNational: String?
    var idAPIfootball, idPlayerManager, idWikidata, idTransferMkt: String?
    var idESPN, nationality, player, playerAlternate: String?
    var team, team2, sport, soccerXMLTeamID: String?
    var dateBorn: String?
    var dateDied: String?
    var number, dateSigned, signing, wage: String?
    var outfitter, kit, agent, birthLocation: String?
    var ethnicity, status: String?
    
    var descriptionEN: String?
    var descriptionDE, descriptionFR, descriptionCN, descriptionIT: String?
    var descriptionJP, descriptionRU, descriptionES, descriptionPT: String?
    var descriptionSE, descriptionNL, descriptionHU, descriptionNO: String?
    var descriptionIL, descriptionPL: String?
    var gender, side, position: String?
    var college: String?
    var facebook, website, twitter, instagram: String?
    var youtube, height, weight, intLoved: String?
    var thumb: String?
    var poster: String?
    var cutout, render: String?
    var banner: String?
    var fanart1, fanart2, fanart3, fanart4: String?
    var creativeCommons, locked: String?
    
    var relevance: String?
    
    
    enum CodingKeys: String, CodingKey {
        case idPlayer, idTeam
        case idTeam2, idTeamNational
        case idAPIfootball, idPlayerManager, idWikidata, idTransferMkt
        case idESPN, nationality = "strNationality", player = "strPlayer", playerAlternate = "strPlayerAlternate"
        case team = "strTeam", team2 = "strTeam2", sport = "strSport", soccerXMLTeamID = "intSoccerXMLTeamID"
        case dateBorn
        case dateDied
        case number = "strNumber", dateSigned, signing = "strSigning", wage = "strWage"
        case outfitter = "strOutfitter", kit = "strKit", agent = "strAgent", birthLocation = "strBirthLocation"
        case ethnicity = "strEthnicity", status = "strStatus"
        
        case descriptionEN = "strDescriptionEN"
        case descriptionDE = "strDescriptionDE", descriptionFR = "strDescriptionFR", descriptionCN = "strDescriptionCN", descriptionIT = "strDescriptionIT"
        case descriptionJP = "strDescriptionJP", descriptionRU = "strDescriptionRU", descriptionES = "strDescriptionES", descriptionPT = "strDescriptionPT"
        case descriptionSE = "strDescriptionSE", descriptionNL = "strDescriptionNL", descriptionHU = "strDescriptionHU", descriptionNO = "strDescriptionNO"
        case descriptionIL = "strDescriptionIL", descriptionPL = "strDescriptionPL"
        case gender = "strGender", side = "strSide", position = "strPosition"
        case college = "strCollege"
        case facebook = "strFacebook", website = "strWebsite", twitter = "strTwitter", instagram = "strInstagram"
        case youtube = "strYoutube", height = "strHeight", weight = "strWeight", intLoved = "intLoved"
        case thumb = "strThumb"
        case poster = "strPoster"
        case cutout = "strCutout", render = "strRender"
        case banner = "strBanner"
        case fanart1 = "strFanart1", fanart2 = "strFanart2", fanart3 = "strFanart3", fanart4 = "strFanart4"
        case creativeCommons = "strCreativeCommons", locked = "strLocked"
        case relevance
    }
    
    func toDomain() -> Player {
        Player(idPlayer: idPlayer,
                  idTeam: idTeam,
                  idTeam2: idTeam2,
                  idTeamNational: idTeamNational,
                  idAPIfootball: idAPIfootball, idPlayerManager: idPlayerManager, idWikidata: idWikidata, idTransferMkt: idTransferMkt,
                  idESPN: idESPN, nationality: nationality, player: player, playerAlternate: playerAlternate,
                  team: team, team2: team2, sport: sport, soccerXMLTeamID: soccerXMLTeamID,
                  dateBorn: dateBorn,
                  dateDied: dateDied,
                  number: number, dateSigned: dateSigned, signing: signing, wage: wage,
                  outfitter: outfitter, kit: kit, agent: agent, birthLocation: birthLocation,
                  ethnicity: ethnicity, status: status,
                  
                  descriptionEN: descriptionEN,
                  descriptionDE: descriptionDE, descriptionFR: descriptionFR, descriptionCN: descriptionCN, descriptionIT: descriptionIT,
                  descriptionJP: descriptionJP, descriptionRU: descriptionRU, descriptionES: descriptionES, descriptionPT: descriptionPT,
                  descriptionSE:descriptionSE, descriptionNL: descriptionNL, descriptionHU: descriptionHU, descriptionNO: descriptionNO,
                  descriptionIL: descriptionIL, descriptionPL: descriptionPL,
                  gender: gender, side: side, position: position,
                  college: college,
                  facebook: facebook, website: website, twitter: twitter, instagram: instagram,
                  youtube: youtube, height: height, weight: weight, intLoved: intLoved,
                  thumb: thumb,
                  poster: poster,
                  cutout: cutout, render: render,
                  banner: banner,
                  fanart1: fanart1, fanart2: fanart2, fanart3: fanart3, fanart4: fanart4,
               creativeCommons: creativeCommons, locked: locked, relevance: relevance)
    }
}
