//
//  UITextFieldExtension.swift
//  planning-pocker
//
//  Created by Slime on 24/06/2022.
//

import UIKit

extension UITextField {

    func customPlaceholderTextColor(placeholderHint: String, withHexCode: String? = nil) {
        let colorOfHint: UIColor!
        if withHexCode != nil {
            colorOfHint = UIColor(hexString: withHexCode!)
        } else {
            colorOfHint = UIColor(hexString: "#000000")
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderHint, attributes: [NSAttributedString.Key.foregroundColor: colorOfHint as Any])
    }
}
