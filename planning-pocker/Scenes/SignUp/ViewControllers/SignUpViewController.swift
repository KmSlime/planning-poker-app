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
    var newUser: User!
    var fullName: String?
    var email: String?
    var password: String?
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        onClickSignInButton()
    }
    
    // MARK: - Publics
    func onClickSignInButton() {
        let signInLabelOnClick = UITapGestureRecognizer(target: self, action: #selector(self.backToSignIn(recognizer:)))
        signInLabel.isUserInteractionEnabled = true
        signInLabel.addGestureRecognizer(signInLabelOnClick)
    }

    @objc func backToSignIn(recognizer: UIGestureRecognizer) {
        if recognizer.state == .ended {
            AppViewController.shared.popToPreviousScreen()
        }
    }
    
    // MARK: - SENDING DATA TO BE
    func register(user: User) {
        let routerSignUp = APIRouter(path: APIPath.Auth.signUp.rawValue,
                                     method: .post,
                                     parameters: ["displayName": user.fullName,
                                                  "email": user.email,
                                                  "password": user.password],
                                     contentType: .applicationJson)
        APIRequest.shared.request(router: routerSignUp) { [weak self] error, response in

            guard error == nil else {
                // MARK: - Check exist email
                if error?.messageCode == "Error: Email is already in use!" {
                    AppViewController.shared.showAlert(tittle: "Error", message: "Email already exists.")
                } else {
                    print("Log Sign Up: Error [\n \(String(describing: error))]")
                    AppViewController.shared.showAlert(tittle: "Opps", message: "Something went wrong!")
                }
                return
            }

            let message = response?.dictionary?["message"]?.stringValue ?? "Log Sign Up: Else Case!!"
            print(message as Any)
            if message != "Log Sign Up: Else Case!!" {
                user.id = response?.dictionary?["id"]?.intValue ?? -1
                userDefaults.set(user.id, forKey: "id")
                AppViewController.shared.popupAlert(title: "Register successfully!", colorPopup: UIColor.systemGreen)
                AppViewController.shared.pushToWelcomeScreen(user: user)
            } else {
                AppViewController.shared.showAlert(tittle: "Opps", message: "Something went wrong!")
                return
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        
        // font
        emailTextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        passwordTextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        rePasswordTextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        fullNameTextField.font = UIFont(name: "Poppins-Medium", size: 16.0)
        
        // color
        signInLabel.textColor = UIColor.blueTextColor
        signUpButton.backgroundColor = UIColor.blueButtonColor
        UITextField.appearance().tintColor = UIColor.blueTextColor

        // style
        emailTextField.customBorderRadius(borderColorByUIColor: UIColor.textFieldBorderColor, borderWidth: 1, borderRadius: 4)
        passwordTextField.customBorderRadius(borderColorByUIColor: UIColor.textFieldBorderColor, borderWidth: 1, borderRadius: 4)
        rePasswordTextField.customBorderRadius(borderColorByUIColor: UIColor.textFieldBorderColor, borderWidth: 1, borderRadius: 4)
        fullNameTextField.customBorderRadius(borderColorByUIColor: UIColor.textFieldBorderColor, borderWidth: 1, borderRadius: 4)
        
        // other
        navigationItem.hidesBackButton = true
        setupHideKeyboardOnTap()

    }
    
    // MARK: - Actions
    @IBAction func signUp(_ sender: UIButton) {
        if hasErrorStatus().status == true {
            let title = "Error"
            let message = hasErrorStatus().messages
            showAlert(title: title, message: message)
        } else {
            email = emailTextField.text!
            fullName = fullNameTextField.text!
            newUser = User(id: -1, email: email!, password: passwordTextField.text!, fullName: fullName!)
            
            userDefaults.set(email, forKey: "email")
            userDefaults.set(fullName, forKey: "fullName")
            register(user: newUser)
        }
    }
}

// MARK: - extensions
extension SignUpViewController {

    // MARK: - Check field empty
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
    
    // MARK: - Set status and message
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
