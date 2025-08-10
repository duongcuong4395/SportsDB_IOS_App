//
//  EventLocalDataUseCase.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

protocol EventLocalDataUseCase {
    func getAllEvents() async throws -> [EventLocalData]
    func createEvent(event: EventLocalData) async throws
    func removeEvent(_ event: EventLocalData) async throws
    func isEventExists(idEvent: String?, eventName: String?) -> Bool
}

final class DefaultEventLocalDataUseCase: EventLocalDataUseCase {
    func isEventExists(idEvent: String?, eventName: String?) -> Bool {
        repository.isEventExists(idEvent: idEvent, eventName: eventName)
        
        
    }
    
    
    private let repository: EventLocalDataRepository

    init(repository: EventLocalDataRepository) {
        self.repository = repository
    }
    
    func getAllEvents() async throws -> [EventLocalData] {
        try await repository.fetchEvents()
    }
    
    func createEvent(event: EventLocalData) async throws {
        try await repository.addEvent(event: event)
    }
    
    func removeEvent(_ event: EventLocalData) async throws {
        try await repository.deleteEvent(event)
    }
    
    
}
