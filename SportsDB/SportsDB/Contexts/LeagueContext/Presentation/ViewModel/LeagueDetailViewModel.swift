//
//  LeagueDetailViewModel.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

final class LeagueDetailViewModel: ObservableObject {
    @Published var league: League?
    
    func setLeague(by league: League?) {
        self.league = league
    }
}
