//
//  EventLocalDataRepository.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

protocol EventLocalDataRepository {
    func fetchEvents() async throws -> [EventLocalData]
    func addEvent(event: EventLocalData) async throws
    func deleteEvent(_ event: EventLocalData) async throws
    func isEventExists(idEvent: String?, eventName: String?) -> Bool
}
