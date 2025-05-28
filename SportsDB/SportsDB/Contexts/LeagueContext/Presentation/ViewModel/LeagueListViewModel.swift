//
//  LeagueListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// LeagueContext/Presentation/ViewModel/LeagueListViewModel.swift
@MainActor
final class LeagueListViewModel: ObservableObject {
    @Published var leagues: [League] = []
    @Published var leaguesTable: [LeagueTable] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getLeaguesUseCase: GetLeaguesUseCase
    private let lookupLeagueUseCase: LookupLeagueUseCase
    private let lookupLeagueTableUseCase: LookupLeagueTableUseCase
    
    init(getLeaguesUseCase: GetLeaguesUseCase,
         lookupLeagueUseCase: LookupLeagueUseCase,
         lookupLeagueTableUseCase: LookupLeagueTableUseCase) {
        self.getLeaguesUseCase = getLeaguesUseCase
        self.lookupLeagueUseCase = lookupLeagueUseCase
        self.lookupLeagueTableUseCase = lookupLeagueTableUseCase
    }

    func fetchLeagues(country: String, sport: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            leagues = try await getLeaguesUseCase.execute(country: country, sport: sport)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    func lookupLeague(leagueID: String) async {
        isLoading = true
        defer { isLoading = false }
        do{
            leagues = try await lookupLeagueUseCase.execute(with: leagueID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func lookupLeagueTable(leagueID: String, season: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            leaguesTable = try await lookupLeagueTableUseCase.execute(league_ID: leagueID, season: season)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}

