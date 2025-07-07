//
//  CountryListViewModel.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

// CountryContext/Presentation/ViewModel/CountryListViewModel.swift
import Foundation

// @MainActor
final class CountryListViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var countrySelected: Country?
    
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: GetAllCountriesUseCase

    init(useCase: GetAllCountriesUseCase) {
        self.useCase = useCase
    }

    func fetchCountries() async {
        DispatchQueueManager.share.runOnMain {
            self.isLoading = true
        }
        
        defer {
            DispatchQueueManager.share.runOnMain {
                self.isLoading = false
            }
        }
        
        do {
            let cts =  try await useCase.execute()
            
            DispatchQueueManager.share.runOnMain {
                self.countries = cts
            }
            
        } catch {
            DispatchQueueManager.share.runOnMain {
                self.errorMessage = "Failed to load countries: \(error.localizedDescription)"
            }
            
        }
    }
    
    func setCountry(by country: Country) {
        self.countrySelected = country
    }
}
