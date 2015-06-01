//
//  AddAccountCell.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 6/1/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import UIKit

class AddAccountCell: UITableViewCell {

    @IBOutlet weak var addAccountButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addAccountButton.addTarget(self, action: "onAddAccount", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(addAccountButton)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func onAddAccount() {
        User.currentUser?.signout()
    }
}
