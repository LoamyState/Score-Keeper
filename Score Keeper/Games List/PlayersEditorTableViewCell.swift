//
//  PlayersEditorTableViewCell.swift
//  Score Keeper
//
//  Created by J Madsen on 3/30/23.
//

import UIKit

class PlayersEditorTableViewCell: UITableViewCell {

    @IBOutlet weak var playerIconImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    var player: Player? {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        guard let player else { return }
        
        playerIconImageView.tintColor = player.color
        playerNameLabel.text = player.name
    }
    
}
