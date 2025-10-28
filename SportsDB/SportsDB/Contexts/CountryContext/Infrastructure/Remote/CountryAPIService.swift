//
//  CountryAPIService.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

import Foundation
import Networking

final class CountryAPIService: CountryRepository, APIExecution {
    
    func getAllCountries() async throws -> [Country] {
        let response: CountriesAPIResponse = try await sendRequest(for: CountryEndPoint<CountriesAPIResponse>.GetCountries)
        return response.countries.compactMap { $0.toDomain() }
    }
}


