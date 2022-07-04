//
//  UIClolor.swift
//  planning-pocker
//
//  Created by Hiep on 22/06/2022.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        // swiftlint:disable identifier_name
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    static let textFieldBorderColor = UIColor(hexString: "#707070").cgColor
    static let textFieldHintColor = UIColor(hexString: "#0000008F")
    static let blueButtonColor = UIColor(hexString: "#00AAE7")
    static let blueTextColor = UIColor(hexString: "#00AAE7")
    static let votingSystemTextColor = UIColor(hexString: "#00000052")
    static let itemIssueCellBackground = UIColor(hexString: "#F8F8F8")

}
