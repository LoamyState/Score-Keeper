//
//  GameTableViewController.swift
//  Score Keeper
//
//  Created by J Madsen on 3/22/23.
//

import UIKit

protocol PlayersTableViewControllerDelegate {
    func updateGamesList(game: Game)
}

class PlayersTableViewController: UITableViewController, PlayerTableViewCellDelegate {
    
    var delegate: PlayersTableViewControllerDelegate
    var game: Game {
        didSet {
            delegate.updateGamesList(game: game)
        }
    }
    
    init?(game: Game, delegate: PlayersTableViewControllerDelegate, coder: NSCoder) {
        self.game = game
        self.delegate = delegate
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("Initializer not implemented!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = game.title

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        print("Loaded 1 section")
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Loaded \(game.players.count) rows")

        return game.players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell

        let player = game.players[indexPath.row]
        cell.player = player
        cell.indexPath = indexPath
        cell.delegate = self
        
        print("Created cell for row at \(indexPath.row) with player \(player.name)")
        
        return cell
    }
 
    func updatePlayerValue(player: Player?, indexPath: IndexPath?) {
        guard let player, let indexPath else { return }
        
        print("Updating player value at \(indexPath.row)")
        game.players[indexPath.row] = player
        tableView.reloadData()

    }
    
    
    @IBSegueAction func editGameSegue(_ coder: NSCoder) -> AddEditGameViewController? {
        guard let viewController = AddEditGameViewController(game: game, coder: coder) else { return nil }
        viewController.navigationItem.title = "Editing \(game.title)"
        return viewController
    }
    
    
    @IBAction func unwindToScoreboardTableViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "cancelUnwind", let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
        }
        
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditPlayerTableViewController else { return }
        
        let player = sourceViewController.player

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            game.players[selectedIndexPath.row] = player
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            print("Returned from edit screen, changed player at \(selectedIndexPath.row) and updated that row")
        } else {
            let newIndexPath = IndexPath(row: game.players.count, section: 0)
            game.players.append(player)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            print("New player added at \(newIndexPath.row)")
        }
        
        tableView.reloadData()
    }
    
    

}
