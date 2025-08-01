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

struct TeamDetailRouteView: View {
    var team: Team
    
    var badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (width: 60, height: 60)
    
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    
    @State var trophyGroup: [TrophyGroup] = []
    @State var isVisible: Bool = false
    
    @State var isVisibleViews: (
        forEvents: Bool,
        forEquipment: Bool
    ) = (forEvents: false,
         forEquipment: false)
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                
                    TeamItemView(team: team, badgeImageSize: badgeImageSizePerLeague)
                    BuildEventsOfTeamByScheduleView(team: team)
                        .onAppear{
                            isVisibleViews.forEvents = true
                        }
                        .slideInEffect(isVisible: $isVisibleViews.forEvents, delay: 0.5, direction: .leftToRight)
                    
                    TitleComponentView(title: "Equipments")
                    EquipmentsListView(equipments: teamDetailVM.equipments)
                        .onAppear{
                            isVisibleViews.forEquipment = true
                        }
                        .slideInEffect(isVisible: $isVisibleViews.forEquipment, delay: 0.5, direction: .leftToRight)
                    
                    TitleComponentView(title: "Players")
                    if playerListVM.playersByLookUpAllForaTeam.count > 0 {
                        BuildPlayersForTeamDetailView(team: team, progressing: false)
                        
                            .frame(height:  playerListVM.playersByLookUpAllForaTeam.count > 0 ? UIScreen.main.bounds.height / 2 : 0)
                            .slideInEffect(isVisible: $isVisible, delay: 0.5, direction: .leftToRight)
                            .onAppear{
                                withAnimation(.spring()){
                                    isVisible = true
                                }
                            }
                            .onDisappear{
                                withAnimation(.spring()){
                                    isVisible = false
                                }
                            }
                    }
                    
                    
                    TitleComponentView(title: "Trophies")
                    if trophyListVM.trophyGroups.count > 0 {
                        TrophyListView(trophyGroup: trophyListVM.trophyGroups)
                            .frame(height: trophyListVM.trophyGroups.count > 0 ? UIScreen.main.bounds.height/2 : 0)
                    }
                    
                    TeamAdsView(team: team)
                }
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


struct PlayersAndTrophiesAIResponse: Codable {
    var players: [PlayersAIResponse]
    var trophies: [Trophy]
    
    
    enum CodingKeys: String, CodingKey {
        case trophies = "honours"
        case players
    }
}
