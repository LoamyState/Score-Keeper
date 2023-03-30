//
//  PlayerTableViewCell.swift
//  Score Keeper
//
//  Created by J Madsen on 3/22/23.
//

import UIKit

protocol PlayerTableViewCellDelegate {
    func updatePlayerValue(player: Player?, indexPath: IndexPath?)
}

class PlayerTableViewCell: UITableViewCell {
    
    var delegate: PlayerTableViewCellDelegate?
    var indexPath: IndexPath?

    @IBOutlet weak var playerIconImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreStepper: UIStepper!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    var player: Player? {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        guard let player else { return }
        
        playerIconImageView.tintColor = player.color
        playerNameLabel.text = player.name
        playerScoreStepper.value = Double(player.score)
        playerScoreLabel.text = String(player.score)
    }
    
    @IBAction func playerScoreChanged(_ sender: UIStepper) {
        player?.score = Int(sender.value)
        delegate?.updatePlayerValue(player: player, indexPath: indexPath)
    }
    
}
