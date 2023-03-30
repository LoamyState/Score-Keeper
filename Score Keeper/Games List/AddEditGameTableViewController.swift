//
//  AddEditGameTableViewController.swift
//  Score Keeper
//
//  Created by J Madsen on 3/29/23.
//

import UIKit

class AddEditGameTableViewController: UITableViewController {
    
    var game: Game
    
    init?(game: Game, coder: NSCoder) {
        self.game = game
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.game = Game(title: "", sort: .forward, winnerSort: .forward, players: [])
        super.init(coder: coder)
    }
    
    @IBOutlet weak var playerListTableView: AddEditGamePlayerListTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerListTableView.players = game.players
    }
    
    @IBSegueAction func addPlayer(_ coder: NSCoder, sender: Any?) -> AddEditPlayerTableViewController? {
        return AddEditPlayerTableViewController(coder: coder)
    }
    
    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> AddEditPlayerTableViewController? {
        guard let sender = sender as? PlayerTableViewCell, let player = sender.player else { return nil }
        
        print("Editing player \(player.name)")
        return AddEditPlayerTableViewController(coder: coder, player: player)
    }
    
    @IBAction func unwindToAddEditGameTableView(segue: UIStoryboardSegue) {
        if segue.identifier == "cancelPlayer", let selectedIndexPath = playerListTableView.indexPathForSelectedRow {
            playerListTableView.deselectRow(at: selectedIndexPath, animated: false)
        }
        
        guard segue.identifier == "savePlayer",
              let sourceViewController = segue.source as? AddEditPlayerTableViewController else { return }
        
        let player = sourceViewController.player

        if let selectedIndexPath = playerListTableView.indexPathForSelectedRow {
            game.players[selectedIndexPath.row] = player
            playerListTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            print("Returned from edit screen, changed player at \(selectedIndexPath.row) and updated that row")
        } else {
            let newIndexPath = IndexPath(row: game.players.count, section: 0)
            game.players.append(player)
            playerListTableView.insertRows(at: [newIndexPath], with: .automatic)
            print("New player added at \(newIndexPath.row)")
        }
        
        playerListTableView.reloadData()
    }
    
}
