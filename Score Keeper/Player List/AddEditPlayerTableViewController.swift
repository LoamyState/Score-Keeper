//
//  AddEditPlayerTableViewController.swift
//  Score Keeper
//
//  Created by J Madsen on 3/22/23.
//

import UIKit

class AddEditPlayerTableViewController: UITableViewController {
    
    var player: Player {
        didSet {
            print("Player struct updated!")
        }
    }
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerColorWell: UIColorWell!
    @IBOutlet weak var playerScoreTextField: UITextField!
    @IBOutlet weak var playerScoreStepper: UIStepper!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    init?(coder: NSCoder, player: Player) {
        self.player = player
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.player = Player(color: .blue, name: "", score: 0)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
        playerColorWell.addTarget(self, action: #selector(changePlayerColor(_:)), for: .valueChanged)
    }
    
    func updateUI() {
        print("Updating UI...")
        playerNameTextField.text = player.name
        playerColorWell.selectedColor = player.color
        playerScoreTextField.text = "\(player.score)"
        playerScoreStepper.value = Double(player.score)
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        if player.name != "" {
            saveButton.isEnabled = true
            print("Save button enabled")
        } else {
            saveButton.isEnabled = false
            print("Save button disabled")
        }
    }
    
    @IBAction func changePlayerName(_ sender: UITextField) {
        print("Player name changed")
        player.name = sender.text ?? ""
        updateSaveButtonState()
    }
    
    @objc func changePlayerColor(_ sender: Any) {
        print("Player color changed")
        player.color = playerColorWell.selectedColor ?? .blue
    }
    
    @IBAction func changePlayerScore(_ sender: UIStepper) {
        print("Player score changed with stepper")
        player.score = Int(sender.value)
        playerScoreTextField.text = String(player.score)
    }
    
    @IBAction func changePlayerScoreWithText(_ sender: UITextField) {
        print("Player score changed with textfield")
        guard let input = Int(sender.text ?? "") else {
            sender.text = ""
            return
        }
        player.score = input
        playerScoreStepper.value = Double(player.score)
    }
    
}
