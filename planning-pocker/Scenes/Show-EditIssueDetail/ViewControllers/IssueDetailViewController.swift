//
//  IssueDetailViewController.swift
//  planning-pocker
//
//  Created by Hung Nguyen on 29/06/2022.
//

import UIKit
import MaterialComponents.MaterialSnackbar
class IssueDetailViewController: UIViewController {

    @IBOutlet weak var issueKeyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleContentTextView: UITextView!
    @IBOutlet weak var linkContentLabel: PaddingLabel!
    @IBOutlet weak var descriptionContentTextVIew: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var titleTextViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextViewHeightConstraints: NSLayoutConstraint!
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Actions

    @IBAction func onClickCopy(_ sender: Any) {
        guard let text = linkContentLabel.text else {
            return
        }
        UIPasteboard.general.string = text

        guard UIPasteboard.general.string != nil else {
            return
        }
        let snackBarMsg = MDCSnackbarMessage()
        snackBarMsg.text = "Copied sucessful"
        MDCSnackbarMessageView.appearance().snackbarMessageViewBackgroundColor = UIColor(hexString: "#4BB543")
        MDCSnackbarManager.default.show(snackBarMsg)
        
    }
    
    @IBAction func onClickSave(_ sender: Any) {
    }
    
    
    // MARK: - Properties
    
    var placeholderTitleContentLabel : UILabel!

    var placeholderDescriptionContentLabel : UILabel!
    
    // MARK: - Overrides

    

    // MARK: - Publics
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        titleContentTextView.resignFirstResponder()
    }

    // MARK: - Private
    
    private func setupUI() {
        self.setupHideKeyboardOnTap()
        
        placeholderTitleContentLabel = UILabel()
        placeholderDescriptionContentLabel = UILabel()

        issueKeyLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        linkLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        
        titleContentTextView.delegate = self
        titleContentTextView.clipsToBounds = true
        titleContentTextView.layer.masksToBounds = true
        titleContentTextView.layer.cornerRadius = 5
        placeholderTitleContentLabel.text = "Enter a tittle for the issue"
        placeholderTitleContentLabel.sizeToFit()
        titleContentTextView.addSubview(placeholderTitleContentLabel)
        placeholderTitleContentLabel.frame.origin = CGPoint(x: 5, y: (titleContentTextView.font?.pointSize)! / 2)
        placeholderTitleContentLabel.textColor = .tertiaryLabel
        placeholderTitleContentLabel.isHidden = !titleContentTextView.text.isEmpty

        linkContentLabel.clipsToBounds = true
        linkContentLabel.layer.masksToBounds = true
        linkContentLabel.layer.cornerRadius = 5
        
        descriptionContentTextVIew.delegate = self
        descriptionContentTextVIew.clipsToBounds = true
        descriptionContentTextVIew.layer.masksToBounds = true
        descriptionContentTextVIew.layer.cornerRadius = 5
        placeholderDescriptionContentLabel.text = "Add a description..."
        placeholderDescriptionContentLabel.sizeToFit()
        descriptionContentTextVIew.addSubview(placeholderDescriptionContentLabel)
        placeholderDescriptionContentLabel.frame.origin = CGPoint(x: 5, y: (descriptionContentTextVIew.font?.pointSize)! / 2)
        placeholderDescriptionContentLabel.textColor = .tertiaryLabel
        placeholderDescriptionContentLabel.isHidden = !descriptionContentTextVIew.text.isEmpty

        copyButton.layer.cornerRadius = 5
        
        saveButton.layer.cornerRadius = 5
        saveButton.isHidden = false
                
    }

}
// MARK: - extensions

extension IssueDetailViewController: UITextViewDelegate{


func textViewDidBeginEditing(_ textView: UITextView) {
    if textView == titleContentTextView {
        titleTextViewHeightConstraints.constant = 126
        titleContentTextView.backgroundColor = UIColor.white
        titleContentTextView.layer.borderWidth = 1.0
        titleContentTextView.layer.borderColor = UIColor.lightGray.cgColor
    } else if textView == descriptionContentTextVIew {
        descriptionTextViewHeightConstraints.constant = 126
        descriptionContentTextVIew.backgroundColor = UIColor.white
        descriptionContentTextVIew.layer.borderWidth = 1.0
        descriptionContentTextVIew.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}

func textViewDidEndEditing(_ textView: UITextView) {

    if textView == titleContentTextView {
        titleTextViewHeightConstraints.constant = 48
        titleContentTextView.layer.borderWidth = 0
        titleContentTextView.backgroundColor = UIColor(hexString: "#EDEDED")
    } else if textView == descriptionContentTextVIew {
        descriptionTextViewHeightConstraints.constant = 48
        descriptionContentTextVIew.layer.borderWidth = 0
        descriptionContentTextVIew.backgroundColor = UIColor(hexString: "#EDEDED")
    }
}

func textViewDidChange(_ textView: UITextView) {
    if !titleContentTextView.text.isEmpty {
        placeholderTitleContentLabel.isHidden = !titleContentTextView.text.isEmpty
        titleContentTextView.textColor = UIColor.black
        
        
    } else {
        placeholderTitleContentLabel.isHidden = false
        titleContentTextView.textColor = UIColor.lightGray
        
    }
    
    if !descriptionContentTextVIew.text.isEmpty {
        placeholderDescriptionContentLabel.isHidden = !descriptionContentTextVIew.text.isEmpty
        descriptionContentTextVIew.textColor = UIColor.black
        
    } else {
        placeholderDescriptionContentLabel.isHidden = false
        descriptionContentTextVIew.textColor = UIColor.lightGray
        
    }
}
}
