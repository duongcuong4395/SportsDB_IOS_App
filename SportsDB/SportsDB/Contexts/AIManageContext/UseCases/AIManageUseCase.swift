//
//  AIManageUseCase.swift
//  SportsDB
//
//  Created by Macbook on 13/8/25.
//

protocol AIManageUseCaseProtocol {
    func addData(_ data: AISwiftData) async throws
    //func addKey(_ key: String) async throws -> Bool
    func updateKey(_ data: AISwiftData, by newkey: String) async throws
    func getData(by itemKey: String) async -> AISwiftData?
}


class AIManageUseCase: AIManageUseCaseProtocol {
    func updateKey(_ data: AISwiftData, by newkey: String) async throws {
        try await repository.updateKey(data, by: newkey)
    }
    
    let repository: AISwiftDataRepositoryProtocol
    init(repository: AISwiftDataRepositoryProtocol) {
        self.repository = repository
    }
    
    func addData(_ data: AISwiftData) async throws {
        try await repository.addData(data)
    }
    
    func getData(by itemKey: String) async -> AISwiftData? {
        await repository.getData(by: itemKey)
    }
    
    
}
