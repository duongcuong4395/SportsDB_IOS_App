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
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getByCountryAndSport: GetLeaguesByCountryAndSportUseCase

    init(getByCountryAndSport: GetLeaguesByCountryAndSportUseCase) {
        self.getByCountryAndSport = getByCountryAndSport
    }

    func fetchLeagues(country: String, sport: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            leagues = try await getByCountryAndSport.execute(country: country, sport: sport)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

