//
//  Team.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

struct Team: Equatable, Identifiable {
    var id = UUID()
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
}


extension Team {
    
    func fetchPlayersAndTrophies(chatVM: ChatViewModel, completion: @escaping ([TrophyGroup], [PlayersAIResponse]) -> Void) {
        // fetchHTML(from: "https://www.thesportsdb.com/team/133612-manchester-united?a=1#alltrophies") { result in
        fetchHTML(from: "https://www.thesportsdb.com/team/\(idTeam ?? "")-\(teamName)?a=1#alltrophies") { result in
            switch result {
            case .success(let htmlContent):
                //print("HTML:\n\(htmlContent)")
                // TODO: parse với SwiftSoup nếu cần
                // , "position": "", "flagLink"
                Task {
                    
                    let prompt = """
                    Phân tích nội dung HTML sau và trích xuất dữ liệu thành JSON theo cấu trúc:
                    {
                      "players": [
                        {"name": "Họ Tên đầy đủ của cầu thủ thuộc đội bóng \(teamName)"}
                      ],
                      "honours": [
                        {
                        "title": "Tên danh hiệu",
                        "years": ["Năm 1", "Năm 2", "..."],
                        "honourArtworkLink": "Link ảnh danh hiệu"
                    }
                      ]
                    }
                    
                    Cấu trúc HTML như sau:
                    1. Team Members
                    - Nằm bên dưới <b id="playerImages">Team Members</b>
                    - Các cầu thủ được hiển thị trong các phần tử <td
                    - Hiển thị Họ và tên đầy đủ của cầu thủ thuộc đội bóng \(teamName)
                    - ví dụ như nếu phần tử <td là "Martínez" thì bạn hãy tìm ra họ tên đầy đủ của cầu thủ đó trong đội tuyển Man U là 'Lisandro Martínez"
                    
                    2. Honours (Trophies):
                    - Nằm bên dưới <b id="alltrophies">Trophies</b>
                    - Mỗi danh hiệu hiển thị trong phần tử <td 
                    - Gồm:
                       - `img` chứa ảnh danh hiệu, có thuộc tính `title` là tên danh hiệu
                      - Text đi kèm là năm
                    Hãy phân tích HTML và trả về đúng cấu trúc JSON phía trên. Đảm bảo giữ nguyên link ảnh (img.src) và text nội dung. Không tạo thêm hoặc giả định dữ liệu nếu không có trong HTML.

                    Dữ liệu HTML: 
                    \(htmlContent)
                    """
                    
                    var res = try await chatVM.aiSend(prompt: prompt)
                    
                    res = res.replacingOccurrences(of: "```", with: "")
                    res = res.replacingOccurrences(of: "json", with: "")
                    
                    if let jsonData = res.data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(PlayersAndTrophiesAIResponse.self, from: jsonData)
                            print("=== result.players.count", result.players.count)
                            print("=== result.honours.count", result.trophies.count)
                            //self.trophies = result.trophies
                            
                            let trophyGroups = groupTrophies(result.trophies)
                            
                            completion(trophyGroups, result.players)
                        } catch {
                            print("Lỗi parse JSON: \(error)")
                            completion([], [])
                        }
                    }
                    
                    
                }
                
                
            case .failure(let error):
                print("Error fetching HTML: \(error.localizedDescription)")
            }
        }
    }
    
    func groupTrophies(_ trophies: [Trophy]) -> [TrophyGroup] {
        let grouped = Dictionary(grouping: trophies) { trophy in
            TrophyGroupKey(title: trophy.title, honourArtworkLink: trophy.honourArtworkLink)
        }

        return grouped.map { key, values in
            TrophyGroup(
                title: key.title,
                honourArtworkLink: key.honourArtworkLink,
                listSeason: values.map { $0.season }.sorted()
            )
        }
    }
}
