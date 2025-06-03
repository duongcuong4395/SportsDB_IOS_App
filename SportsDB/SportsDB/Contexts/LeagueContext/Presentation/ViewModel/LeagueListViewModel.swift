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

    @Published var showRanks = [Bool](repeating: false, count: 0)
    
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

    func resetShowRank() {
        self.showRanks = [Bool](repeating: false, count: 0)
    }
    
    func resetLeaguesTable() {
        self.leaguesTable = []
    }
}

// MARK: For Each Use Case
@MainActor
extension LeagueListViewModel {
    func fetchLeagues(country: String, sport: String) async {
        isLoading = true
        defer { isLoading = false }
        print("=== fetchLeagues", country, sport)
        do {
            
            let leagues1 = try await getLeaguesUseCase.execute(country: country, sport: "")
            let leagues2 = try await getLeaguesUseCase.execute(country: country, sport: sport)
            
            var leaguesMerge = leagues1 + leagues2
            leaguesMerge = Array(Set(leaguesMerge))
            leaguesMerge = leaguesMerge.filter { $0.sportType?.rawValue == sport }
            self.leagues = leaguesMerge.sorted { $0.leagueName ?? "" > $1.leagueName ?? "" }
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
            self.showRanks = [Bool](repeating: false, count: leaguesTable.count)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
