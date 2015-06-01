//
//  User.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 5/20/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidSigninNotification = "userDidSigninNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var profileHeaderImageUrl: String?
    var tagline: String?
    var location: String?
    var numFollowing: Int?
    var numFollowers: Int?
    var dictionary: NSDictionary
    var accounts: [User]?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        if dictionary["profile_banner_url"] != nil {
            profileHeaderImageUrl = dictionary["profile_banner_url"] as? String
        } else {
            profileHeaderImageUrl = dictionary["profile_background_image_url"] as? String
        }
        tagline = dictionary["description"] as? String
        location = dictionary["location"] as? String
        numFollowing = dictionary["friends_count"] as? Int
        numFollowers = dictionary["followers_count"] as? Int
    }
    
    func signout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidSignOutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
        }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
