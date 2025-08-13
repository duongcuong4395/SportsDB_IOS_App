//
//  AISwiftData.swift
//  SportsDB
//
//  Created by Macbook on 13/8/25.
//

import SwiftData

@Model
class AISwiftData {
    var itemKey: String
    var valueItem: String
    
    init(itemKey: String, valueItem: String) {
        self.itemKey = itemKey
        self.valueItem = valueItem
    }
}
