//
//  AddEditGameTableViewController.swift
//  Score Keeper
//
//  Created by J Madsen on 3/29/23.
//

import UIKit

class AddEditGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var game: Game?
    var players: [Player] = []
    
    init?(game: Game?, coder: NSCoder) {
        self.game = game
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var gameTitleTextField: UITextField!
    @IBOutlet weak var sortBySegmentedControl: UISegmentedControl!
    @IBOutlet weak var winnerSortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var playerListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerListTableView.delegate = self
        playerListTableView.dataSource = self
        
        if let game {
            navigationItem.title = "Edit Game \(game.title)"
            gameTitleTextField.text = game.title
            sortBySegmentedControl.selectedSegmentIndex = game.sort == .forward ? 0 : 1
            winnerSortSegmentedControl.selectedSegmentIndex = game.winnerSort == .forward ? 0 : 1
            players = game.players
            }
    }
    
    @IBAction func checkGameTitle(_ sender: UITextField) {
    }
    
    func toggleSaveButton() {
        if gameTitleTextField.text != nil {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    
    @IBAction func doneEditingTitle(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
// Table View
    
    @IBSegueAction func addPlayer(_ coder: NSCoder, sender: Any?) -> AddEditPlayerTableViewController? {
        return AddEditPlayerTableViewController(coder: coder)
    }
    
    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> AddEditPlayerTableViewController? {
        guard let sender = sender as? PlayersEditorTableViewCell, let player = sender.player else { return nil }
        
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
            players[selectedIndexPath.row] = player
            playerListTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            print("Returned from edit screen, changed player at \(selectedIndexPath.row) and updated that row")
        } else {
            let newIndexPath = IndexPath(row: players.count, section: 0)
            players.append(player)
            playerListTableView.insertRows(at: [newIndexPath], with: .automatic)
            print("New player added at \(newIndexPath.row)")
        }
        
        playerListTableView.reloadData()
    }
    
    
    // Configure table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell") as! PlayersEditorTableViewCell
        
        let player = players[indexPath.row]
        
        cell.player = player
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveGame" else { return }
        
        let title = gameTitleTextField.text ?? "Error"
        let sort = sortBySegmentedControl.selectedSegmentIndex == 0 ? SortOrder.forward : SortOrder.reverse
        let winnerSort = winnerSortSegmentedControl.selectedSegmentIndex == 0 ? SortOrder.forward : SortOrder.reverse
        
        if game != nil {
            game?.title = title
            game?.sort = sort
            game?.winnerSort = winnerSort
            game?.players = players
        } else {
            game = Game(title: title, sort: sort, winnerSort: winnerSort, players: players)
        }
    }
    
}
