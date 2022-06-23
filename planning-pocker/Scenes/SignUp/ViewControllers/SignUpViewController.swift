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
    @IBOutlet weak var SignInLabel: UILabel!
    
    // MARK: - Properties
    var countClickSignUpTime: Int?
    var messages: String?
    var status: Bool?
    var textFieldName: String?
    let arrayEmailValid: [String] = ["lala@gmail.com","lele@exit.com"]
    
    // MARK: - Overrides
    
    
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        countClickSignUpTime = 0

    }
    
    override func viewWillAppear(_ animated: Bool) {
        OnClickSignInButton()
    }
    
    
    // MARK: - Publics
    func OnClickSignInButton(){
        let SignInLabelOnClick = UITapGestureRecognizer(target: self, action: #selector(self.backToSignIn(recognizer:)))
        SignInLabel.isUserInteractionEnabled = true
        SignInLabel.addGestureRecognizer(SignInLabelOnClick)
    }
    
    @objc func backToSignIn(recognizer:UIGestureRecognizer) {
        if recognizer.state == .ended {
            print("Log Login: Click back to Sign In")
            AppViewController.shared.pushToSignInScreen()
        }
    }
   
    
    //MARK: - AlertAction
    func alertShowIfError(message: String?){
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil) //this is handle event when click, ex: confirm or cancel
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil) //show

    }

    //MARK: - SENDING DATA TO BE - HAVEN'T DONE YET
    func Register(){
//        let user = User(id: nil, email: emailTextField.text!, password: passwordTextField.text!, fullName: fullNameTextField.text!)
        
        //api sending data to BE
        
    }
    
    // MARK: - Private

    
    
   
    // MARK: - Actions
    @IBAction func signUp(_ sender: UIButton) {
        countClickSignUpTime! += 1
        print("\n\nLog Login: \(countClickSignUpTime!) times - HasError: \(hasErrorStatus().status!)")
        if hasErrorStatus().status == true {
            let message = hasErrorStatus().messages
            alertShowIfError(message: message!)
        } else {
            print("Log Login: Pass Validate!")
            Register()
            AppViewController.shared.pushToCreateNewGameScreen()
        }
    }
    
}
    


// MARK: - extensions
extension SignUpViewController {

    //MARK: - CheckEmpty
    func isEmptyField() -> (textFieldName: String?, status: Bool) {
        if emailTextField.text!.isEmpty {
            textFieldName = "Email"
            return (textFieldName, true)
            
        } else if passwordTextField.text!.isEmpty {
            textFieldName = "Password"
            return (textFieldName, true)
            
        } else if rePasswordTextField.text!.isEmpty {
            textFieldName = "Repeat Password"
            return (textFieldName, true)
            
        } else if fullNameTextField.text!.isEmpty {
            textFieldName = "Fullname"
            return (textFieldName, true)
            
        }
        return (nil, false)
    }
    
    //MARK: - CheckMatch
    func isPasswordMatch() -> Bool {
        let pass = passwordTextField.text
        let rePass = rePasswordTextField.text
        if pass == rePass {
            print("Log Login: Password and repeat password is matching!")
            return true
        }
        print("Log Login: Password and repeat password is not match!")
        return false
    }
    
    //MARK: - CheckFormatEmail
    func isCorrectFormatEmail() -> Bool {
        let email = emailTextField.text
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print("Log Login: Email Format - \(emailPred.evaluate(with: email))")
        return emailPred.evaluate(with: email)
    }
    
    //MARK: - CheckExistEmail
    func isExistEmail() -> Bool {
        for email in arrayEmailValid {
            if emailTextField.text == email {
                print("Log Login: The create email is valid!")
                return true
            }
        }
        return false
    }
    
    //MARK: - CheckFormatPassword
    func isCorrectFormatPassword() -> Bool {
        let formatPasswordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*?&])(?=.*[0-9])[a-zA-Z0-9\\d@$!%*?&]{8,}$"
        let formatPred = NSPredicate(format:"SELF MATCHES %@", formatPasswordRegEx)
        print("Log Login: Format password \((formatPred.evaluate(with: passwordTextField.text!)) ? "correct!" : "incorrect!")")
        return formatPred.evaluate(with: passwordTextField.text!)
    }
    
    //MARK: - Set Error and Message
    func hasErrorStatus() -> (messages: String?, status: Bool?) {
        //emptyField
        if isEmptyField().status  == true{
            messages = "\(isEmptyField().textFieldName!) is required."
            status = true
            
        } else
        //format Email
        if isCorrectFormatEmail() == false {
            messages = "Please enter valid email."
            status = true

        } else
        //existance Email
        if isExistEmail() == true {
            messages = "Email already exists."
            status = true

        } else
        //format Password
        if isCorrectFormatPassword() == false {
            messages = "Password doesn’t follow format."
            status = true

        } else
        //not Match Password
        if isPasswordMatch() == false {
            messages = "Password and Re-enter password don't match."
            status = true

        } else
        //Field Range
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

