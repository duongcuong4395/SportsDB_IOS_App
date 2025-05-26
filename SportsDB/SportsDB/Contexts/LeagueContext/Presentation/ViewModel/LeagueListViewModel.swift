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

    private let getByCountry: GetLeaguesByCountryUseCase
    private let getByCountryAndSport: GetLeaguesByCountryAndSportUseCase

    init(getByCountry: GetLeaguesByCountryUseCase,
         getByCountryAndSport: GetLeaguesByCountryAndSportUseCase) {
        self.getByCountry = getByCountry
        self.getByCountryAndSport = getByCountryAndSport
    }

    func fetchLeagues(country: String, sport: String? = nil) async {
        isLoading = true
        defer { isLoading = false }

        do {
            if let sport = sport {
                leagues = try await getByCountryAndSport.execute(country: country, sport: sport)
            } else {
                leagues = try await getByCountry.execute(country: country)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

