//
//  CountryAPIService.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// CountryContext/Infrastructure/Remote/CountryAPIService.swift
final class CountryAPIService: CountryRepository, APIExecution {
    
    func getAllCountries() async throws -> [Country] {
        // Gọi API thông qua HttpRouter layer
       let response: CountriesAPIResponse = try await sendRequest(for: CountryEndPoint<CountriesAPIResponse>.GetCountries)
        // Mapping về domain
        return response.countries.compactMap { $0.toDomain() }
    }
}


