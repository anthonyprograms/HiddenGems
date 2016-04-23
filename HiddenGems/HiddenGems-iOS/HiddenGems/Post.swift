//
//  Post.swift
//  HiddenGems
//
//  Created by Anthony Williams on 4/9/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import Alamofire

class Post: NSObject {
    
    let domain = "http://ec2-52-35-196-123.us-west-2.compute.amazonaws.com"
    
    func createPost(userId: String, name: String, imageUrl: String, city: String, state: String, laittude: String, longitude: String, description: String, completion: () -> ()){
        let parameters = ["userId": userId, "name": name, "imageUrl": imageUrl, "city": city, "state": state, "latitude": laittude, "longitude": longitude, "description": description]
        Alamofire.request(.POST, "\(domain)/posts", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                if let _ = response.result.value {
//                    print(JSON)
                    completion()
                }
        }
    }
    
    func getPostById(id: String, completion: (data: AnyObject) -> ()){
        let parameters = ["_id": id]
        Alamofire.request(.GET, "\(domain)/post/id", parameters: parameters)
            .responseJSON { response in
                if let JSON = response.result.value {
//                    print(JSON)
                    completion(data: JSON)
                }
        }
    }
    
    func getUserPosts(userId: String, completion: (data: AnyObject) -> ()){
        let parameters = ["userId": userId]
        Alamofire.request(.GET, "\(domain)/post/user", parameters: parameters)
            .responseJSON { response in
                if let JSON = response.result.value {
                    print(JSON)
//                    completion(data: JSON)
                }
        }
    }
    
    func getPosts(latitude: String, longitude: String, completion: (data: AnyObject) -> ()){
        let parameters = ["latitude": latitude, "longitude": longitude]
        Alamofire.request(.GET, "\(domain)/posts", parameters: parameters)
            .responseJSON { response in
                if let JSON = response.result.value {
                    if JSON.count > 0 {
//                        print(JSON)
                        completion(data: JSON)
                    }
                }
        }
    }
}
