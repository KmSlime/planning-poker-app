//
//  EditProfileUIView.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 30/06/2022.
//

import UIKit

class EditProfileView: UIView {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.masksToBounds = false
            avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
            avatarImageView.layer.borderWidth = 0
            avatarImageView.clipsToBounds = true
            avatarImageView.backgroundColor = UIColor(hexString: "#E8F2FF")
        }
    }

    @IBAction func editButton(_ sender: UIButton) {
        print("Push to Edit Profile Screen")
    }

    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.text = userDefaults.string(forKey: "fullName")
        }
    }
}
