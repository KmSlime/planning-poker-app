//
//  WelcomeViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/21/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    
    
    // MARK: - Properties
    
    
    // MARK: - Overrides
    
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let SignUp = SignUpViewController()
        navigationController?.pushViewController(SignUp, animated: true)
    }
    
    
    // MARK: - Publics
    
    
    // MARK: - Private
    
    
    // MARK: - Actions


}

//extension WelcomeViewController: UITableViewDataSource {
//}
