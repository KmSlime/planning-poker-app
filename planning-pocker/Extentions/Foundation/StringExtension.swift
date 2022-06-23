//
//  StringExtension.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/21/22.
//

import Foundation

extension String {
    func isUrlLink() -> Bool {
        guard self.starts(with: "https") || self.starts(with: "http") else { return false }
        let urlPattern = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let result = self.matches(pattern: urlPattern)
        return result
    }

    private func matches(pattern: String) -> Bool {
        let regex = try? NSRegularExpression(
            pattern: pattern,
            options: [.caseInsensitive])
        return regex?.firstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: utf16.count)) != nil
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,50}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
        if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count)).first?.phoneNumber {
            return match == self
        } else {
            return false
        }
    }
    
    var isValidPassword: Bool {
        let passRegEx = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,50}$"
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passPred.evaluate(with: self)
    }
}
