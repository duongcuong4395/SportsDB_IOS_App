//
//  EventUseCase.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import Foundation

protocol ToggleLikeUseCaseProtocol {
    func execute(_ event: Event) async -> Event
}

protocol ToggleNotificationUseCaseProtocol {
    func execute(_ event: Event, into listNotificationItem: [NotificationItem]) async -> Event
}

protocol EventOnAppearUseCaseProtocol {
    func execute(_ event: Event) async -> Event
}

protocol FetchEventsUseCaseProtocol {
    func execute() async -> Result<[Event], Error>
}

final class ToggleLikeUseCase: ToggleLikeUseCaseProtocol {
    let eventSwiftDataRepository: EventSwiftDataRepositoryProtocol
    
    init(eventSwiftDataRepository: EventSwiftDataRepositoryProtocol) {
        self.eventSwiftDataRepository = eventSwiftDataRepository
    }
    
    func execute(_ event: Event) async -> Event {
        var copy = event
        
        let eventSwiftData = await eventSwiftDataRepository.getEvent(by: event.idEvent, or: event.eventName)
        
        // check event saved into SwiftData
        if let eventSwiftData = eventSwiftData {
            // toggle for like(field) of event exists
            eventSwiftData.like.toggle()
            do {
                try eventSwiftDataRepository.saveEvent()
                copy.like.toggle()
                return copy
            } catch {
                return copy
            }
        } else {
            // add new event into swiftdata
            copy.like = true
            Task {
                try await eventSwiftDataRepository.addEvent(event: copy.toEventSwiftData(with: .idle))
                return copy
            }
        }
        return copy
    }
    
    
}

final class ToggleNotificationUseCase: ToggleNotificationUseCaseProtocol {
    let eventSwiftDataRepository: EventSwiftDataRepositoryProtocol
    let eventNotificationRepository: EventNotificationRepositoryProtocol
    
    init(eventSwiftDataRepository: EventSwiftDataRepositoryProtocol, eventNotificationRepository: EventNotificationRepositoryProtocol) {
        self.eventSwiftDataRepository = eventSwiftDataRepository
        self.eventNotificationRepository = eventNotificationRepository
    }
    
    func execute(_ event: Event, into listNotificationItem: [NotificationItem]) async -> Event {
        var copy = event
        // check author
        Task {
            let noti = await eventNotificationRepository.getNotification(for: event.idEvent ?? "", into: listNotificationItem)
            
            let eventSwiftData = await eventSwiftDataRepository.getEvent(by: event.idEvent, or: event.eventName)
            
            // check noti exist
            if let noti = noti {
                 await eventNotificationRepository.removeNotification(for: noti.id)
                
                copy.notificationStatus = .idle
                if let eventSwiftData = eventSwiftData {
                    eventSwiftData.notificationStatus = copy.notificationStatus.rawValue
                    try eventSwiftDataRepository.saveEvent()
                } else {
                    try await eventSwiftDataRepository.addEvent(event: copy.toEventSwiftData(with: copy.notificationStatus))
                }
                return copy
            } else {
                await eventNotificationRepository.addNotification(copy)
                
                copy.notificationStatus = .creeated
                if let eventSwiftData = eventSwiftData {
                    eventSwiftData.notificationStatus = copy.notificationStatus.rawValue
                    try eventSwiftDataRepository.saveEvent()
                } else {
                    try await eventSwiftDataRepository.addEvent(event: copy.toEventSwiftData(with: copy.notificationStatus))
                }
                return copy
            }
        }
        return copy
    }
    
    
}
