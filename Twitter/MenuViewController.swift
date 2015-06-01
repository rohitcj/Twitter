//
//  MenuViewController.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 5/29/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var timelineButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var mentionsButton: UIButton!
    @IBOutlet weak var accountsButton: UIButton!
    
    @IBOutlet var leftSwipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var rightSwipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var contentViewXConstraint: NSLayoutConstraint!
    // @IBOutlet weak var menuViewXConstraint: NSLayoutConstraint!
    
    var viewControllers: [UIViewController] =  [UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TweetsViewController") as! UIViewController,
                                                UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as! UIViewController,
                                                UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MentionsViewController") as! UIViewController,
                                                UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AccountsViewController") as! UIViewController
                                                ]
    
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.frame = self.contentView.bounds
                newVC.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    @IBAction func onMenuButtonTap(sender: AnyObject) {
        var tappedButton = sender as! UIButton
        switch tappedButton {
        case timelineButton:
            self.activeViewController = viewControllers.first
        case profileButton:
            var profileViewController = viewControllers[1] as! ProfileViewController
            profileViewController.user = User.currentUser
            self.activeViewController = profileViewController
        case mentionsButton:
            self.activeViewController = viewControllers[2]
        case accountsButton:
            self.activeViewController = viewControllers[3]
        default:
            return
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.contentViewXConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.contentViewXConstraint.constant = -200.00
        self.contentViewXConstraint.constant = 0.0
        self.activeViewController = viewControllers.first
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignout(sender: AnyObject) {
        User.currentUser?.signout()
    }
    
    @IBAction func onSwipeLeft(sender: AnyObject) {
    var swipeGestureRecognizer = (sender as! UISwipeGestureRecognizer)
        if swipeGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.contentViewXConstraint.constant = 0.0
                // self.menuViewXConstraint.constant = 0.0
                self.view.layoutIfNeeded()
            })
        }
    }

    @IBAction func onSwipeRight(sender: AnyObject) {
        var swipeGestureRecognizer = (sender as! UISwipeGestureRecognizer)
        if swipeGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.contentViewXConstraint.constant = 250.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "composeTweetSegue2" {
            var navigationController = segue.destinationViewController as! UINavigationController
            var tweetComposeViewController = navigationController.topViewController as! TweetComposeViewController
        }
    }
}
