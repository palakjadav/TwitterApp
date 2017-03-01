//
//  User.swift
//  TwitterApp
//
//  Created by Palak Jadav on 2/28/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    init(dictionary: NSDictionary) {
        
        
        name = dictionary["name"] as? String as NSString?
        screenname = dictionary["screen_name"] as? String as NSString?
        
       /* let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString {
            profileUrlString = NSURL(string: profileUrlString)
        }*/
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString { profileUrl = NSURL(string: profileUrlString) }
        
        tagline =  dictionary["description"] as? String as NSString?
        
    }
    
    class var currentUser: User? {
        get {
            let defaults =  UserDefaults.standard
            
            //let user =
            return nil
        }
        
    }
    

}
