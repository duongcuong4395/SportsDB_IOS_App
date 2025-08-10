//
//  SwiftDataRepository.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//
import SwiftData
import Foundation

final class SwiftDataEventRepository: EventLocalDataRepository {
    func isEventExists(idEvent: String?, eventName: String?) -> Bool {
        return true
    }
    
    func fetchEvents() async throws -> [EventLocalData] {
        let descriptor = FetchDescriptor<EventLocalData>(sortBy: [SortDescriptor(\.eventName, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func addEvent(event: EventLocalData) async throws {
        //let book = Book(title: title)
        context.insert(event)
    }
    
    func deleteEvent(_ event: EventLocalData) async throws {
        context.delete(event)
    }
    
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }
}
