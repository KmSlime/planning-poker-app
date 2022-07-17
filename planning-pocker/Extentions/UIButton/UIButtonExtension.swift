//
//  UIButtonExtension.swift
//  planning-pocker
//
//  Created by Slime on 16/07/2022.
//

import UIKit

extension UIButton {
    func customButtonUI(borderWidth: CGFloat? = nil, borderRadius: CGFloat? = nil, borderColor: UIColor? = nil, backgroundColor: UIColor? = nil, titleColor: UIColor? = nil) {
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        if borderRadius != nil {
            self.layer.cornerRadius = borderRadius!
        }
        if borderColor != nil {
            self.layer.borderColor = borderColor!.cgColor
        }
        if backgroundColor != nil {
            self.layer.backgroundColor = backgroundColor?.cgColor
        }
        if titleColor != nil {
            self.tintColor = titleColor!
        }
    }
}
