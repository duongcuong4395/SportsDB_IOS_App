//
//  GetAllCountriesUseCase.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// CountryContext/Application/UseCases/GetAllCountriesUseCase.swift
struct GetAllCountriesUseCase {
    let repository: CountryRepository

    func execute() async throws -> [Country] {
        return try await repository.getAllCountries()
    }
}
