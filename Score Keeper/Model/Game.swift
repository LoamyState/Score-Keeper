//
//  Game.swift
//  Score Keeper
//
//  Created by J Madsen on 3/28/23.
//

import Foundation


struct Game: Codable {
    var title: String
    var sort: SortOrder
    var winnerSort: SortOrder
    var winner: Player? {
        guard players.isEmpty == false else { return nil }
        
        switch winnerSort {
        case .forward:
            return players.max()
        case .reverse:
            return players.min()
        }
    }
    var players: [Player]
    
    static let archiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("game").appendingPathExtension(".plist")
    
    static func saveToFile(game: Game) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedScoreboard = try? propertyListEncoder.encode(game)
            
        do {
            try encodedScoreboard?.write(to: Game.archiveURL, options: .noFileProtection)
        } catch {
            print(error)
        }
    }
    
    static func loadFromFile() -> Game? {
        guard let retrievedScoreboardData = try? Data(contentsOf: Game.archiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        guard let decodedScoreboard = try? propertyListDecoder.decode(Game.self, from: retrievedScoreboardData) else { return nil }
        
        return decodedScoreboard
    }
}
