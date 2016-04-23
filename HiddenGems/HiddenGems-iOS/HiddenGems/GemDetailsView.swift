//
//  GemDetailsView.swift
//  HiddenGems
//
//  Created by Anthony Williams on 3/28/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import MapKit

@objc protocol GemDetailsViewDelegate {
    optional func didShare()
    optional func didMap()
    optional func didCancel()
}

class GemDetailsView: UIView {
    
    var delegate : GemDetailsViewDelegate?
    var tableView: UITableView!
    
    var imageUrl: String = ""
    var city: String = ""
    var state: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var gems: String = "0"
    var name: String = ""
    var gemDescription: String = ""
    
    // Activity
    let activityIndicator = UIActivityIndicatorView()
    
    let backgroundView = UIView()
    let fullscreenImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        tableView = UITableView(frame: CGRectMake(10,0, frame.size.width-20, 2*frame.size.height/3))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 37/255, green: 30/255, blue: 53/255, alpha: 1)
        tableView.layer.borderWidth = 2.0
        tableView.layer.borderColor = UIColor(red: 7/255, green: 216/255, blue: 160/255, alpha: 1).CGColor
        tableView.layer.masksToBounds = true
        tableView.separatorColor = .clearColor()
        tableView.bounces = false
        tableView.center.y = frame.size.height/2
        tableView.layer.cornerRadius = 25.0
        tableView.layer.masksToBounds = true
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.registerNib(UINib(nibName: "GemImageTableCell", bundle: nil), forCellReuseIdentifier: "GemImageCell")
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GemDetailsView.swipeView(_:)))
        swipeLeft.direction = .Left
        tableView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GemDetailsView.swipeView(_:)))
        swipeRight.direction = .Right
        tableView.addGestureRecognizer(swipeRight)
        
        addSubview(tableView)
        
        setupFullScreenImage()
    }
    
    func setupData(city: String, state: String, latitude: String, longitude: String, gems: String, name: String, gemDescription: String){
        self.city = city
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
        self.gems = gems
        self.name = name
        self.gemDescription = gemDescription
        
        tableView.reloadData()
    }
    
    func setupImage(imageUrl: String){
        self.imageUrl = imageUrl
        
        tableView.reloadData()
    }
    
    func setupFullScreenImage(){
        let screenSize = UIScreen.mainScreen().bounds
        
        backgroundView.frame = CGRect(x: 0, y: self.frame.size.height, width: screenSize.width, height: screenSize.height)
        backgroundView.backgroundColor = UIColor.blackColor()
        addSubview(backgroundView)
        
        fullscreenImage.frame = CGRect(x: 0, y: 0, width: backgroundView.frame.size.width, height: backgroundView.frame.size.height)
        fullscreenImage.center = backgroundView.center
        fullscreenImage.contentMode = .ScaleAspectFit
        backgroundView.addSubview(fullscreenImage)
        
        fullscreenImage.userInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GemDetailsView.removeFullScreenImage))
        tapGesture.numberOfTapsRequired = 1
        fullscreenImage.addGestureRecognizer(tapGesture)
    }
    
    func removeFullScreenImage(){
        UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseInOut], animations: {
            self.backgroundView.frame.origin.y = UIScreen.mainScreen().bounds.height
        }, completion: nil)
    }
    
    func setup(){
        let lightBlur = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = frame
        addSubview(blurView)
    }
    
    func reject(){
        delegate?.didCancel!()
        removeFromSuperview()
    }
    
    func accept(){
        delegate?.didMap!()
        mapToLocation()
        removeFromSuperview()
    }
    
    func swipeView(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .Left {
            viewAnimation(true) {
                self.reject()
            }
        } else {
            viewAnimation(false) {
                self.reject()
            }
        }
    }
    
    func viewAnimation(left: Bool, completion: () -> ()){
        var movePosition = -self.frame.size.width
        
        if left == false {
            movePosition = 2*self.frame.size.width
        }
        
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.tableView.frame.origin.x = movePosition
        }) { _ in
            completion()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mapToLocation(){
        let latitute : CLLocationDegrees = Double(self.latitude)!
        let longitute : CLLocationDegrees = Double(self.longitude)!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(self.name)"
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    func loading(subview: UIView){
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.frame = subview.frame
        activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        subview.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func cancelActivity(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

extension GemDetailsView : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}

extension GemDetailsView : UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("GemImageCell", forIndexPath: indexPath) as! GemImageTableViewCell
            
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            cell.gemImageView.contentMode = .ScaleAspectFill
            cell.delegate = self
            
            cell.gemImageView.kf_setImageWithURL(NSURL(string: imageUrl)!, placeholderImage: nil)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = .None
            cell.textLabel!.numberOfLines = 0
            cell.imageView?.image = nil
            cell.textLabel!.textAlignment = .Center
            cell.textLabel!.font = UIFont(name: "Helvetica-Light", size: 16)
            cell.textLabel!.textColor = UIColor(red: 7/255, green: 216/255, blue: 160/255, alpha: 1)
            cell.backgroundColor = UIColor.clearColor()
            
            if indexPath.row == 1 {
                cell.textLabel!.text = name
                cell.textLabel!.font = UIFont(name: "Helvetica", size: 18)
            } else if indexPath.row == 2 {
                cell.textLabel!.text = "\(city), \(state)"
                cell.textLabel!.font = UIFont(name: "Helvetica-Light", size: 14)
            } else if indexPath.row == 3 {
                cell.textLabel!.text = "\(gems) Gems"
                cell.textLabel!.font = UIFont(name: "Helvetica-Light", size: 14)
            } else if indexPath.row == 4 {
                cell.textLabel!.text = gemDescription
                cell.textLabel!.textAlignment = .Left
            } else if indexPath.row == 5 {
                cell.backgroundColor = UIColor(red: 25/255, green: 209/255, blue: 163/255, alpha: 1)
                cell.textLabel!.text = "Share"
                cell.textLabel!.textColor = UIColor.whiteColor()
                cell.textLabel!.font = UIFont(name: "Helvetica", size: 18)
            } else if indexPath.row == 6 {
                cell.backgroundColor = UIColor(red: 64/255, green: 196/255, blue: 255/255, alpha: 1)
                cell.textLabel!.text = "Go"
                cell.textLabel!.textColor = UIColor.whiteColor()
                cell.textLabel!.font = UIFont(name: "Helvetica", size: 18)
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 5 {
            delegate?.didShare!()
        } else if indexPath.row == 6 {
            self.accept()
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 30
        }
        
        return 15
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.frame.size.width/2
        } else if indexPath.row == 1 {
            return 30
        } else if indexPath.row == 2 {
            return 15
        } else if indexPath.row == 3 {
            return 15
        }
        return UITableViewAutomaticDimension
    }
}

extension GemDetailsView: GemImageTableViewCellDelegate {
    func didTapImage() {
        fullscreenImage.kf_setImageWithURL(NSURL(string: imageUrl)!, placeholderImage: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseInOut], animations: {
            self.backgroundView.frame.origin.y = 0.0
            self.fullscreenImage.frame.origin.y = 0.0
        }, completion: nil)
    }
}

