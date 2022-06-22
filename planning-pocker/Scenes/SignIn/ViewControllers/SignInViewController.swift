//
//  SignInViewController.swift
//  planning-pocker
//
//  Created by Hiep on 22/06/2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    @IBAction func SignIn(_ sender: Any) {
        checkFields()
        
        
    }
    
    
    // MARK: - Properties
    
    
    // MARK: - Overrides
    
    
    
    
    // MARK: - Publics
    
    //    func checkLength() -> Bool{
    //
    //
    //    }
    func checkFields() -> Bool {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            if emailTextField.text?.isValidEmail != nil && passwordTextField.text?.isValidPassword != nil {
                
                showAlert(title: "Notify", message: "Login successfully")
                return true
            }
            else{
                showAlert(title: "Notify", message: "Invalid email or password")
                return false
            }
        }
          else if emailTextField.text == "" && passwordTextField.text != ""{
            showAlert(title: "Notify", message: "Please enter valid email ")
            return false
        } else if emailTextField.text != "" && passwordTextField.text == "" {
            showAlert(title: "Notify", message: "Please enter valid password")
            return false
        }
        else {
            showAlert(title: "Notify", message: "Please enter email and password")
            return false
        }
    }
    
    
    // MARK: - Private
    
    private func setupUI() {
        signInLabel.text = "Sign in"
        signInLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        
        emailTextField.layer.borderColor = UIColor(hexString: "#707070").cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 5
        
        passwordTextField.layer.borderColor = UIColor(hexString: "#707070").cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 5
        
        signInButton.layer.cornerRadius = 5
        
        navigationItem.hidesBackButton = true
    }
    
    //MARK: - Validation
}


// MARK: - extensions



// MARK: - protocols

