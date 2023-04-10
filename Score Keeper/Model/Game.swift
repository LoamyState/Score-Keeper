//
//  Game.swift
//  Score Keeper
//
//  Created by J Madsen on 3/28/23.
//

import Foundation


struct Game: Codable, Equatable {
    
    var id = UUID()
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
    
    static func ==(lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }
    
    static let archiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("game").appendingPathExtension(".plist")
    
    static func saveToFile(games: [Game]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedScoreboard = try? propertyListEncoder.encode(games)
            
        do {
            try encodedScoreboard?.write(to: Game.archiveURL, options: .noFileProtection)
            print("Game saved!")
        } catch {
            print(error)
        }
    }
    
    static func loadFromFile() -> [Game]? {
        guard let retrievedScoreboardData = try? Data(contentsOf: Game.archiveURL) else { return [] }
        
        let propertyListDecoder = PropertyListDecoder()
        guard let decodedScoreboard = try? propertyListDecoder.decode(Array<Game>.self, from: retrievedScoreboardData) else { return nil }
        
        print("Loaded games!")
        return decodedScoreboard
    }
}
