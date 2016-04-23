//
//  FacebookModel.swift
//  HiddenGems
//
//  Created by Anthony Williams on 3/29/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookModel {
    
    func checkForLogin(completion: () -> ()){
        if(FBSDKAccessToken.currentAccessToken() == nil){
            print("Not logged in")
        } else{
            print("Logged in")
            completion()
        }
    }
    
    // MARK: Facebook Login
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error == nil){
            print("Login complete")
        } else{
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
    func getInfo(completionHandler: (id: String, email: String) -> ()){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "email, id"]).startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
//                print(result)
                
                let id = result["id"] as! String
                let email = result["email"] as! String
                
                completionHandler(id: id, email: email)
            })
        }
    }
    
    func logoutUser(){
        let logout = FBSDKLoginManager()
        logout.logOut()
    }
}
