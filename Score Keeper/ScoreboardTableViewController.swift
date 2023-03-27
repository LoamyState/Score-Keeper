//
//  ScoreboardTableViewController.swift
//  Score Keeper
//
//  Created by J Madsen on 3/22/23.
//

import UIKit

class ScoreboardTableViewController: UITableViewController, PlayerTableViewCellDelegate {
    
    var scoreboard = Scoreboard(players: [Player(color: .red, name: "Test", score: 123)]) {
        didSet {
            scoreboard.players.sort()
            Scoreboard.saveToFile(scoreboard: scoreboard)
            print("Updated Scoreboard, saving to file")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scoreboard = Scoreboard.loadFromFile() {
            self.scoreboard = scoreboard
        } else {
            print("Failed to load scoreboard")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        print("Loaded 1 section")
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Loaded \(scoreboard.players.count) rows")

        return scoreboard.players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell

        let player = scoreboard.players[indexPath.row]
        cell.player = player
        cell.indexPath = indexPath
        cell.delegate = self
        
        print("Created cell for row at \(indexPath.row) with player \(player.name)")
        
        return cell
    }
    
    @IBAction func enableEditingMode(_ sender: UIBarButtonItem) {
            let tableViewEditingMode = tableView.isEditing
            
            tableView.setEditing(!tableViewEditingMode, animated: true)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            scoreboard.players.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBSegueAction func addPlayer(_ coder: NSCoder, sender: Any?) -> AddEditPlayerTableViewController? {
        return AddEditPlayerTableViewController(coder: coder)
    }
    
    
    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> AddEditPlayerTableViewController? {
        guard let sender = sender as? PlayerTableViewCell else { return AddEditPlayerTableViewController(coder: coder) }
        
        let player = sender.player
        print("Editing player \(player?.name ?? "unknown")")
        return AddEditPlayerTableViewController(coder: coder, player: player)
    }
    
    func updatePlayerValue(player: Player?, indexPath: IndexPath?) {
        guard let player, let indexPath else { return }
        
        print("Updating player value at \(indexPath.row)")
        scoreboard.players[indexPath.row] = player
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
            scoreboard.players[selectedIndexPath.row] = player
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            print("Returned from edit screen, changed player at \(selectedIndexPath.row) and updated that row")
        } else {
            let newIndexPath = IndexPath(row: scoreboard.players.count, section: 0)
            scoreboard.players.append(player)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            print("New player added at \(newIndexPath.row)")
        }
        
        tableView.reloadData()
    }

}
