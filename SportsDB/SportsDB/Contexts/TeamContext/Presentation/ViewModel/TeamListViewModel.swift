//
//  TeamListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

class TeamListViewModel: ObservableObject {
    @Published var teams: [Team] = []
    @Published var teamsBySearch: [Team] = []
    
    @Published var isloading: Bool = false
    @Published var erroMessage: String = ""
    
    private var getListTeamsUseCase: GetListTeamsUseCase
    private var searchTeamsUseCase: SearchTeamsUseCase
    
    init(getListTeamsUseCase: GetListTeamsUseCase,
         searchTeamsUseCase: SearchTeamsUseCase) {
        self.getListTeamsUseCase = getListTeamsUseCase
        self.searchTeamsUseCase = searchTeamsUseCase
    }
    
    func getListTeams(leagueName: String, sportName: String, countryName: String) async {
        isloading = true
        defer { isloading = false }
        do {
            teams = try await getListTeamsUseCase.execute(leagueName: leagueName, sportName: sportName, countryName: countryName)
        } catch {
            erroMessage = error.localizedDescription
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
}


