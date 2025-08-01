//
//  TrophyListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 4/6/25.
//

import SwiftUI

@MainActor
class TrophyListViewModel: ObservableObject {
    @Published var trophyGroups: [TrophyGroup] = []
    
    func setTrophyGroup(by trophyGroups: [TrophyGroup]) {
        self.trophyGroups = trophyGroups
    }
    
    func resetTrophies() {
        trophyGroups = []
    }
    
    func resetAll() {
        self.trophyGroups = []
    }
}
