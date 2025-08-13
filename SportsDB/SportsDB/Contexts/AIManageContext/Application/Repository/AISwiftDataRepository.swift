//
//  AISwiftDataRepository.swift
//  SportsDB
//
//  Created by Macbook on 13/8/25.
//

import SwiftData
import Foundation

protocol AISwiftDataRepositoryProtocol {
    func addData(_ data: AISwiftData) async throws
    func updateKey(_ data: AISwiftData, by newkey: String) async throws
    func getData(by itemKey: String) async -> AISwiftData?
}

class AISwiftDataRepository: AISwiftDataRepositoryProtocol {
    func updateKey(_ data: AISwiftData, by newkey: String) async throws {
        data.valueItem = newkey
        try context.save()
    }
    
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func addData(_ data: AISwiftData) async throws {
        context.insert(data)
        try context.save()
    }
    
    func getData(by itemKey: String) async -> AISwiftData? {
        do {
            let predicate: Predicate<AISwiftData> = #Predicate {
                $0.itemKey == itemKey
            }
            
            let fetchDescriptor = FetchDescriptor<AISwiftData>(predicate: predicate)
            let res = try context.fetch(fetchDescriptor)
            return res.count > 0 ? res[0] : nil
        } catch {
            return nil
        }
    }
}
