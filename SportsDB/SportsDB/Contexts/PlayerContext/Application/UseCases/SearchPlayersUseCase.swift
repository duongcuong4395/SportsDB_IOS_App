//
//  SearchPlayersUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct SearchPlayersUseCase {
    let repository: PlayerRepository
    
    func execute(playerName: String) async throws -> [Player] {
        try await repository.searchPlayers(playerName: playerName)
    }
}
