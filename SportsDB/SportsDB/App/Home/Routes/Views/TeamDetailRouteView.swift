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

struct TeamDetailRouteView<
    ViewForEquipments: View,
    ViewForPlayers: View,
    ViewForTrophies: View,
    ViewEventsOfTeamBySchedule: View
>: View {
    var team: Team
    //var team: Team
    
    var events: (
        condition: Bool,
        withView: ViewEventsOfTeamBySchedule
        
    )
    
    var equipments: (
        condition: Bool,
        withView: ViewForEquipments
    )
    
    var players: (
        condition: Bool,
        withMainView: ViewForPlayers
    )
    
    var trophies: (
        condition: Bool,
        withView: ViewForTrophies
    )
    
    var badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (width: 60, height: 60)
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
                    if events.condition {
                        events.withView
                            .onAppear{
                                isVisibleViews.forEvents = true
                            }
                            .slideInEffect(isVisible: $isVisibleViews.forEvents, delay: 0.5, direction: .leftToRight)
                    }
                    
                    TitleComponentView(title: "Equipments")
                    if equipments.condition {
                        equipments.withView
                            .onAppear{
                                isVisibleViews.forEquipment = true
                            }
                            .slideInEffect(isVisible: $isVisibleViews.forEquipment, delay: 0.5, direction: .leftToRight)
                    }
                    
                    
                    TitleComponentView(title: "Players")
                    if players.condition {
                        players.withMainView
                            .frame(height:  players.condition ? UIScreen.main.bounds.height / 2 : 0)
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
                    if trophies.condition {
                        trophies.withView
                            .frame(height: trophies.condition ? UIScreen.main.bounds.height/2 : 0)
                    }
                    
                    TeamAdsView(team: team)
                }
            }
        }
        .onChange(of: team) { oldValue, newValue in
            print("=== team changed", team.teamName)
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
