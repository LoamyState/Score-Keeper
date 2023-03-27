//
//  Player.swift
//  Score Keeper
//
//  Created by J Madsen on 3/22/23.
//

import Foundation
import UIKit

struct Player: Comparable, Equatable {
    var color: UIColor
    var name: String
    var score: Int

    static func < (lhs: Player, rhs: Player) -> Bool {
        lhs.score < rhs.score
    }
}

extension Player: Codable {
    enum CodingKeys: String, CodingKey {
        case color
        case name
        case score
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let colorData = try container.decode(Data.self, forKey: .color)
        color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor ?? UIColor.blue
        
        name = try container.decode(String.self, forKey: .name)
        
        score = try container.decode(Int.self, forKey: .score)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
        
        try container.encode(name, forKey: .name)
        
        try container.encode(score, forKey: .score)
    }
}

struct Scoreboard: Codable {
    var players: [Player]
    
    static let archiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("scoreboard").appendingPathExtension(".plist")
    
    static func saveToFile(scoreboard: Scoreboard) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedScoreboard = try? propertyListEncoder.encode(scoreboard)
            
        do {
            try encodedScoreboard?.write(to: Scoreboard.archiveURL, options: .noFileProtection)
        } catch {
            print(error)
        }
    }
    
    static func loadFromFile() -> Scoreboard? {
        guard let retrievedScoreboardData = try? Data(contentsOf: Scoreboard.archiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        guard let decodedScoreboard = try? propertyListDecoder.decode(Scoreboard.self, from: retrievedScoreboardData) else { return nil }
        
        return decodedScoreboard
    }
}
