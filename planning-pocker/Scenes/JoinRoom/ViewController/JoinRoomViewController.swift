//
//  JoinRoomViewController.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 13/07/2022.
//

import UIKit

class JoinRoomViewController: UIViewController {

    @IBAction func backButton(_ sender: UIButton) {
        AppViewController.shared.popToPreviousScreen()
    }
    @IBOutlet weak var popUpView: UIView! {
        didSet {
            popUpView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var joinRoomButton: UIButton! {
        didSet {
            joinRoomButton.addTarget(self, action: #selector(joinRoom), for: .touchUpInside)
        }
    }
    @IBOutlet weak var urlTextField: UITextField! {
        didSet {
            urlTextField.placeholder = "Enter game ID to join"
            urlTextField.text = ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SocketIOManager.sharedInstance.unknownUrl {
            self.showAlert(title: "Fail", message: "Room ID is not found") { _ in
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func joinRoom() {
        let text: String = urlTextField.text!
        SocketIOManager.sharedInstance.enterJoinRoom(roomId: text, userId: Int.random(in: 1 ... 1000))
    }
}
