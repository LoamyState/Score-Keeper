//
//  GamesListTableViewController.swift
//  Score Keeper
//
//  Created by J Madsen on 3/28/23.
//

import UIKit

class GamesListTableViewController: UITableViewController, PlayersTableViewControllerDelegate {
    
    var games: [Game] = [] {
        didSet {
            Game.saveToFile(games: games)
        }
    }
    
    func updateGamesList(game: Game) {
        guard let index = games.firstIndex(of: game) else { return }
        games[index] = game
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedGames = Game.loadFromFile() {
            games = loadedGames
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        
        let game = games[indexPath.row]
        
        cell.game = game
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if tableView.isEditing {
            performSegue(withIdentifier: "editGame", sender: tableView.cellForRow(at: indexPath))
        } else {
            performSegue(withIdentifier: "displaySelectedGame", sender: tableView.cellForRow(at: indexPath))
        }
        
    }
    
    @IBSegueAction func addNewGame(_ coder: NSCoder) -> AddEditGameViewController? {
        return AddEditGameViewController(game: nil, coder: coder)
    }
    
    
    @IBSegueAction func editGame(_ coder: NSCoder, sender: Any?) -> AddEditGameViewController? {
        guard let sender = sender as? GameTableViewCell, let game = sender.game else { return nil }
        
        return AddEditGameViewController(game: game, coder: coder)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            games.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBSegueAction func displaySelectedGame(_ coder: NSCoder, sender: Any?) -> PlayersTableViewController? {
        guard let sender = sender as? GameTableViewCell, let game = sender.game else { return nil }
        
        return PlayersTableViewController(game: game, delegate: self, coder: coder)
    }
    
    @IBAction func unwindToGamesList(segue: UIStoryboardSegue) {
        if segue.identifier == "cancelNewGame", let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
        }
        
        guard segue.identifier == "saveGame", let sourceViewController = segue.source as? AddEditGameViewController else {
            print("Performed unwindToGamesList() with unknown identifier")
            return
        }
        
        guard let game = sourceViewController.game else { return }
        
        if let indexPathForGame = games.firstIndex(of: game) {
            let selectedIndexPath = IndexPath(row: indexPathForGame, section: 0)
            games[indexPathForGame] = game
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            print("Returned from game edit screen, changed game at \(selectedIndexPath.row) and updated that row")
        } else {
            let newIndexPath = IndexPath(row: games.count, section: 0)
            games.append(game)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            print("New game added at \(newIndexPath.row)")
            performSegue(withIdentifier: "displaySelectedGame", sender: tableView.cellForRow(at: newIndexPath))
        }
        
    }
}
