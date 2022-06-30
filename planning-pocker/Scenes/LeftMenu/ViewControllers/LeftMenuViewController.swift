//
//  LeftMenuViewController.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 29/06/2022.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var leftMenuTableView: UITableView! {
        didSet {
            leftMenuTableView.register(UINib(nibName: "LeftMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftMenuTableViewCell")
        }
    }
    
    @IBOutlet weak var profileView: UIView! {
        didSet {
            guard let subView = Bundle.main.loadNibNamed("EditProfileView", owner: profileView, options: nil)?.first as? EditProfileView else { return }
            profileView?.addSubview(subView)
            subView.frame = subView.superview!.bounds;
            subView.layer.cornerRadius = 50
        }
    }
    
    var isLoggined = false
    var delegate: LeftMenuViewControllerDelegate?
    var defaultHighLightedCell: Int = 0
    var menu: [LeftMenuModel] = [LeftMenuModel(icon: UIImage(named: "icon_eye.png")!, title: "Spectator Mode"),
                                 LeftMenuModel(icon: UIImage(named: "icon_setting.png")!, title: "My Account"),
                                 LeftMenuModel(icon: UIImage(named: "icon_contact.png")!, title: "Contact us"),
                                 LeftMenuModel(icon: UIImage(named: "icon_support.png")!, title: "Support"),
                                 LeftMenuModel(icon: UIImage(named: "icon_signout.png")!, title: "Sign out"),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuTableView.delegate = self
        leftMenuTableView.dataSource = self
        setupUI()
    }
    
    private func setupUI() {
       
    }
    
    @IBAction func invitePlayerButton(_ sender: UIButton) {
        AppViewController.shared.pushToInvitePlayerScreen()
    }
    
}

extension LeftMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension LeftMenuViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTableViewCell", for: indexPath) as? LeftMenuTableViewCell else {
            return UITableViewCell()
        }
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        if indexPath.row != menu.count - 2{
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
    }
    
    
}

protocol LeftMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

