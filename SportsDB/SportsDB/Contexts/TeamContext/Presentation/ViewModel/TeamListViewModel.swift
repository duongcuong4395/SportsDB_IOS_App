//
//  TeamListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

@MainActor
class TeamListViewModel: ObservableObject {
    
    @Published private(set) var teamsStatus: ModelsStatus<[Team]> = .idle
    
    @Published var teamsBySearch: [Team] = []
    
    
    // MARK: - Computed Properties (Public Interface)
    var teams: [Team] {
        teamsStatus.data ?? []
        //(currentSearchText.isEmpty ? countriesStatus : filteredCountriesStatus).data ?? []
    }
    
    var isLoading: Bool {
        teamsStatus.isLoading
    }
    
    @Published var isloading: Bool = false
    @Published var erroMessage: String = ""
    
    private var getListTeamsUseCase: GetListTeamsUseCase
    private var searchTeamsUseCase: SearchTeamsUseCase
    
    init(getListTeamsUseCase: GetListTeamsUseCase,
         searchTeamsUseCase: SearchTeamsUseCase) {
        self.getListTeamsUseCase = getListTeamsUseCase
        self.searchTeamsUseCase = searchTeamsUseCase
    }
    
}

extension TeamListViewModel {
    func getListTeams(leagueName: String, sportName: String, countryName: String) async {
        do {
            DispatchQueueManager.share.runOnMain {
                self.teamsStatus  = .loading
            }
            
            let res = try await getListTeamsUseCase.execute(leagueName: leagueName, sportName: sportName, countryName: countryName)
            DispatchQueueManager.share.runOnMain {
                self.teamsStatus = .success(data: res)
            }
        } catch {
            DispatchQueueManager.share.runOnMain {
                print("=== getListTeams", error.localizedDescription)
                self.teamsStatus = .failure(error: error.localizedDescription)
            }
        }
    }
    
    func searchTeams(teamName: String) async {
        isloading = true
        defer { isloading = false }
        
        do {
            teamsBySearch = try await searchTeamsUseCase.execute(teamName: teamName)
        } catch {
            erroMessage = error.localizedDescription
        }
    }
    
    func getTeam(by text: String) -> Team? {
        let team = teams.first { team in
            team.idTeam == text || team.teamName == text
        }
        print("=== getTeam:", text, team?.teamName ?? "empty Team Name", team?.idTeam ?? "empty Team id")
        return team
    }
}


extension TeamListViewModel {
    func resetAll() {
        self.teamsStatus = .idle
        self.teamsBySearch = []
        self.isloading = false
        self.erroMessage = ""
    }
}
