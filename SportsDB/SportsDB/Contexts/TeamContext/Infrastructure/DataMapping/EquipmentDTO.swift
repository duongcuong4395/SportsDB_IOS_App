//
//  TeamEquipmentDTO.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//



// MARK: - Equipment
struct EquipmentDTO: Codable {
    var idEquipment, idTeam, date, season: String
    var equipment: String
    var type: String
    var username: String
    
    enum CodingKeys: String, CodingKey {
        case idEquipment, idTeam, date, season = "strSeason"
        case equipment = "strEquipment"
        case type = "strType"
        case username = "strUsername"
    }
    
    func toDomain() -> Equipment {
        Equipment(idEquipment: idEquipment, idTeam: idTeam, date: date, season: season, equipment: equipment, type: type, username: username)
    }
}
