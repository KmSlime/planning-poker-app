//
//  UITextFieldExtension.swift
//  planning-pocker
//
//  Created by Slime on 24/06/2022.
//

import UIKit

extension UITextField {

    func customPlaceholderTextColor(placeholderHint: String, colorHintByUIColor: UIColor? = nil) {
        let colorOfHint: UIColor!
        if colorHintByUIColor != nil {
            colorOfHint = colorHintByUIColor
        } else {
            colorOfHint = UIColor(hexString: "#000000")
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderHint, attributes: [NSAttributedString.Key.foregroundColor: colorOfHint as Any])
    }

    func customBorderRadius(borderColorByUIColor: UIColor? = nil, borderWidth: CGFloat? = nil, borderRadius: CGFloat? = nil) {
        if borderColorByUIColor != nil {
            self.layer.borderColor = borderColorByUIColor!.cgColor
        } else {
            self.layer.borderColor = UIColor(hexString: "#000000").cgColor
        }

        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        } else {
            self.layer.borderWidth = 1
        }

        if borderRadius != nil {
            self.layer.cornerRadius = borderRadius!
        } else {
            self.layer.cornerRadius = 0
        }
    }
}

