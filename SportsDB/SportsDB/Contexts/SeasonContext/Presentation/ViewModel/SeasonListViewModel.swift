//
//  SeasonListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

@MainActor
class SeasonListViewModel: ObservableObject {
    @Published var seasons: [Season] = []
    @Published var seasonSelected: Season?
    @Published var errorMessage: String = ""
    
    
    private var getListSeasonsUseCase: GetListSeasonsUseCase
    
    init(getListSeasonsUseCase: GetListSeasonsUseCase) {
        self.getListSeasonsUseCase = getListSeasonsUseCase
    }
    
    
}


extension SeasonListViewModel {
    func resetAll() {
        self.seasons = []
        self.seasonSelected = nil
        self.errorMessage = ""
    }
    
    func setSeason(by season: Season?, completion: @escaping (Season?) -> Void) {
        seasonSelected = nil
        seasonSelected = season
        completion(season)
    }
    
    func getListSeasons(leagueID: String) async {
        do {
            let res = try await getListSeasonsUseCase.execute(leagueID: leagueID)
            seasons = res.sorted{ $0.season > $1.season }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
