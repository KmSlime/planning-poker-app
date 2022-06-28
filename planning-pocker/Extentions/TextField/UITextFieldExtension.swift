//
//  UITextFieldExtension.swift
//  planning-pocker
//
//  Created by Slime on 24/06/2022.
//

import UIKit

extension UITextField {

    func customPlaceholderTextColor(withHexCode: String, placeholderHint: String) {
        let colorOfHint = UIColor(hexString: withHexCode)
        self.attributedPlaceholder = NSAttributedString(string: placeholderHint, attributes: [NSAttributedString.Key.foregroundColor: colorOfHint])
    }
}
