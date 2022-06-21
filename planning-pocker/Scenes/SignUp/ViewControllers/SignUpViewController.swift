//
//  SignUpViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/21/22.
//

import UIKit


class SignUpViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var SignInLabel: UILabel!
    
    // MARK: - Properties


    // MARK: - Overrides


    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let SignInLabelOnClick = UITapGestureRecognizer(target: self, action: #selector(self.usrChose1(recognizer:)))
        SignInLabel.isUserInteractionEnabled = true
        SignInLabel.addGestureRecognizer(SignInLabelOnClick)
        

    }
    
    
    // MARK: - Publics

    @objc func usrChose1(recognizer:UIGestureRecognizer)  {
        if recognizer.state == .ended {
                             print("Choice1 tapped")
            let SignInCV = SignInViewController()
            navigationController?.pushViewController(SignInCV, animated: true)
//            AppViewController.shared.pushToSignInScreen()

            // action when user tapped label 1
        }
    }
//
//    @objc func backToSignIn(sender:UITapGestureRecognizer){
//        AppViewController.shared.pushToSignInScreen()
//    }
//
    
 

    // MARK: - Private


    // MARK: - Actions


    

}

// MARK: - extensions



// MARK: - protocols
