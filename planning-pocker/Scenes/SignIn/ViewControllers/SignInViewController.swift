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
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var signInScrollView: UIScrollView!
    // MARK: - Properties
    var messages: String?
    var status: Bool?
    var textFieldName: String?

    // MARK: - Overrides
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        onClickCreateAccountButton()
    }

    // MARK: - Properties

    // MARK: - Overrides

    // MARK: - Publics

    func onClickCreateAccountButton() {
        let createAccountLabelOnClick = UITapGestureRecognizer(target: self, action: #selector(self.goToSignUp(recognizer:)))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(createAccountLabelOnClick)
    }

    @objc func goToSignUp(recognizer: UIGestureRecognizer) {
        if recognizer.state == .ended {
            AppViewController.shared.pushToSignUpScreen()
        }
    }

    @objc func keyboardAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)!.cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.signInScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        signInScrollView.contentInset = contentInset
    }

    @objc func keyboardDisappear(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        signInScrollView.contentInset = contentInset
    }
    // MARK: - API Called
    func signInCallAPI() {
        let router = APIRouter(path: APIPath.Auth.signIn.rawValue,
                               method: .post,
                               parameters: ["email": emailTextField.text!, "password": passwordTextField.text!],
                               contentType: .applicationJson)
        APIRequest.shared.request(router: router) { error, response in
            guard error == nil else {
                print("error calling POST")
                print(error!)
                switch (error?.code ?? 0) {
                case 401:
                    self.showAlert(title: "Notification", message: "Invalid email or password")
                    break
                case 404:
                    self.showAlert(title: "Notification", message: "System error")
                    break
                default:
                    break
                }
                return
            }
            guard let id = response?["id"].int,
                  let email = response?["email"].string,
                  let displayName = response?["displayName"].string else {
                return
            }
            userDefaults.set(id, forKey: "id")
            userDefaults.set(email, forKey: "email")
            userDefaults.set(displayName, forKey: "fullName")
            AppViewController.shared.pushToWelcomeScreen()
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

    // MARK: - Validation
    // MARK: - Actions
    @IBAction func onClickSignInButton(_ sender: Any) {
        if hasErrorStatus().status == true {
            let title = "Error"
            let message = hasErrorStatus().messages
            showAlert(title: title, message: message)
        } else {
            signInCallAPI()
        }
    }

    // MARK: - Validation
}

// MARK: - extensions

extension SignInViewController {
    // MARK: - Check field empty
    func fieldIsEmpty() -> (textFieldName: String?, status: Bool) {
        if emailTextField.text?.isEmpty == true {
            textFieldName = "Email"
            return (textFieldName, true)

        } else if passwordTextField.text?.isEmpty == true {
            textFieldName = "Password"
            return (textFieldName, true)
        }
        return (nil, false)
    }
    // MARK: - Set status and message
    func hasErrorStatus() -> (messages: String?, status: Bool?) {
        // EmptyField
        if fieldIsEmpty().status == true {
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
        // Field Range
        if emailTextField.text!.count > 50 {
            textFieldName = "Email"
            messages = "\(textFieldName!) can't be longer than 50 character."
            status = true

        } else if passwordTextField.text!.count > 50 || passwordTextField.text!.count < 8 {
            textFieldName = "Password"
            messages = "\(textFieldName!) can't be less than 8 characters and longer than 50 characters."
            status = true

        } else {
            return (nil, false)
        }
        return (messages, status)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - protocols
