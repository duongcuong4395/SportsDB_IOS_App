//
//  AIModel.swift
//  SportsDB
//
//  Created by Macbook on 13/8/25.
//

struct AIModel: Codable {
    var itemKey: String
    var valueItem: String
    
    enum CodingKeys: String, CodingKey {
        case itemKey = "itemKey"
        case valueItem = "valueItem"
    }
    
    init() {
        self.itemKey = ""
        self.valueItem = ""
    }
    
    init(itemKey: String, valueItem: String) {
        self.itemKey = itemKey
        self.valueItem = valueItem
    }
    
    func toAISwiftData() -> AISwiftData {
        AISwiftData(itemKey: itemKey, valueItem: valueItem)
    }
}
