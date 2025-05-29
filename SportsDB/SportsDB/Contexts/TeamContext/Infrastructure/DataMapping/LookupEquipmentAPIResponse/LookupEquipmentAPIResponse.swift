//
//  LookupTeamEquipmentAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct LookupEquipmentAPIResponse: Codable {
    var equipments: [EquipmentDTO]?
    
    enum CodingKeys: String, CodingKey {
        case equipments = "equipment"
    }
}
