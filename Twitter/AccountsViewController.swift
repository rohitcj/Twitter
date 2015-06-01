//
//  AccountsViewController.swift
//  Twitter
//
//  Created by Rohit Jhangiani on 5/31/15.
//  Copyright (c) 2015 5TECH. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var accounts: [User] = []
    var selectedRow: Int?
    
    // outlets
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.registerNib(UINib(nibName: "AddAccountCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "AddAccountCell")
        
        loadAccounts()
    }
    
    func loadAccounts() {
        self.accounts = []
        for (screenName, user) in AccountsManager.sharedInstance.accounts {
            self.accounts.append(user)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count + 1 ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.frame.height / CGFloat(self.accounts.count + 1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == self.accounts.count) {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddAccountCell", forIndexPath: indexPath) as! AddAccountCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as! AccountCell
        let user = self.accounts[indexPath.row]
        cell.accountImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
        cell.accountNameLabel.text = user.name!
        cell.accountScreenNameLabel.text = "@\(user.screenname!)"
        selectedRow = indexPath.row
        var swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "onSwipe")
        swipeGestureRecognizer.direction = .Left
        cell.contentView.addGestureRecognizer(swipeGestureRecognizer)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.tableView.reloadData()
    }

    func onSwipe() {
        AccountsManager.sharedInstance.removeAccount(self.accounts[selectedRow!])
        if AccountsManager.sharedInstance.accounts.count == 0 {
            User.currentUser?.signout()
            return
        }
        loadAccounts()
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
