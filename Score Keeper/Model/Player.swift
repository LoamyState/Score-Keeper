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


