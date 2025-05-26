//
//  CountryDTO.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// CountryContext/Infrastructure/DataMapping/CountryDTO.swift
struct CountriesAPIResponse: Codable {
    let countries: [CountryDTO]
}

struct CountryDTO: Codable {
    let nameEn: String
    let flagURL32: String

    enum CodingKeys: String, CodingKey {
        case nameEn = "name_en"
        case flagURL32 = "flag_url_32"
    }

    func toDomain() -> Country? {
        guard let url = URL(string: flagURL32) else { return nil }
        return Country(name: nameEn, flagURL: url)
    }
}

