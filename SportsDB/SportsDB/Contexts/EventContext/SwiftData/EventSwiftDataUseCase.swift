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
    func getEvent(by idEvent: String?, or eventName: String?) async -> EventSwiftData?
    func filter(by searchText: String, with sortOption: SortOption) async throws -> [EventSwiftData]
    
    func toggleLike(_ event: EventSwiftData) async throws -> EventSwiftData
    func setNotification(_ event: EventSwiftData, by status: NotificationStatus) async throws
}

final class EventSwiftDataUseCase: EventSwiftDataUseCaseProtocol {
    func setNotification(_ event: EventSwiftData, by status: NotificationStatus) async throws {
        try await repository.setNotification(event, by: status)
    }
    
    func toggleLike(_ event: EventSwiftData) async throws -> EventSwiftData {
        try await repository.toggleLike(event)
    }
    
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
    
    func getEvent(by idEvent: String?, or eventName: String?) async -> EventSwiftData? {
        return await repository.getEvent(by: idEvent, or: eventName)
    }
}
