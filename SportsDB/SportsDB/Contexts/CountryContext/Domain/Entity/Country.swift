//
//  Country.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

import Foundation

enum ImageSize: String {
    case Min = "32"
    case Medium = "64"
}

// CountryContext/Domain/Entity/Country.swift
struct Country: Equatable {
    let name: String
    let flagURL: String
}

extension Country {
    func getFlag(by size: ImageSize) -> String {
        switch size {
        case .Min:
            return flagURL
        case .Medium:
            return flagURL.replacingOccurrences(of: "32", with: "64")
        }
    }
}

