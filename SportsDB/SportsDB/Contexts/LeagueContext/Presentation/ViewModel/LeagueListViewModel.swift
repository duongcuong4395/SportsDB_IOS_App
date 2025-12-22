//
//  LeagueListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// LeagueContext/Presentation/ViewModel/LeagueListViewModel.swift
class LeagueListViewModel: ObservableObject {
    
    // private(set) đảm bảo chỉ ViewModel mới modify được
    @Published private(set) var leaguesStatus: ModelsStatus<[League]> = .idle
    @Published private(set) var leaguesTableStatus: ModelsStatus<[LeagueTable]> = .idle
    
    var leaguesTable: [LeagueTable] {
        leaguesTableStatus.data ?? []
    }
    
    var leagues: [League] {
        leaguesStatus.data ?? []
        //(currentSearchText.isEmpty ? countriesStatus : filteredCountriesStatus).data ?? []
    }
    
    var isLoading: Bool {
        leaguesStatus.isLoading
    }

    var error: String? {
        leaguesStatus.error
    }

    var isEmpty: Bool {
        leagues.isEmpty && leaguesStatus.isSuccess
    }

    var hasData: Bool {
        leaguesStatus.isSuccess
    }
    
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
}

// MARK: For Each Use Case
extension LeagueListViewModel {
    func fetchLeagues(country: String, sport: String) async {
        do {
            DispatchQueueManager.share.runOnMain {
                self.leaguesStatus = .loading
            }
            async let leagues1Task = getLeaguesUseCase.execute(country: country, sport: "")
            async let leagues2Task = getLeaguesUseCase.execute(country: country, sport: sport)
            
            let leagues1 = try await leagues1Task
            let leagues2 = try await leagues2Task
            
            var leaguesMerge = leagues1 + leagues2
            leaguesMerge = Array(Set(leaguesMerge))
            leaguesMerge = leaguesMerge.filter { $0.sportType?.rawValue == sport }
            leaguesMerge = leaguesMerge.sorted { $0.leagueName ?? "" > $1.leagueName ?? "" }
            DispatchQueueManager.share.runOnMain {
                self.leaguesStatus = .success(data: leaguesMerge)
            }
        } catch {
            await MainActor.run {
                self.leaguesStatus = .failure(error: error.localizedDescription)
            }
        }
    }
    
    
    func lookupLeague(leagueID: String) async {
        do{
            leaguesStatus = .loading
            let res = try await lookupLeagueUseCase.execute(with: leagueID)
            self.leaguesStatus = .success(data: res)
        } catch {
            self.leaguesStatus = .failure(error: error.localizedDescription)
        }
    }

    func lookupLeagueTable(leagueID: String, season: String) async {
        do {
            DispatchQueueManager.share.runOnMain {
                self.leaguesTableStatus = .loading
            }
            let res = try await lookupLeagueTableUseCase.execute(league_ID: leagueID, season: season)
            print("lookupLeagueTable: \(leagueID) - \(season)", res.count)
            DispatchQueueManager.share.runOnMain {
                self.showRanks = [Bool](repeating: false, count: res.count)
                self.leaguesTableStatus = .success(data: res)
            }
        } catch {
            print("lookupLeagueTable.error: ", error.localizedDescription)
            DispatchQueueManager.share.runOnMain {
                self.leaguesTableStatus = .failure(error: error.localizedDescription)
            }
        }
    }
}

extension LeagueListViewModel {
    func resetShowRank() {
        self.showRanks = [Bool](repeating: false, count: 0)
    }
    
    func resetLeaguesTable() {
        self.leaguesTableStatus = .idle
    }
    
    func resetLeagues() {
        self.leaguesStatus = .idle
    }
    
    func resetAll() {
        resetShowRank()
        resetLeaguesTable()
        resetLeagues()
    }
}
