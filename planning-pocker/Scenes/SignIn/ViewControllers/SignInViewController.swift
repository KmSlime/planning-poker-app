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
           // Do any additional setup after loading the view.
           
           SetUpUI()
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
               
               if isValidEmail( email: emailTextField.text! ) && isValidPassword( password: passwordTextField.text! ){
                   
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
           }else if emailTextField.text != "" && passwordTextField.text == "" {
               showAlert(title: "Notify", message: "Please enter valid password")
               return false
           }
           else{
               showAlert(title: "Notify", message: "Please enter email and password")
               return false
           }
           
       }
       
       
       // MARK: - Private
       
       private func SetUpUI() {
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
           
           func isValidEmail(email: String) -> Bool {
               let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
               
               let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
               return emailPred.evaluate(with: email)
           }
           
           func isValidPassword(password: String) -> Bool {
               let passRegEx = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,64}$"
               
               let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
               return passPred.evaluate(with: password)
           }

   }


   // MARK: - extensions

   extension UIViewController {
       @discardableResult func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
           
           let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
           
           let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
           let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
           
           let titleAttrString = NSMutableAttributedString(string: title ?? "", attributes: titleFont)
           let messageAttrString = NSMutableAttributedString(string: message ?? "", attributes: messageFont)

           alertController.setValue(titleAttrString, forKey: "attributedTitle")
           alertController.setValue(messageAttrString, forKey: "attributedMessage")
           
           var allButtons = buttonTitles ?? [String]()
           if allButtons.isEmpty {
               allButtons.append("OK")
           }

           for index in 0..<allButtons.count {
               let buttonTitle = allButtons[index]
               let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                   completion?(index)
               })
               alertController.addAction(action)
               // Check which button to highlight
               if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                   if #available(iOS 9.0, *) {
                       alertController.preferredAction = action
                   }
               }
           }
           present(alertController, animated: true, completion: nil)
           return alertController
       }
   }

   extension String {
       public var isValidEmail: Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPredicate.evaluate(with: self)
       }
      
       public var isValidPhoneNumber: Bool {
           let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
           guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
           if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count)).first?.phoneNumber {
               return match == self
           } else {
               return false
           }
       }
   }

   // MARK: - protocols

