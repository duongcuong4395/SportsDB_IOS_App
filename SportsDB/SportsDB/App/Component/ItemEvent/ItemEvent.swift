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
            .font(.title3)
            .padding(6)
            .onTapGesture {
                action()
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
    func handleTapOnTeam(by event: Event, with kindTeam: KindTeam) async throws {
        let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
        let homeTeam = String(homeVSAwayTeam?[0] ?? "")
        let awayTeam = String(homeVSAwayTeam?[1] ?? "")
        let teamName: String = kindTeam == .AwayTeam ? awayTeam : homeTeam
        
        
        if let teamSelected = await teamDetailVM.teamSelected
            , teamSelected.teamName == teamName {
            return
        }
        
        await resetWhenTapTeam()
        try await selectTeam(by: teamName)
    }
    
    @MainActor
    func resetWhenTapTeam() {
        withAnimation(.spring()) {
            eventsOfTeamByScheduleVM.resetAll()
            trophyListVM.resetTrophies()
            playerListVM.resetPlayersByLookUpAllForaTeam()
            teamDetailVM.resetEquipment()
        }
    }
    
    @MainActor
    func selectTeam(by teamName: String) async throws {
        if let teamSelected = teamDetailVM.teamSelected {
            if teamSelected.teamName != teamName {
                await setTeam(by: teamName)
            }
        } else {
            await setTeam(by: teamName)
        }
       
        guard let team = teamDetailVM.teamSelected else { return }
        if !sportRouter.isAtTeamDetail() {
            sportRouter.navigateToTeamDetail()
        }
        
        async let eventsTask: () = getEventsUpcomingAndResults(by: team)
        async let equipmentsTask: () = getEquipments(by: team.idTeam ?? "")
        async let playersTask: () = getPlayersAndTrophies(by: team)
        
        _ = await (eventsTask, equipmentsTask, playersTask)
    }
    
    
    func setTeam(by teamName: String) async {
        await teamListVM.searchTeams(teamName: teamName)
        guard await teamListVM.teamsBySearch.count > 0 else { return }
        await teamDetailVM.setTeam(by: teamListVM.teamsBySearch[0])
        return
    }
    
    
    func getEquipments(by teamID: String?) async {
        await teamDetailVM.lookupEquipment(teamID: teamID ?? "")
    }
    
    func getEventsUpcomingAndResults(by team: Team) async {
        await eventsOfTeamByScheduleVM.getEvents(by: team)
    }
    
    @MainActor
    func getPlayersAndTrophies(by team: Team) async {
        let(players, trophies) = await team.fetchPlayersAndTrophies()
        trophyListVM.setTrophyGroup(by: trophies)
        await playerListVM.lookupAllPlayers(teamID: team.idTeam ?? "")
        getMorePlayer(players: players)
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



// MARK: Events ViewModel

@MainActor
protocol EventsViewModel: ObservableObject {
    var eventsStatus: ModelsStatus<[Event]> { get set }
    var events: [Event] { get }
    func updateEvent(from oldItem: Event, with newItem: Event)
}

extension EventsViewModel {
    func updateEvent(from oldItem: Event, with newItem: Event) {
        self.eventsStatus = eventsStatus.updateElement(where: { oldEvent in
            oldEvent.idEvent == oldItem.idEvent
        }, with: newItem)
    }
    
    func findEvent(with eventID: String) -> Event? {
        self.eventsStatus.data?.first(where: { $0.idEvent == eventID })
    }
    
    func toggleLikeOnUI(at eventID: String, by like: Bool) {
        guard var event = findEvent(with: eventID) else { return }
        
        event.like = like
        updateEvent(from: event, with: event)
    }
    
    func toggleNotificationOnUI(at eventID: String, by status: NotificationStatus) {
        guard var event = findEvent(with: eventID) else { return }
        
        event.notificationStatus = status
        updateEvent(from: event, with: event)
    }
    
    func resetAll() {
        self.eventsStatus = .idle
    }
}
