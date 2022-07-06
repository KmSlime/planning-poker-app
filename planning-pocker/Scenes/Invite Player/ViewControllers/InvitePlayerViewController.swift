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
        navigationController?.popViewController(animated: true)
        guard UIPasteboard.general.string != nil else {
            return
        }
        let snackBarMsg = MDCSnackbarMessage()
        snackBarMsg.text = "Copy to clipboard sucesfully"
        MDCSnackbarMessageView.appearance().snackbarMessageViewBackgroundColor = UIColor(hexString: "#155724")
        MDCSnackbarManager.default.show(snackBarMsg)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        linkLabel.text = "https://viblo.asia/p/swift-cach-tao-popup-view-su-dung-view-controller-rieng-biet-RQqKL24Ol7z"

        // Do any additional setup after loading the view.
    }
}
