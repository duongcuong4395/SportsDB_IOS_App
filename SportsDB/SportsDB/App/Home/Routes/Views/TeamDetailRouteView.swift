//
//  TeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

import SwiftUI
import Kingfisher
import GeminiAI
import GoogleGenerativeAI

struct TeamDetailRouteView<ViewForPlayers: View, ViewForMorePlayers: View>: View {
    var team: Team
    
    var players: (
        withMainView: ViewForPlayers,
        withMorePlayersView: ViewForMorePlayers
    )
    
    
    var badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (width: 60, height: 60)
    @EnvironmentObject var chatVM: ChatViewModel
    
    @State var trophyGroup: [TrophyGroup] = []
    //@State var players: [PlayersAIResponse] = []
    
    //var getPlayers: (Team, inout [PlayersAIResponse]) -> Void
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    TeamItemView(team: team, badgeImageSize: badgeImageSizePerLeague)
                    
                    TitleComponentView(title: "Players")
                    TabView{
                        players.withMainView
                        players.withMorePlayersView
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: UIScreen.main.bounds.height / 2)
                    
                    TitleComponentView(title: "Trophies")
                    TrophyListView(trophyGroup: trophyGroup)
                        .frame(height: UIScreen.main.bounds.height/2)
                    
                    
                    TeamAdsView(team: team)
                }
            }
        }
        
        .onAppear{
            
            //getPlayers(team, &players)
            /*
            team.fetchPlayersAndTrophies(chatVM: chatVM) { trophyGroups, players in
                self.trophyGroup = trophyGroups
                print("=== players.count ", players.count, players.map{ $0.name })
                self.players =  Array(players.prefix(25)) // [players[0]]
            }
             */
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


struct PlayersAndTrophiesAIResponse: Codable {
    var players: [PlayersAIResponse]
    var trophies: [Trophy]
    
    
    enum CodingKeys: String, CodingKey {
        case trophies = "honours"
        case players
    }
}





import SwiftSoup
import GeminiAI
