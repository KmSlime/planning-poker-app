//
//  SignUpViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/21/22.
//

import UIKit


class SignUpViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - Properties
    var messages: String?
    var status: Bool?
    var textFieldName: String?
    let arrayEmailValid: [String] = ["lala@gmail.com","lele@exit.com"] //TEST, sau thay dòng này bằng array API

    var newUser: User!
    var testSentData: String = "lalala gui sang welcome"
//
    // MARK: - Overrides
    
    
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponader()
        setupUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    // MARK: - Publics
    @objc func backToSignIn(recognizer:UIGestureRecognizer) {
        if recognizer.state == .ended {
            AppViewController.shared.pushToSignInScreen()
        }
    }

    //MARK: - SENDING DATA TO BE - HAVEN'T DONE YET
//    func register() -> User {
////        guard let emailTextField.text != nil && passwordTextField.text != nil && fullNameTextField.text != nil else { return nil }
////
//
//
//        //MARK: - api sending data to BE
//    }
//
    
    // MARK: - Private
    
    
    
    //MARK: - Setup UI
    private func setupUI(){
        
        //font
        emailTextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        passwordTextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        rePasswordTextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        fullNameTextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        
        //color
        signInLabel.textColor = UIColor.blueTextColor
        signUpButton.backgroundColor = UIColor.blueButtonColor
        emailTextField.layer.borderColor = UIColor.textFieldBorderColor
        passwordTextField.layer.borderColor = UIColor.textFieldBorderColor
        rePasswordTextField.layer.borderColor = UIColor.textFieldBorderColor
        fullNameTextField.layer.borderColor = UIColor.textFieldBorderColor
        
        //style
        passwordTextField.layer.borderWidth = 1
        emailTextField.layer.borderWidth = 1
        rePasswordTextField.layer.borderWidth = 1
        fullNameTextField.layer.borderWidth = 1
        
        //attribute
        passwordTextField.layer.cornerRadius = 4
        emailTextField.layer.cornerRadius = 4
        rePasswordTextField.layer.cornerRadius = 4
        fullNameTextField.layer.cornerRadius = 4
        
        //other
        navigationItem.hidesBackButton = true
    
    }
    
    private func onClickSignInButton() {
        let signInLabelOnClick = UITapGestureRecognizer(target: self, action: #selector(self.backToSignIn(recognizer:)))
        signInLabel.isUserInteractionEnabled = true
        signInLabel.addGestureRecognizer(signInLabelOnClick)
    }
    
   
    // MARK: - Actions
    @IBAction func signUp(_ sender: UIButton) {
        if hasErrorStatus().status == true {
            let title = "Error"
            let message = hasErrorStatus().messages
            showAlert(title: title, message: message)
        } else {
            newUser = User(id: arrayEmailValid.count + 1, email: emailTextField.text!, password: passwordTextField.text!, fullName: fullNameTextField.text!)
            AppViewController.shared.pushToWelcomeScreen(user: newUser)
        }
    }
    
}
    


// MARK: - extensions
extension SignUpViewController {
    
    //MARK: - Check field empty
    func fieldIsEmpty() -> (textFieldName: String?, status: Bool) {
        if emailTextField.text?.isEmpty == true {
            textFieldName = "Email"
            return (textFieldName, true)

        } else if passwordTextField.text?.isEmpty == true {
            textFieldName = "Password"
            return (textFieldName, true)

        } else if rePasswordTextField.text?.isEmpty == true {
            textFieldName = "Repeat Password"
            return (textFieldName, true)

        } else if fullNameTextField.text?.isEmpty == true {
            textFieldName = "Fullname"
            return (textFieldName, true)
        }
        return (nil, false)
    }

   
    //MARK: - Check exist email
    private func isExistEmail() -> Bool {
        for email in arrayEmailValid {
            if emailTextField.text == email {
                return true
            }
        }
        return false
    }
    
    
    //MARK: - Set status and message
    func hasErrorStatus() -> (messages: String?, status: Bool?) {
        // EmptyField
        if fieldIsEmpty().status  == true {
            messages = "\(fieldIsEmpty().textFieldName!) is required."
            status = true
            
        } else
        // Format Email
        if emailTextField.text?.isValidEmail == false {
            messages = "Please enter valid email."
            status = true

        } else
        // Existence Email
        if isExistEmail() == true {
            messages = "Email already exists."
            status = true

        } else
        // Format Password
        if passwordTextField.text?.isCorrectFormatPassword == false {
            messages = "Password doesn’t follow format."
            status = true

        } else
        // Not Match Password
        if rePasswordTextField.text?.isFieldMatch(with: passwordTextField.text!) == false {
            messages = "Password and Re-enter password don't match."
            status = true

        } else
        // Field Range
        if emailTextField.text!.count > 50 {
            textFieldName = "Email"
            messages = "\(textFieldName!) can't be longer than 50 character."
            status = true

        } else if passwordTextField.text!.count > 50 || passwordTextField.text!.count < 8  {
            textFieldName = "Password"
            messages = "\(textFieldName!) can't be less than 8 characters and longer than 50 characters."
            status = true

        } else if rePasswordTextField.text!.count > 50 || rePasswordTextField.text!.count < 8  {
            textFieldName = "Repeat Password"
            messages = "\(textFieldName!) can't be less than 8 characters and longer than 50 characters."
            status = true

        } else if fullNameTextField.text!.count > 50 {
            textFieldName = "Full name"
            messages = "\(textFieldName!) can't be longer than 50 character."
            status = true

        } else {
            return (nil, false)
        }
        return (messages, status)
    }
    
}

// MARK: - protocols

