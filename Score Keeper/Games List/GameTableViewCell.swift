//
//  GameTableViewCell.swift
//  Score Keeper
//
//  Created by J Madsen on 3/29/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var currentWinnerLabel: UILabel!
    
    var game: Game? {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        guard let game else { return }
        
        gameTitleLabel.text = game.title
        currentWinnerLabel.text = game.winner?.name ?? "None"
    }
    
}
