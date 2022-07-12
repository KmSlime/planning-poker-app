//
//  SnackBar.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 11/07/2022.
//

import Foundation
import MaterialComponents.MaterialSnackbar


class SnackBar {
    static public func showSnackBar(message: String, color: UIColor) {
        let snackBarMsg = MDCSnackbarMessage()
        snackBarMsg.text = message
        MDCSnackbarMessageView.appearance().snackbarMessageViewBackgroundColor = color
        MDCSnackbarManager.default.show(snackBarMsg)
    }
}
