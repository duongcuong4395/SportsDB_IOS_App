//
//  EventSwiftDataUseCase.swift
//  SportsDB
//
//  Created by Macbook on 10/8/25.
//

import SwiftUI
import SwiftData

protocol EventSwiftDataUseCaseProtocol {
    func getAllEvents() async throws -> [EventSwiftData]
    func createEvent(event: EventSwiftData) async throws
    func removeEvent(_ event: EventSwiftData) async throws
    func isEventExists(idEvent: String?, eventName: String?) -> (isExists: Bool, event: EventSwiftData?)
    func filter(by searchText: String, with sortOption: SortOption) async throws -> [EventSwiftData]
}

final class EventSwiftDataUseCase: EventSwiftDataUseCaseProtocol {
    
    
    private let repository: EventSwiftDataRepositoryProtocol
    
    init(repository: EventSwiftDataRepositoryProtocol) {
        self.repository = repository
    }
    
    func filter(by searchText: String, with sortOption: SortOption) async throws -> [EventSwiftData] {
        try await repository.filter(by: searchText, with: sortOption)
    }
    
    func getAllEvents() async throws -> [EventSwiftData] {
        try await repository.fetchEvents()
    }
    
    func createEvent(event: EventSwiftData) async throws {
        try await repository.addEvent(event: event)
    }
    
    func removeEvent(_ event: EventSwiftData) async throws {
        try await repository.deleteEvent(event)
    }
    
    func isEventExists(idEvent: String?, eventName: String?) -> (isExists: Bool, event: EventSwiftData?) {
        repository.isEventExists(idEvent: idEvent, eventName: eventName)
    }
    
    
}
