//
//  AppDependencyContainer.swift
//  SportsDB
//
//  Created by Macbook on 16/8/25.
//
import SwiftUI
import SwiftData

@MainActor
// MARK: - Dependency Container
class AppDependencyContainer: ObservableObject {
    // MARK: - Router
    let sportRouter = SportRouter()
    
    // MARK: - Repositories
    private let countryAPIService = CountryAPIService()
    private let leagueAPIService = LeagueAPIService()
    private let seasonAPIService = SeasonAPIService()
    private let teamAPIService = TeamAPIService()
    private let eventAPIService = EventAPIService()
    private let playerAPIService = PlayerAPIService()
    
    // MARK: - Use Cases
    private lazy var getAllCountriesUseCase = GetAllCountriesUseCase(repository: countryAPIService)
    private lazy var getLeaguesUseCase = GetLeaguesUseCase(repository: leagueAPIService)
    private lazy var lookupLeagueUseCase = LookupLeagueUseCase(repository: leagueAPIService)
    private lazy var lookupLeagueTableUseCase = LookupLeagueTableUseCase(repository: leagueAPIService)
    
    // MARK: - ViewModels
    lazy var appVM = AppViewModel()
    lazy var sportVM = SportViewModel()
    
    lazy var countryListVM = CountryListViewModel(useCase: getAllCountriesUseCase)
    
    lazy var leagueListVM = LeagueListViewModel(
        getLeaguesUseCase: getLeaguesUseCase,
        lookupLeagueUseCase: lookupLeagueUseCase,
        lookupLeagueTableUseCase: lookupLeagueTableUseCase
    )
    
    lazy var leagueDetailVM = LeagueDetailViewModel()
    lazy var seasonListVM = SeasonListViewModel(
        getListSeasonsUseCase: GetListSeasonsUseCase(repository: seasonAPIService)
    )
    
    lazy var teamListVM = TeamListViewModel(
        getListTeamsUseCase: GetListTeamsUseCase(repository: teamAPIService),
        searchTeamsUseCase: SearchTeamsUseCase(repository: teamAPIService)
    )
    
    lazy var teamDetailVM = TeamDetailViewModel(
        lookupEquipmentUseCase: LookupEquipmentUseCase(repository: teamAPIService)
    )
    
    lazy var eventDetailVM = EventDetailViewModel(
        lookupEventResultsUseCase: LookupEventResultsUseCase(repository: EventAPIService())
        , lookupEventLineupUseCase: LookupEventLineupUseCase(repository: EventAPIService())
        , lookupEventTimelineUseCase: LookupEventTimelineUseCase(repository: EventAPIService())
        , lookupEventStatisticsUseCase: LookupEventStatisticsUseCase(repository: EventAPIService())
        , lookupEventTVBroadcastsUseCase: LookupEventTVBroadcastsUseCase(repository: EventAPIService()))
    
    lazy var eventListVM = EventListViewModel(
        searchEventsUseCase: SearchEventsUseCase(repository: eventAPIService),
        lookupEventUseCase: LookupEventUseCase(repository: eventAPIService)
    )
    
    lazy var eventsInSpecificInSeasonVM = EventsInSpecificInSeasonViewModel(
        lookupEventsInSpecificUseCase: LookupEventsInSpecificUseCase(repository: eventAPIService)
    )
    
    lazy var eventsRecentOfLeagueVM = EventsRecentOfLeagueViewModel(
        lookupEventsPastLeagueUseCase: LookupEventsPastLeagueUseCase(repository: eventAPIService)
    )
    
    lazy var eventsPerRoundInSeasonVM = EventsPerRoundInSeasonViewModel(
        lookupListEventsUseCase: LookupListEventsUseCase(repository: eventAPIService)
    )
    
    lazy var eventsOfTeamByScheduleVM = EventsOfTeamByScheduleViewModel(
        getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase(repository: eventAPIService)
    )
    
    lazy var playerListVM = PlayerListViewModel(
        lookupPlayerUseCase: LookupPlayerUseCase(repository: playerAPIService),
        searchPlayersUseCase: SearchPlayersUseCase(repository: playerAPIService),
        lookupHonoursUseCase: LookupHonoursUseCase(repository: playerAPIService),
        lookupFormerTeamsUseCase: LookupFormerTeamsUseCase(repository: playerAPIService),
        lookupMilestonesUseCase: LookupMilestonesUseCase(repository: playerAPIService),
        lookupContractsUseCase: LookupContractsUseCase(repository: playerAPIService),
        lookupAllPlayersUseCase: LookupAllPlayersUseCase(repository: playerAPIService)
    )
    
    lazy var trophyListVM = TrophyListViewModel()
    
    // MARK: - Swift Data ViewModels
    lazy var eventSwiftDataVM: EventSwiftDataViewModel = {
        let repo = EventSwiftDataRepository(context: ModelContext(MainDB.shared))
        let useCase = EventSwiftDataUseCase(repository: repo)
        return EventSwiftDataViewModel(context: ModelContext(MainDB.shared), useCase: useCase)
    }()
    
    lazy var aiManageVM: AIManageViewModel = {
        let repo = AISwiftDataRepository(context: ModelContext(MainDB.shared))
        let useCase = AIManageUseCase(repository: repo)
        return AIManageViewModel(context: ModelContext(MainDB.shared), useCase: useCase)
    }()
    
    // MARK: - Team Selection Manager
    lazy var teamSelectionManager = TeamSelectionManager(
        teamListVM: teamListVM,
        teamDetailVM: teamDetailVM,
        playerListVM: playerListVM,
        trophyListVM: trophyListVM,
        eventListVM: eventListVM,
        eventsOfTeamByScheduleVM: eventsOfTeamByScheduleVM,
        router: sportRouter
    )
    
    lazy var notificationListVM = NotificationListViewModel()
    
    lazy var eventToggleLikeManager = EventToggleLikeManager(
        eventListVM: eventListVM
        , eventsOfTeamByScheduleVM: eventsOfTeamByScheduleVM
        , eventsInSpecificInSeasonVM: eventsInSpecificInSeasonVM
        , eventsPerRoundInSeasonVM: eventsPerRoundInSeasonVM
        , eventsRecentOfLeagueVM: eventsRecentOfLeagueVM)
    
    lazy var eventToggleNotificationManager = EventToggleNotificationManager(
        eventListVM: eventListVM
        , eventsOfTeamByScheduleVM: eventsOfTeamByScheduleVM
        , eventsInSpecificInSeasonVM: eventsInSpecificInSeasonVM
        , eventsPerRoundInSeasonVM: eventsPerRoundInSeasonVM
        , eventsRecentOfLeagueVM: eventsRecentOfLeagueVM)
    
    lazy var manageLikeRouteVM = ManageLikeRouteViewModel(
        sportRouter: sportRouter
        , eventSwiftDataVM: eventSwiftDataVM
        , eventToggleLikeManager: eventToggleLikeManager)
}

// MARK: List events
extension AppDependencyContainer {
    func tapSport() {
        sportRouter.popToRoot()
        
        leagueListVM.resetAll()
        leagueDetailVM.resetAll()
        
        teamListVM.resetAll()
        teamDetailVM.resetAll()
        
        seasonListVM.resetAll()
        
        eventListVM.resetAll()
        eventsInSpecificInSeasonVM.resetAll()
        eventsRecentOfLeagueVM.resetAll()
        eventsPerRoundInSeasonVM.resetAll()
        eventsOfTeamByScheduleVM.resetAll()
        
        playerListVM.resetAll()
        trophyListVM.resetAll()
    }
    
    func appAppear() {
        Task {
            await notificationListVM.loadNotifications()
            await eventSwiftDataVM.loadEvents()
            _ = await aiManageVM.getKey()
        }
    }
    
    func handleNavigateToEvent(from notification: Notification) {
        guard let eventId = notification.userInfo?["eventId"] as? String,
              let notificationItem = notification.userInfo?["notification"] as? NotificationItem else {
            return
        }
        
        print("🚀 Navigating to event: \(eventId)")
         let event = notificationItem.toEvent()
         eventDetailVM.setEventDetail(event)
         sportRouter.navigateToEventDetail()
    }
}
