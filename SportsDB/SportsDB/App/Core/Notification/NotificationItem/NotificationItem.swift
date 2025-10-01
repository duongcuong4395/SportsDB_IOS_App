//
//  NotificationItem.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import Foundation

struct NotificationItem: Identifiable, Equatable, Codable {
    var id: String                     // Unique ID
    var title: String
    var body: String
    var triggerDate: Date
    var userInfo: [String: String]     // Metadata (ex: idEvent, sportType...)
    var hasRead: Bool
}

/*
 [
     "sportType": sportName ?? ""
     , "idEvent": idEvent ?? ""
     , "idAPIfootball": idAPIfootball ?? ""
     , "eventName": eventName ?? ""
     , "eventAlternate": eventAlternate ?? ""
     , "filename": filename ?? ""
     , "sportName": sportName ?? ""
     , "idLeague": idLeague ?? ""
     , "leagueName": leagueName ?? ""
     , "leagueBadge": leagueBadge ?? ""
     , "season": season ?? ""
     , "descriptionEN": descriptionEN ?? ""
     
     , "round": round ?? ""
     , "homeTeam": homeTeam ?? ""
     , "awayTeam": awayTeam ?? ""
     
     , "idHomeTeam": idHomeTeam ?? ""
     , "homeTeamBadge": homeTeamBadge ?? ""
     , "idAwayTeam": idAwayTeam ?? ""
     , "awayTeamBadge": awayTeamBadge ?? ""
     
     , "idVenue": idVenue ?? ""
     , "venue": venue ?? ""
     , "country": country ?? ""
     , "city": city ?? ""
     
     , "poster": poster ?? ""
     , "square": square ?? ""
     , "fanart": fanart ?? ""
     , "thumb": thumb ?? ""
     , "dateTime": AppUtility.formatDate(from: timestamp, to: "dd/MM/yyyy HH:mm") ?? ""
 ]
 */


