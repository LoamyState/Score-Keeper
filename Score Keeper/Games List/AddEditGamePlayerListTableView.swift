//
//  AddEditGamePlayerListController.swift
//  Score Keeper
//
//  Created by J Madsen on 3/29/23.
//

import UIKit

class AddEditGamePlayerListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var players: [Player] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell") as! PlayerTableViewCell
        
        let player = players[indexPath.row]
        
        cell.player = player
        
        return cell
    }
    
    
}
