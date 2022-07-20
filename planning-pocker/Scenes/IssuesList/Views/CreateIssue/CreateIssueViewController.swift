//
//  CreateIssueViewController.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 28/06/2022.
//

import UIKit

// MARK: - protocols
protocol createIssueViewControllerDelegate: AnyObject {
    func createIssueViewControllerDidCancel(_ controller: CreateIssueViewController)
    func createIssueViewController(_ controller: CreateIssueViewController, didFinishAdding item: String)
}

class CreateIssueViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var warningLabel: UILabel! {
        didSet {
            warningLabel.isHidden = true
            warningLabel.textColor = .red
            warningLabel.text = "Text should contain maximum 300 characters"
        }
    }

    @IBOutlet weak var textField: UITextView! {
        didSet {
            textField.layer.cornerRadius = 4
            textField.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }
    }
    // MARK: - Properties
    var placeholder = "Enter a tittle for the issue"
    weak var delegate: createIssueViewControllerDelegate?
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.text = placeholder
        textField.textColor = .lightGray
        self.setupHideKeyboardOnTap()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }

    // MARK: - Publics
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    // MARK: - Actions
    @IBAction func cancel(_ sender: UIButton) {
        delegate?.createIssueViewControllerDidCancel(self)
    }
    @IBAction func save(_ sender: UIButton) {
        delegate?.createIssueViewController(self, didFinishAdding: placeholder)
    }
}

// MARK: - extensions
extension CreateIssueViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
            textView.backgroundColor = .white
            textView.layer.borderWidth = 2
            textView.layer.borderColor = UIColor(hexString: "#EEEEEE").cgColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter a tittle for the issue"
            textView.textColor = .lightGray
            textView.backgroundColor = UIColor(hexString: "#EEEEEE")
            placeholder = ""
        } else {
            placeholder = textView.text
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        warningLabel.isHidden = true
        if textView.text.count > 300 && range.length == 0 {
            warningLabel.isHidden = false
            return false
        }
            return true
        }

    func textViewDidChange(_ textView: UITextView) {
        placeholder = textView.text
    }
}

extension UIViewController {
    func setupHideKeyboardOnTap() {
            self.view.addGestureRecognizer(self.endEditingRecognizer())
            self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
        }
    private func endEditingRecognizer() -> UIGestureRecognizer {
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
            tap.cancelsTouchesInView = false
            return tap
    }
}
