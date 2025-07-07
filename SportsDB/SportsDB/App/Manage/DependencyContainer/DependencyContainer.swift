//
//  DependencyContainer.swift
//  SportsDB
//
//  Created by Macbook on 5/6/25.
//

import SwiftUI

//@MainActor
/*
// MARK: - Dependency Container
class DependencyContainer {
    // Repositories
    lazy var countryRepository = CountryAPIService()
    lazy var leagueRepository = LeagueAPIService()
    lazy var seasonRepository = SeasonAPIService()
    lazy var teamRepository = TeamAPIService()
    lazy var eventRepository = EventAPIService()
    lazy var playerRepository = PlayerAPIService()
    
    // Use Cases
    lazy var getAllCountriesUseCase = GetAllCountriesUseCase(repository: countryRepository)
    lazy var getLeaguesUseCase = GetLeaguesUseCase(repository: leagueRepository)
    lazy var lookupLeagueUseCase = LookupLeagueUseCase(repository: leagueRepository)
    lazy var lookupLeagueTableUseCase = LookupLeagueTableUseCase(repository: leagueRepository)
    lazy var getListSeasonsUseCase = GetListSeasonsUseCase(repository: seasonRepository)
    lazy var getListTeamsUseCase = GetListTeamsUseCase(repository: teamRepository)
    lazy var searchTeamsUseCase = SearchTeamsUseCase(repository: teamRepository)
    lazy var lookupEquipmentUseCase = LookupEquipmentUseCase(repository: teamRepository)
    
    // Event Use Cases
    lazy var searchEventsUseCase = SearchEventsUseCase(repository: eventRepository)
    lazy var lookupEventUseCase = LookupEventUseCase(repository: eventRepository)
    lazy var lookupListEventsUseCase = LookupListEventsUseCase(repository: eventRepository)
    lazy var lookupEventsInSpecificUseCase = LookupEventsInSpecificUseCase(repository: eventRepository)
    lazy var lookupEventsPastLeagueUseCase = LookupEventsPastLeagueUseCase(repository: eventRepository)
    lazy var getEventsOfTeamByScheduleUseCase = GetEventsOfTeamByScheduleUseCase(repository: eventRepository)
    
    // Player Use Cases
    lazy var lookupPlayerUseCase = LookupPlayerUseCase(repository: playerRepository)
    lazy var searchPlayersUseCase = SearchPlayersUseCase(repository: playerRepository)
    lazy var lookupHonoursUseCase = LookupHonoursUseCase(repository: playerRepository)
    lazy var lookupFormerTeamsUseCase = LookupFormerTeamsUseCase(repository: playerRepository)
    lazy var lookupMilestonesUseCase = LookupMilestonesUseCase(repository: playerRepository)
    lazy var lookupContractsUseCase = LookupContractsUseCase(repository: playerRepository)
    lazy var lookupAllPlayersUseCase = LookupAllPlayersUseCase(repository: playerRepository)
    
    // View Models Factory
    func makeCountryListViewModel() -> CountryListViewModel {
        CountryListViewModel(useCase: getAllCountriesUseCase)
    }
    
    func makeLeagueListViewModel() -> LeagueListViewModel {
        LeagueListViewModel(
            getLeaguesUseCase: getLeaguesUseCase,
            lookupLeagueUseCase: lookupLeagueUseCase,
            lookupLeagueTableUseCase: lookupLeagueTableUseCase
        )
    }
    
    func makeSeasonListViewModel() -> SeasonListViewModel {
        SeasonListViewModel(getListSeasonsUseCase: getListSeasonsUseCase)
    }
    
    func makeTeamListViewModel() -> TeamListViewModel {
        TeamListViewModel(
            getListTeamsUseCase: getListTeamsUseCase,
            searchTeamsUseCase: searchTeamsUseCase
        )
    }
    
    func makeTeamDetailViewModel() -> TeamDetailViewModel {
        TeamDetailViewModel(lookupEquipmentUseCase: lookupEquipmentUseCase)
    }
    
    func makeEventListViewModel() -> EventListViewModel {
        EventListViewModel(
            searchEventsUseCase: searchEventsUseCase,
            lookupEventUseCase: lookupEventUseCase,
            lookupListEventsUseCase: lookupListEventsUseCase,
            lookupEventsInSpecificUseCase: lookupEventsInSpecificUseCase,
            lookupEventsPastLeagueUseCase: lookupEventsPastLeagueUseCase,
            getEventsOfTeamByScheduleUseCase: getEventsOfTeamByScheduleUseCase
        )
    }
    
    func makePlayerListViewModel() -> PlayerListViewModel {
        PlayerListViewModel(
            lookupPlayerUseCase: lookupPlayerUseCase,
            searchPlayersUseCase: searchPlayersUseCase,
            lookupHonoursUseCase: lookupHonoursUseCase,
            lookupFormerTeamsUseCase: lookupFormerTeamsUseCase,
            lookupMilestonesUseCase: lookupMilestonesUseCase,
            lookupContractsUseCase: lookupContractsUseCase,
            lookupAllPlayersUseCase: lookupAllPlayersUseCase
        )
    }
}
*/
