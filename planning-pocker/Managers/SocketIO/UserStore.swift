//
//  UserStore.swift
//  planning-pocker
//
//  Created by Hung Nguyen on 22/06/2022.
//

import UIKit

public class UserStore: NSObject {
    // message send Offline
    public class func setMessageOffline(dictionary: [String: Any]) {
        var listUser = self.getMessageOffline()
        listUser.append(dictionary)
        userDefaults.set(listUser, forKey: "MessageOffline")
    }

    public class func getMessageOffline() -> [[String: Any]] {
        if let arrDictionary = userDefaults.value(forKey: "MessageOffline") as? [[String: Any]] {
            return arrDictionary
        }
        return [[:]]
    }

    public class func setMessageOffline_changeAtIndex(indexValue: Int, dictionary: [String: Any]) {
        var listUser = self.getMessageOffline()
        if listUser.count > indexValue {
            listUser[indexValue] = dictionary
            userDefaults.set(listUser, forKey: "MessageOffline")
        }
    }
    
    public class func setMessageOffline_removeAtIndex(indexValue: Int) -> Bool {
        var listUser = self.getMessageOffline()
        if listUser.count > indexValue {
            listUser.remove(at: indexValue)
            userDefaults.set(listUser, forKey: "MessageOffline")
            return true
        }
        return false
    }
    
    public class func setMessageOfflineEmpty() {
        let arr: [[String: Any]] = [[:]]
        userDefaults.set(arr, forKey: "MessageOffline")
    }
    
    public class func setChangeStatusWifi(value: Bool) {
        userDefaults.set(value, forKey: "ChangeStatusWifi")
    }
    
    public class func GetChangeStatusWifi() -> Bool {
        let value = userDefaults.bool(forKey: "ChangeStatusWifi")
        return value
    }
    
    public class func setShouldGetHistoryList(value: Bool) {
        userDefaults.set(value, forKey: "GetHistoryListComplete")
    }
    
    public class func getShouldGetHistoryList() -> Bool {
        let value = userDefaults.bool(forKey: "GetHistoryListComplete")
        return value
    }
}
