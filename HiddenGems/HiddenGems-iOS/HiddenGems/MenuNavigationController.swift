//
//  MenuNavigationController.swift
//  HiddenGems
//
//  Created by Anthony Williams on 4/23/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import MediumMenu

class MenuNavigationController: UINavigationController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var menu: MediumMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewControllerWithIdentifier("Home") as! GemViewController
        setViewControllers([homeViewController], animated: false)
        
        let item1 = MediumMenuItem(title: "Explore") {
            let homeViewController = storyboard.instantiateViewControllerWithIdentifier("Gems") as! GemViewController
            self.setViewControllers([homeViewController], animated: false)
        }
        
        let item2 = MediumMenuItem(title: "Post") {
            let topStoriesViewController = storyboard.instantiateViewControllerWithIdentifier("Post") as! PostViewController
            self.setViewControllers([topStoriesViewController], animated: false)
        }
        
        let item3 = MediumMenuItem(title: "Settings") {
            let bookMarksViewController = storyboard.instantiateViewControllerWithIdentifier("Settings") as! SettingsViewController
            self.setViewControllers([bookMarksViewController], animated: false)
        }
        
        let item4 = MediumMenuItem(title: "Featured") {
            let helpViewController = storyboard.instantiateViewControllerWithIdentifier("Post") as! PostViewController
            self.setViewControllers([helpViewController], animated: false)
        }
        
//        let item5 = MediumMenuItem(title: "Sign out") {
//            let signoutViewController = storyboard.instantiateViewControllerWithIdentifier("Signout") as! SignoutViewController
//            self.setViewControllers([signoutViewController], animated: false)
//        }
        
        menu = MediumMenu(items: [item1, item2, item3, item4], forViewController: self)
    }
    
    func showMenu() {
        menu?.show()
    }
}

extension UINavigationBar {
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 60)
    }
}
