//
//  ItemEvent.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

import SwiftUI

enum KindTeam {
    case AwayTeam
    case HomeTeam
}

enum ItemEvent<T: Equatable> {
    case toggleLike(for: T)
    case viewDetail(for: T)
    case toggleNotify(for: T)
    case tapped(for: T)
    case tapOnTeam(for: T, with: KindTeam)
    case openVideo(for: T)
    case onApear(for: T)
}

enum IconItemType: String {
    case Default = "ellipsis.circle"
    case Down = "chevron.down"
    case Up = "chevron.up"
    case Right = "chevron.right"
    case Route3D = "move.3d"
    case Route = "point.topleft.down.curvedto.point.filled.bottomright.up"
    case RouteBranch = "arrow.triangle.branch"
    case RouteSwap = "arrow.triangle.swap"
    case Star = "wand.and.stars"
    case MultiStar = "sparkles"
    case NotificationOn = "bell.fill"
    case NotificationOff = "bell"
    case openVideo = "play.rectangle"
    case Info = "info.circle"
    case HeartFill = "heart.fill"
    case Heart = "heart"
}

protocol ItemBuilder {
    associatedtype T: Equatable
    func buildOptionsBind(for item: Binding<T>, send: @escaping (ItemEvent<T>) -> Void) -> AnyView
    func buildOptions(for item: T, send: @escaping (ItemEvent<T>) -> Void) -> AnyView
}

extension ItemBuilder {
    
    @ViewBuilder
    func buildItemButton(with image: IconItemType, action: @escaping () -> Void) -> some View {
        Image(systemName: image.rawValue)
            .font(.caption)
            .padding(6)
            .onTapGesture {
                action()
            }
    }
}


// MARK: Old version

protocol EventOptionsViewDelegate {}
extension EventOptionsViewDelegate {
    @ViewBuilder
    func getEventOptionsView(event: Event) -> some View {
        EventOptionsView(event: event) { action, event in
            switch action {
            case .toggleFavorite:
                print("=== event:toggleFavorite:", event.eventName ?? "")
                event
            case .toggleNotify:
                print("=== event:toggleNotify:", event.eventName ?? "")
            case .openPlayVideo:
                print("=== event:openPlayVideo:", event.eventName ?? "")
            case .viewDetail:
                print("=== event:viewDetail:", event.eventName ?? "")
            case .pushFireBase:
                print("=== event:pushFireBase:", event.eventName ?? "")
            case .selected:
                print("=== event:selected:", event.eventName ?? "")
            case .drawOnMap:
                print("=== event:drawOnMap:", event.eventName ?? "")
            }
        }
    }
}


protocol SelectTeamDelegate {
    var teamListVM: TeamListViewModel { get }
    var teamDetailVM: TeamDetailViewModel { get }
    var playerListVM: PlayerListViewModel { get }
    
    
    var trophyListVM: TrophyListViewModel { get }
    
    var sportRouter: SportRouter { get }
    
    var eventListVM: EventListViewModel { get }
    var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel { get }
    
}

extension SelectTeamDelegate {
    @MainActor
    func tapOnTeam(by event: Event, for kindTeam: KindTeam) {
        Task {
            await resetWhenTapTeam()
        }
        
        withAnimation {
            
            let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
            let homeTeam = String(homeVSAwayTeam?[0] ?? "")
            let awayTeam = String(homeVSAwayTeam?[1] ?? "")
            let team: String = kindTeam == .AwayTeam ? awayTeam : homeTeam
            //let teamID: String = kindTeam == .AwayTeam ? event.idAwayTeam ?? "" : event.idHomeTeam ?? ""
            sportRouter.navigateToTeamDetail()
            selectTeam(by: team)
            
        }
    }
    
    @MainActor
    func resetWhenTapTeam() async {
        withAnimation(.easeInOut(duration: 0.5)) {
            //teamDetailVM.teamSelected = nil
            trophyListVM.resetTrophies()
            playerListVM.resetPlayersByLookUpAllForaTeam()
            teamDetailVM.resetEquipment()
            //eventListVM.resetEventsOfTeamForNextAndPrevious()
        }
        return
    }
    
    @MainActor
    func selectTeam(by team: String) {
        Task {
            await teamListVM.searchTeams(teamName: team)
            guard teamListVM.teamsBySearch.count > 0 else { return }
            teamDetailVM.setTeam(by: teamListVM.teamsBySearch[0])
            guard let team = teamDetailVM.teamSelected else { return }
            
            eventsOfTeamByScheduleVM.selectTeam(by: team)
            
            
            await playerListVM.lookupAllPlayers(teamID: team.idTeam ?? "")
            
            await teamDetailVM.lookupEquipment(teamID: team.idTeam ?? "")
            
            getPlayersAndTrophies(by: team)
            
        }
    }
    
    @MainActor
    func getPlayersAndTrophies(by team: Team) {
        Task {
            let(players, trophies) = try await team.fetchPlayersAndTrophies()
            trophyListVM.setTrophyGroup(by: trophies)
            getMorePlayer(players: players)
        }
    }
    
    @MainActor
    func getMorePlayer(players: [Player]) {
        let cleanedPlayers = players.filter { otherName in
            !playerListVM.playersByLookUpAllForaTeam.contains { fullName in
                let fulName = (fullName.player ?? "").replacingOccurrences(of: "-", with: " ")
                
                return fulName.lowercased().contains(otherName.player?.lowercased() ?? "")
            }
        }
        
        DispatchQueueManager.share.runOnMain {
            playerListVM.playersByLookUpAllForaTeam.append(contentsOf: cleanedPlayers)
        }
    }
}
