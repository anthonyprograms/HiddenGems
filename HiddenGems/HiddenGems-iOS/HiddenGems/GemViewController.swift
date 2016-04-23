//
//  GemViewController.swift
//  HiddenGems
//
//  Created by Anthony Williams on 3/26/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher

class GemViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    
    // Location
    var locationManager = CLLocationManager()
    
    // Downloading Data
    var currentUser: AnyObject!
    var posts = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        view.backgroundColor = UIColor(red: 37/255, green: 30/255, blue: 53/255, alpha: 1)
        
//        let icon = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: navigationController, action: #selector(MenuNavigationController.showMenu))
//        icon.imageInsets = UIEdgeInsetsMake(-10, 0, 0, 0)
//        icon.tintColor = UIColor.blackColor()
//        navigationItem.leftBarButtonItem = icon
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(GemViewController.refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        enableLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor(red: 37/255, green: 30/255, blue: 53/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func enableLocation(){
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        } else {
            print("Location must be enabled for this application to work")
        }
    }
    
    func refreshTable(){
        enableLocation()
        refreshControl.endRefreshing()
    }
    
    @IBAction func postAction(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("createPost", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createPost" {
            let postViewController: PostViewController = segue.destinationViewController as! PostViewController
            postViewController.currentUser = self.currentUser
        } else if segue.identifier == "settings" {
            let settingsViewController: SettingsViewController = segue.destinationViewController as! SettingsViewController
            settingsViewController.currentUser = self.currentUser
        }
    }
}

extension GemViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count+1
    }
}

extension GemViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell: MapTableViewCell! = tableView.dequeueReusableCellWithIdentifier("MapCell") as? MapTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "MapCell", bundle: nil), forCellReuseIdentifier: "MapCell")
                cell = tableView.dequeueReusableCellWithIdentifier("MapCell") as? MapTableViewCell
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if self.posts.count > 0 {
                    for post in self.posts {
                        if let location = post["location"] as? Array<Float> {
                            if let name = post["name"] as? String {
                                cell.addMapAnnotations("\(location[1])", lng: "\(location[0])", name: name)
                            }
                        }
                    }
                }
            }
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
            cell.backgroundColor = UIColor.clearColor()

            cell.imageView?.image = UIImage(named: "Logo")
//            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.font = UIFont(name: "Helvetica-Light", size: 16)
            cell.textLabel!.text = posts[indexPath.row-1]["name"] as? String
            cell.textLabel!.textColor = UIColor(red: 7/255, green: 216/255, blue: 160/255, alpha: 1)
            
            if let urlString = self.posts[indexPath.row-1]["imageUrl"] {
                cell.imageView?.kf_setImageWithURL(NSURL(string: urlString as! String)!, placeholderImage: nil)
            } else {
                cell.imageView?.image = UIImage(named: "Logo")
            }

            cell.detailTextLabel?.text = posts[indexPath.row]["description"] as? String
        
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 {
            self.navigationController?.navigationBarHidden = true
            
            let gemDetailFrame = self.view.frame
            let gemDetailsView = GemDetailsView(frame: gemDetailFrame)
            gemDetailsView.delegate = self
            self.view.addSubview(gemDetailsView)
            

            Post().getPostById(self.posts[indexPath.row-1]["_id"] as! String){ postInfo in
                let post = postInfo.objectAtIndex(0) as! NSDictionary
                
                gemDetailsView.setupData(post["city"]! as! String, state: post["state"]! as! String, latitude: "\(post["location"]!.objectAtIndex(1))", longitude: "\(post["location"]!.objectAtIndex(0))", gems: "\(post["gems"]!)", name: post["name"]! as! String, gemDescription: post["description"]! as! String)
                gemDetailsView.setupImage(post["imageUrl"]! as! String)
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.frame.size.width
        }
        return 80
    }
}

extension GemViewController: GemDetailsViewDelegate {
    func didShare() {
        let share = ["Hidden Gem:"]
        
        let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeSaveToCameraRoll, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func didMap() {
        self.navigationController?.navigationBarHidden = false
    }
    
    func didCancel() {
        self.navigationController?.navigationBarHidden = false
    }
}

extension GemViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            Post().getPosts(String(coord.latitude), longitude: String(coord.longitude)) { data in
                self.posts = data as! [NSDictionary]
                self.tableView.reloadData()
            }
        })
        
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(locationObj, completionHandler: { (placemarks, e) -> Void in
//            if let error = e {
//                print("Error:  \(error.localizedDescription)")
//            } else {
//                let placemark = placemarks!.last! as CLPlacemark
//                
//                self.city = placemark.locality
//                self.state = placemark.administrativeArea
//            }
//        })
    }
}