//
//  User.swift
//  TwitterApp
//
//  Created by Palak Jadav on 2/28/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileUrl: NSURL?
    var tagline: String?
    var dictionary: NSDictionary?
    
    var profileBannerImageURL: NSURL?
    var tweetsCount: Int
    var followingCount: Int
    var followerCount: Int
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString { profileUrl = NSURL(string: profileUrlString) }
        
        let profileBannerString = dictionary["profile_banner_url"] as? String
        if let profileBannerString = profileBannerString {
            profileBannerImageURL = NSURL(string: profileBannerString)
        }
        
        tagline =  dictionary["description"] as? String
        
        tweetsCount = dictionary["statuses_count"] as! Int
        followingCount = dictionary["followers_count"] as! Int
        followerCount = dictionary["friends_count"] as! Int
        
    }
    static var _currentUser: User?
    static let userDidLogoutNotification =  "UserDidLogout"
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
            let defaults =  UserDefaults.standard
            
            let userData = defaults.object(forKey: "currentUserData") as? NSData
            
            if let userData = userData {
                let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                
                _currentUser = User(dictionary: dictionary)
            }
                
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user 
            let defaults = UserDefaults.standard
            
            if let user = user {
            let data = try! JSONSerialization.data(withJSONObject: user.dictionary ?? [], options: [])
                defaults.set(data, forKey:"currentUserData")
            }
            else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
