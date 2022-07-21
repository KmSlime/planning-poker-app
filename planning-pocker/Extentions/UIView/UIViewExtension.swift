//
//  UIViewExtension.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/21/22.
//

import UIKit

extension UIView {
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    func makeRounded(borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
        if borderWidth != nil {
            layer.borderWidth = borderWidth!
        }
        if borderColor != nil {
            layer.borderColor = borderColor!.cgColor
        }
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }

    func zhmfPositionInScreen() -> CGPoint {
        if let superView = self.superview {
            if let scrollView = superView as? UIScrollView {
                let position = CGPoint.init(x: self.frame.origin.x, y: self.frame.origin.y)
                let superPosition = superView.zhmfPositionInScreen()
                let scrollViewOffset = scrollView.contentOffset
                return CGPoint.init(x: superPosition.x + position.x - scrollViewOffset.x , y: superPosition.y + position.y - scrollViewOffset.y)
            } else {
                let superPosition = superView.zhmfPositionInScreen()
                let position = self.frame.origin
                return CGPoint.init(x: superPosition.x + position.x, y: superPosition.y + position.y)
            }
        } else { return self.frame.origin }
    }
    
    func dropShadow( color: UIColor, opacity: Float = 0.3, radius: CGFloat = 2, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
}
