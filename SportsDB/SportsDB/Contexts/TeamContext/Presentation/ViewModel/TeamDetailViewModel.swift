//
//  TeamDetailViewModel.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI


@MainActor
class TeamDetailViewModel: ObservableObject {
    @Published var teamSelected: Team?
    @Published var equipments: [Equipment] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private var lookupEquipmentUseCase: LookupEquipmentUseCase
    
    init(lookupEquipmentUseCase: LookupEquipmentUseCase) {
        self.lookupEquipmentUseCase = lookupEquipmentUseCase
    }
    
    func setTeam(by team: Team?) {
        self.teamSelected = team
    }
    
    func lookupEquipment(teamID: String) async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            equipments = try await lookupEquipmentUseCase.execute(teamID: teamID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func resetEquipment() {
        equipments = []
    }
}
