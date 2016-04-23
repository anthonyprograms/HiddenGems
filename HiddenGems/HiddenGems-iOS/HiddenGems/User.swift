//
//  User.swift
//  HiddenGems
//
//  Created by Anthony Williams on 4/9/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import Alamofire

class User: NSObject {
    
    let domain = "http://ec2-52-35-196-123.us-west-2.compute.amazonaws.com"
    
    func loginUser(id: String, email: String, completion: (userData: AnyObject) -> ()){
        // Check if user exists
        Alamofire.request(.GET, "\(domain)/users", parameters: ["userId": id])
            .responseJSON { response in
                if let JSON = response.result.value {
                    // Return user if it exists
                    if JSON.count > 0 {
                        completion(userData: JSON)
                    } else {
                        // Create user if it doesn't exist
                        print("User doesn't exist, creating user: \(id)")
                        self.createUser(id, email: email) { userData in
                            return userData
                        }
                    }
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
        }
    }
    
    func createUser(userId: String, email: String, completion: (userData: AnyObject) -> ()){
        Alamofire.request(.POST, "\(domain)/users", parameters: ["userId": userId, "email": email], encoding: .JSON)
            .responseJSON { response in
                if let JSON = response.result.value {
                    completion(userData: JSON)
                }
        }
    }
    
    func findUsers(){
        Alamofire.request(.GET, "\(domain)/allUsers")
            .responseJSON { response in
                if let JSON = response.result.value {
                    if JSON.count > 0 {
                        print(JSON)
                    }
                }
        }
    }
}
