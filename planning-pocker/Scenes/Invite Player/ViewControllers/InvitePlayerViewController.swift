//
//  InvitePlayerViewController.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 27/06/2022.
//

import UIKit
import MaterialComponents.MaterialSnackbar

class InvitePlayerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.layer.cornerRadius = 8.0
        }
    }

    @IBOutlet weak var linkLabel: UILabel!

    @IBAction func copyButton(_ sender: UIButton) {
        guard let text = linkLabel.text else {
            return
        }
        UIPasteboard.general.string = text
        self.dismiss(animated: true)
        guard UIPasteboard.general.string != nil else {
            return
        }
        let snackBarMsg = MDCSnackbarMessage()
        snackBarMsg.text = "Copy to clipboard sucesfully"
        MDCSnackbarMessageView.appearance().snackbarMessageViewBackgroundColor = UIColor(hexString: "#155724")
        MDCSnackbarManager.default.show(snackBarMsg)
    }
    var url: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        linkLabel.text = self.url
    }
}
