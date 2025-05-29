//
//  SeasonListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

class SeasonListViewModel: ObservableObject {
    @Published var seasons: [Season] = []
    @Published var errorMessage: String = ""
    
    
    private var getListSeasonsUseCase: GetListSeasonsUseCase
    
    init(getListSeasonsUseCase: GetListSeasonsUseCase) {
        self.getListSeasonsUseCase = getListSeasonsUseCase
    }
    
    
    func getListSeasons(leagueID: String) async {
        do {
            seasons = try await getListSeasonsUseCase.execute(leagueID: leagueID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
