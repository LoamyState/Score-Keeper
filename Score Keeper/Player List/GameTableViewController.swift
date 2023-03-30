//
//  GameTableViewController.swift
//  Score Keeper
//
//  Created by J Madsen on 3/22/23.
//

import UIKit

class GameTableViewController: UITableViewController, PlayerTableViewCellDelegate {
    
    var game: Game {
        didSet {
            game.players.sort()
            Game.saveToFile(game: game)
            print("Updated game, saving to file")
        }
    }
    
    init?(game: Game, coder: NSCoder) {
        self.game = game
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        self.game = Game(title: "", sort: .forward, winnerSort: .forward, players: [])
        super.init(coder: coder)
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
    
//    @IBSegueAction func addPlayer(_ coder: NSCoder, sender: Any?) -> AddEditPlayerTableViewController? {
//        return AddEditPlayerTableViewController(coder: coder)
//    }
//
//    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> AddEditPlayerTableViewController? {
//        guard let sender = sender as? PlayerTableViewCell, let player = sender.player else { return nil }
//
//        print("Editing player \(player.name)")
//        return AddEditPlayerTableViewController(coder: coder, player: player)
//    }
    
    func updatePlayerValue(player: Player?, indexPath: IndexPath?) {
        guard let player, let indexPath else { return }
        
        print("Updating player value at \(indexPath.row)")
        game.players[indexPath.row] = player
        tableView.reloadData()

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
