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
}
