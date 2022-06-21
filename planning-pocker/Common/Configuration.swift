//
//  Configuration.swift
//  FederatedDemo
//
//  Created by Tinh Nguyen on 18/12/2021.
//

import Foundation

struct AppInfo {
    static let shared = AppInfo()
    
    var version: String {
        return readFromInfoPlist(withKey: "CFBundleShortVersionString") ?? "(unknown app version)"
    }
    
    var build: String {
        return readFromInfoPlist(withKey: "CFBundleVersion") ?? "(unknown build number)"
    }
    
    var fullVersion: String {
        return "\(version).\(build)"
    }
    
    // lets hold a reference to the Info.plist of the app as Dictionary
    private let infoPlistDictionary = Bundle.main.infoDictionary
    
    /// Retrieves and returns associated values (of Type String) from info.Plist of the app.
    private func readFromInfoPlist(withKey key: String) -> String? {
        return infoPlistDictionary?[key] as? String
    }
}
