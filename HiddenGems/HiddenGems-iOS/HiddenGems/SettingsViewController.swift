//
//  SettingsViewController.swift
//  HiddenGems
//
//  Created by Anthony Williams on 3/30/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let options = ["Posts","About","Terms","Save Original Photo","Invite Facebook Friends", "Invite Contacts", "Log Out"]
    
    var currentUser: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func logoutUser(){
        FacebookModel().logoutUser()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}

extension SettingsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
}

extension SettingsViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.font = UIFont(name: "Helvetica-Light", size: 18)
        cell.textLabel!.text = options[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if indexPath.row == 0 {
            Post().getUserPosts(self.currentUser[0]["userId"] as! String) { _ in
                
            }
        } else if indexPath.row == 1 {
            
        } else if indexPath.row == 2 {
            
        } else if indexPath.row == 3 {
            
        } else if indexPath.row == 4 {
            
        } else if indexPath.row == 5 {
            
        } else if indexPath.row == 6 {
            self.logoutUser()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
}