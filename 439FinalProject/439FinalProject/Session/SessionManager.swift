//
//  SessionManager.swift
//  439FinalProject
//
//  Created by Kevin Ding on 3/1/21.
//
import UIKit
class SessionManager {
    static let UsernameKey: String = ""
    static let IsLoggedInKey: String = "false"
    static let defaults = UserDefaults.standard
    
    class func loginWithUsername(username:String) {
        defaults.set(username, forKey: UsernameKey)
        defaults.set(true, forKey: IsLoggedInKey)
        defaults.synchronize()
    }
    
    class func logout() {
        defaults.set("", forKey: UsernameKey)
        defaults.set(false, forKey: IsLoggedInKey)
        defaults.synchronize()
    }
    
    class func isLoggedIn() -> Bool {
        let isLoggedIn = defaults.bool(forKey: IsLoggedInKey)
        if (isLoggedIn) {
            return true
        }
        return false
    }
    // for testing
    class func getUsername() -> String {

//        if let username = defaults.object(forKey: UsernameKey) as? String {
//            return username
//        }
//        return ""

        return "Kevin"
    }
    // get avatar from firestore
//    class func getUserAvatar() -> String {
//
//    }
}
