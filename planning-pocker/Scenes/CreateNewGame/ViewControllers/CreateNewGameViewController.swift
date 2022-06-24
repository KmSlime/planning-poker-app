//
//  CreateNewGameViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/22/22.
//

import UIKit

class CreateNewGameViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var votingSystemTextField: UITextField!
    @IBOutlet weak var gameNameTextField: UITextField!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var createGameButton: UIButton!
    @IBOutlet weak var joinGameButton: UIButton!
    
    // MARK: - Properties
    var messages: String?
    var status: Bool?


    // MARK: - Overrides


    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

    // MARK: - Publics
    
    func alertShowIfError(message: String?){
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil) //this is handle event when click, ex: confirm or cancel
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil) //show

    }


    // MARK: - Private
    private func setupUI(){
        
    }


    // MARK: - Actions

    @IBAction func createNewGame(_ sender: Any) {
        if hasErrorStatus().status == true {
        
        }
    }
    
}
    // MARK: - extensions
extension CreateNewGameViewController {

    //MARK: - Check Validation of Game's Name
    private func hasErrorStatus() -> (messages: String?, status: Bool?) {
        
        if gameNameTextField.text!.isEmpty{
            messages = "Game’s name is required."
            status = true
        } else if gameNameTextField.text!.count > 50 {
            messages = "Game’s name is less than 50."
            status = true
        } else {
            messages = nil
            status = false
        }
        return (messages, status)
    }
    
    

}


    // MARK: - protocols
