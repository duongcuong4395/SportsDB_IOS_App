//
//  Event.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

struct Event: Equatable, Identifiable {
    var id = UUID()
    var idEvent, idAPIfootball, eventName, eventAlternate: String?
    var filename, sportName, idLeague, leagueName: String?
    var leagueBadge: String?
    var season, descriptionEN, homeTeam, awayTeam: String?
    var homeScore, round, awayScore: String?
    var spectators: String?
    var official, timestamp, dateEvent, dateEventLocal: String?
    var time, timeLocal, group, idHomeTeam: String?
    var homeTeamBadge: String?
    var idAwayTeam: String?
    var awayTeamBadge: String?
    var score, scoreVotes: String?
    var result, idVenue, venue, country: String?
    var city: String?
    var poster, square: String?
    var fanart: String?
    var thumb, banner: String?
    var map: String?
    var tweet1, tweet2, tweet3: String?
    var video: String?
    var status, postponed, locked: String?
    
    var like: Bool = false
    var notificationStatus: NotificationStatus = .creeated
    
    var promptEvent2vs2Analysis: String { """
Bạn là một chuyên gia thể thao với hơn 30 năm kinh nghiệm trong lĩnh vực phân tích và dự đoán kết quả các trận đấu của môn thể thao \(sportName ?? ""). Với sự am hiểu sâu sắc về các team (\(homeTeam ?? "") , \(awayTeam ?? "")), cầu thủ, chiến thuật thi đấu và xu hướng của giải đấu, hãy sử dụng kiến thức phong phú của bạn để tiến hành phân tích chi tiết về sự kiện thể thao \(eventName ?? "") trong khuôn khổ Giải đấu \(leagueName ?? "").

Sự kiện này sẽ diễn ra vào thời điểm \(timestamp ?? "") tại địa điểm \(venue ?? ""). Bạn hãy xem xét các yếu tố ảnh hưởng như phong độ hiện tại của các đội, thống kê lịch sử đối đầu, điều kiện thời tiết, cũng như các chấn thương có thể xảy ra với cầu thủ.

Bên cạnh đó, hãy đưa ra dự đoán kết quả cuối cùng của trận đấu trong vòng \(round ?? "") của mùa giải \(season ?? "") này. Phân tích của bạn sẽ rất có giá trị đối với những người hâm mộ và các nhà đầu tư trong lĩnh vực cá cược thể thao.
"""}
    
}




import SwiftData

extension Event{
    func toEventSwiftData(with notificationStatus: NotificationStatus) -> EventSwiftData {
        EventSwiftData(
            idEvent: idEvent
            , idAPIfootball: idAPIfootball
            , eventName: eventName
            , eventAlternate: eventAlternate
            , filename: filename
            , sportName: sportName
            , idLeague: idLeague
            , leagueName: leagueName
            , leagueBadge: leagueBadge
            , season: season
            , descriptionEN: descriptionEN
            , homeTeam: homeTeam
            , awayTeam: awayTeam
            , homeScore: homeScore
            , round: round
            , awayScore: awayScore
            , spectators: spectators
            , official: official
            , timestamp: timestamp
            , dateEvent: dateEvent
            , dateEventLocal: dateEventLocal
            , time: time
            , timeLocal: timeLocal
            , group: group
            , idHomeTeam: idHomeTeam
            , homeTeamBadge: homeTeamBadge
            , idAwayTeam: idAwayTeam
            , awayTeamBadge: awayTeamBadge
            , score: score
            , scoreVotes: scoreVotes
            , result: result
            , idVenue: idVenue
            , venue: venue
            , country: country
            , city: city
            , poster: poster
            , square: square
            , fanart: fanart
            , thumb: thumb
            , banner: banner
            , map: map, tweet1: tweet1, tweet2: tweet2, tweet3: tweet3, video: video, status: status
            , postponed: postponed, locked: locked, like: like, notificationStatus: notificationStatus.rawValue)
    }
}

// MARK: For Notification

extension Event {
    func isNotified(in notifications: [NotificationItem]) -> Bool {
        notifications.contains { $0.userInfo["idEvent"] == idEvent }
    }
    
    var asNotificationItem: NotificationItem? {
        
        guard let timestamp = timestamp
                , let dateString = AppUtility.formatDate(from: timestamp, to: "yyyy-MM-dd'T'HH:mm:ss") else { return nil }
        
        let dateNoti = DateFormatter()
        dateNoti.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateNoti.date(from: dateString) else { return nil }
        
        return NotificationItem(
            id: idEvent ?? "",// id.uuidString,
            title: eventName ?? "Upcoming Event",
            body: "\(homeTeam ?? "") vs \(awayTeam ?? "")",
            triggerDate: date,
            userInfo: [
                "idEvent": idEvent ?? "",
                "leagueName": leagueName ?? "",
                "season": season ?? "",
                "eventName": eventName ?? "",
                "sportType": sportName ?? "", // hoặc sportType.rawValue
                "homeTeamName": homeTeam ?? "",
                "awayTeamName": awayTeam ?? "",
                "idHomeTeam": idHomeTeam ?? "",
                "idAwayTeam": idAwayTeam ?? "",
                "idVenue": idVenue ?? "",
                "strVenue": venue ?? "",
                "poster": poster ?? "",
                "thumb": thumb ?? "",
                "banner": banner ?? "",
                "square": square ?? "",
                "dateTime": AppUtility.formatDate(from: timestamp, to: "dd/MM/yyyy HH:mm") ?? ""
            ],
            hasRead: false
        )
        
    }
}

