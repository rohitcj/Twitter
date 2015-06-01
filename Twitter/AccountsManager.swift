//
//  AccountsManager.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 5/31/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import Foundation

class AccountsManager: NSObject {
    
    class var sharedInstance: AccountsManager {
        struct Static {
            static let instance = AccountsManager()
        }
        return Static.instance
    }
    
    var accounts = Dictionary<String, User>()
    
    override init() {
        self.accounts = [:]
    }
    
    func addAccount(user: User) {
        self.accounts[user.screenname!] = user
    }

    func removeAccount(user: User) {
        self.accounts.removeValueForKey(user.screenname!)
    }
}