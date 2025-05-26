//
//  CountryRepository.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// CountryContext/Application/Interfaces/CountryRepository.swift
protocol CountryRepository {
    func getAllCountries() async throws -> [Country]
}
