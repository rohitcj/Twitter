//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 5/30/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileHeaderImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileScreenNameLabel: UILabel!
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    @IBOutlet weak var profileLocationLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadProfile() {
        if let profileHeaderImageUrl = user!.profileHeaderImageUrl {
            profileHeaderImageView.setImageWithURL(NSURL(string: profileHeaderImageUrl), placeholderImage: UIImage(named: "Loading"))
        }
        
        if let profileImageUrl = user!.profileImageUrl {
            profileImageView.setImageWithURL(NSURL(string: profileImageUrl), placeholderImage: UIImage(named: "Loading"))
        }
        
        profileNameLabel.text = user!.name!
        profileScreenNameLabel.text = "@\(user!.screenname!)"
        profileDescriptionLabel.text = user!.tagline!
        profileLocationLabel.text = user!.location!
        followingCountLabel.text = "\(user!.numFollowing!)"
        followersCountLabel.text = "\(user!.numFollowers!)"
    }
    
    @IBAction func onTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
