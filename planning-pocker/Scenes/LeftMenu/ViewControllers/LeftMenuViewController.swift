//
//  LeftMenuViewController.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 29/06/2022.
//

import UIKit

class LeftMenuViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var heightButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftMenuTableView: UITableView! {
        didSet {
            leftMenuTableView.register(UINib(nibName: "LeftMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftMenuTableViewCell")
        }
    }
    @IBOutlet weak var profileView: UIView! {
        didSet {
            guard let subView = Bundle.main.loadNibNamed("EditProfileView", owner: profileView, options: nil)?.first as? EditProfileView else { return }
            profileView?.addSubview(subView)
            subView.userNameLabel.text = userDefaults.string(forKey: "fullName")
            subView.frame = subView.superview!.bounds
            subView.layer.cornerRadius = 50
        }
    }
    @IBOutlet weak var invitePlayerButton: UIButton! {
        didSet {
            invitePlayerButton.addTarget(self, action: #selector(invitePlayer), for: .touchUpInside)
        }
    }
    // MARK: - Properties
    var isGameStarted = false
    var defaultHighLightedCell: Int = 0
    var menu: [LeftMenuModel] = [LeftMenuModel(icon: UIImage(named: "icon_eye.png")!, title: "Spectator Mode"),
                                 LeftMenuModel(icon: UIImage(named: "icon_setting.png")!, title: "My Account"),
                                 LeftMenuModel(icon: UIImage(named: "icon_contact.png")!, title: "Contact us"),
                                 LeftMenuModel(icon: UIImage(named: "icon_support.png")!, title: "Support"),
                                 LeftMenuModel(icon: UIImage(named: "icon_signout.png")!, title: "Sign out"),]
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuTableView.delegate = self
        leftMenuTableView.dataSource = self
        setupUI()
    }
    // MARK: - Private
    private func setupUI() {
        self.invitePlayerButton.isHidden = isGameStarted ? false : true
        self.heightButtonConstraint.constant = isGameStarted ? 50 : 0
    }
    private func selectedCell(_ row: Int) {
        switch row {
        case 0:
            print("Spectator Mode")
            return
        case 1:
            print("My Account")
            return
        case 2:
            print("Contact us")
            return
        case 3:
            print("Support")
            return
        case 4:
            AppViewController.shared.pushToSignOut()
        default:
            break
        }
    }
    // MARK: - Function
    @objc func invitePlayer() {
        AppViewController.shared.pushToInvitePlayerScreen()
    }
}

// MARK: - Extension
extension LeftMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension LeftMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTableViewCell", for: indexPath) as? LeftMenuTableViewCell else {
            return UITableViewCell()
        }
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        if indexPath.row != menu.count - 2 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectedCell(indexPath.row)
    }
}
