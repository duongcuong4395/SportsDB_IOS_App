//
//  Status.swift
//  SportsDB
//
//  Created by Macbook on 7/6/25.
//

enum ModelsStatus<T> {
    case Idle
    case Progressing
    case Success(model: T)
    case Fail(message: String)
}

enum ExecuteStatus<T> {
    case Idle
    case Progressing
    case Success(model: T)
    case Fail(message: String)
}


import Foundation

@MainActor
final class AsyncStateHandler<T>: ObservableObject {
    @Published var executeStatus: ExecuteStatus<T> = .Idle
    var models: T? = nil

    func execute(
        delayIfNeeded: TimeInterval = 0.5,
        operation: @escaping () async throws -> T
    ) async {
        executeStatus = .Progressing
        let start = Date()
        
        do {
            let result = try await operation()
            models = result
            let elapsed = Date().timeIntervalSince(start)
            
            
            if elapsed < delayIfNeeded {
                try? await Task.sleep(nanoseconds: UInt64((delayIfNeeded - elapsed) * 500_000_000))
            }
            
            
            executeStatus = .Success(model: result)
        } catch {
            executeStatus = .Fail(message: error.localizedDescription)
        }
    }
    
    func reset() {
        executeStatus = .Idle
        models = nil
    }
}
