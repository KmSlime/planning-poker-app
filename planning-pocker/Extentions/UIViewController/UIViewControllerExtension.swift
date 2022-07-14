//
//  UIViewControllerExtension.swift
//  planning-pocker
//
//  Created by Hiep on 22/06/2022.
//

import UIKit

extension UIViewController: UIGestureRecognizerDelegate {
    @discardableResult func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        let titleAttrString = NSMutableAttributedString(string: title ?? "", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message ?? "", attributes: messageFont)
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        var allButtons = buttonTitles ?? [String]()
        if allButtons.isEmpty {
            allButtons.append("OK")
        }
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    struct MenuHolder {
        static var leftMenuViewController = LeftMenuViewController()
        static var leftMenuRevealWidth: CGFloat = 300
        static var paddingForRotation: CGFloat = 150
        static var isExpanded = false
        static var leftMenuTrailingConstraint = NSLayoutConstraint()
        static var revealLeftMenuOnTop = true
        static var leftMenuShadowView = UIView()
    }
     func setupLeftMenu() { // set up left menu
        // Set up shadow
        MenuHolder.leftMenuShadowView = UIView(frame: self.view.bounds)
        MenuHolder.leftMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        MenuHolder.leftMenuShadowView.backgroundColor = .black
        MenuHolder.leftMenuShadowView.alpha = 0
        // Tap Gestures
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        MenuHolder.leftMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        if MenuHolder.revealLeftMenuOnTop {
            view.insertSubview(MenuHolder.leftMenuShadowView, at: 1)
        }
        view.bringSubviewToFront(MenuHolder.leftMenuShadowView)
        // Insert LeftMenuViewController to ChooseCardViewController
        MenuHolder.leftMenuViewController.defaultHighLightedCell = 0
        view.insertSubview(MenuHolder.leftMenuViewController.view, at: MenuHolder.revealLeftMenuOnTop ? 1 : 0)
        addChild(MenuHolder.leftMenuViewController)
        view.bringSubviewToFront(MenuHolder.leftMenuViewController.view)
        MenuHolder.leftMenuViewController.didMove(toParent: self)
        MenuHolder.leftMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if MenuHolder.revealLeftMenuOnTop {
            MenuHolder.leftMenuTrailingConstraint = MenuHolder.leftMenuViewController.view.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: -MenuHolder.leftMenuRevealWidth - MenuHolder.paddingForRotation)
            MenuHolder.leftMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            MenuHolder.leftMenuViewController.view.widthAnchor.constraint(equalToConstant: MenuHolder.leftMenuRevealWidth),
            MenuHolder.leftMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            MenuHolder.leftMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
     func leftMenuState(expanded: Bool) {
        if expanded {
            self.animateLeftMenu(targetPosition: MenuHolder.revealLeftMenuOnTop ? 0 : MenuHolder.leftMenuRevealWidth) { _ in
                MenuHolder.isExpanded = true
            }
            UIView.animate(withDuration: 0.5) {
                MenuHolder.leftMenuShadowView.alpha = 0.6
            }
        } else {
            self.animateLeftMenu(targetPosition: MenuHolder.revealLeftMenuOnTop ?
                                 (-MenuHolder.leftMenuRevealWidth - MenuHolder.paddingForRotation)
                                 : 0) { _ in
                MenuHolder.isExpanded = false
            }
            UIView.animate(withDuration: 0.5) {
                MenuHolder.leftMenuShadowView.alpha = 0
            }
        }
    }
     func animateLeftMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> Void) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0,
            options: .layoutSubviews,
            animations: {
                if MenuHolder.revealLeftMenuOnTop {
                    MenuHolder.leftMenuTrailingConstraint.constant = targetPosition
                    self.view.layoutIfNeeded()
                } else {
                    self.view.subviews[1].frame.origin.x = targetPosition
                }
            },
            completion: completion)
    }
    @objc func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if MenuHolder.isExpanded {
                leftMenuState(expanded: false)
            }
        }
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: MenuHolder.leftMenuViewController.view))! {
            return false
        }
        return true
    }
    
    func presentOnRoot(with viewController: UIViewController) {
           let navigationController = UINavigationController(rootViewController: viewController)
           navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
           self.present(navigationController, animated: true, completion: nil)
       }
}
