//
//  ViewController.swift
//  HiddenGems
//
//  Created by Anthony Williams on 3/26/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    var currentUser: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupFacebookLoginButton()
        checkForLogin()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loggedIn" {
            let gemViewController: GemViewController = segue.destinationViewController as! GemViewController
            gemViewController.currentUser = self.currentUser
        }
    }
    
    func loginUser(){
        FacebookModel().getInfo() { id, email in
            User().loginUser(id, email: email) { userData in
                self.currentUser = userData
                self.performSegueWithIdentifier("loggedIn", sender: self)
            }
        }
    }
}

extension ViewController: FBSDKLoginButtonDelegate {
    func setupFacebookLoginButton(){
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
    }
    
    func checkForLogin(){
        if(FBSDKAccessToken.currentAccessToken() == nil){
            print("Not logged in")
        } else{
            self.loginUser()
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error == nil){
            print("Login complete")
            self.loginUser()
        } else{
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
}