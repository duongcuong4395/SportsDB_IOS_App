//
//  CountryListViewModel.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

// CountryContext/Presentation/ViewModel/CountryListViewModel.swift
import Foundation

@MainActor
final class CountryListViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: GetAllCountriesUseCase

    init(useCase: GetAllCountriesUseCase) {
        self.useCase = useCase
    }

    func fetchCountries() async {
        isLoading = true
        defer { isLoading = false }

        do {
            countries = try await useCase.execute()
        } catch {
            errorMessage = "Failed to load countries: \(error.localizedDescription)"
        }
    }
}
