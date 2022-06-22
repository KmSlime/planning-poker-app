//
//  UserStore.swift
//  planning-pocker
//
//  Created by Hung Nguyen on 22/06/2022.
//

import UIKit

let Userdefaults = UserDefaults.standard

public class UserStore: NSObject {
    // message send Offline
    public class func setMessageOffline(dictionary: [String: Any]) {
        var listuser = self.getMessageOffline()
        listuser.append(dictionary)
        Userdefaults.set(listuser, forKey: "MessageOffline")
    }

    public class func getMessageOffline() -> [[String: Any]] {
        if let Arrdictionary = Userdefaults.value(forKey: "MessageOffline") as? [[String: Any]] {
            return Arrdictionary
        }
        return [[:]]
    }
    public class func setMessageOffline_changeAtIndex(indexValue : Int, dictionary: [String: Any]) {
        var listuser = self.getMessageOffline()
        if listuser.count > indexValue{
            listuser[indexValue] = dictionary
            Userdefaults.set(listuser, forKey: "MessageOffline")
        }
    }
    
    public class func setMessageOffline_removeAtIndex(indexValue : Int) -> Bool{
        var listuser = self.getMessageOffline()
        if listuser.count > indexValue{
            listuser.remove(at: indexValue)
            Userdefaults.set(listuser, forKey: "MessageOffline")
            return true
        }
        return false
    }
    
    public class func setMessageOfflineEmpty() {
        let arr : [[String : Any]] = [[:]]
        Userdefaults.set(arr, forKey: "MessageOffline")
    }
    
    public class func setChangeStatusWifi(value : Bool) {
        Userdefaults.set(value, forKey: "ChangeStatusWifi")
    }
    
    public class func GetChangeStatusWifi() -> Bool {
        let value = Userdefaults.bool(forKey: "ChangeStatusWifi")
        return value
    }
    
    public class func setShouldGetHistoryList(value : Bool) {
        Userdefaults.set(value, forKey: "GetHistoryListComplete")
    }
    
    public class func getShouldGetHistoryList() -> Bool {
        let value = Userdefaults.bool(forKey: "GetHistoryListComplete")
        return value
    }
}
