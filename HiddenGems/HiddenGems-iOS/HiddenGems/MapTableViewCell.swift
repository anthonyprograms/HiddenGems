//
//  MapTableViewCell.swift
//  HiddenGems
//
//  Created by Anthony Williams on 3/28/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapTableViewCell: UITableViewCell {

    let identifier = "MapCell"
    @IBOutlet weak var mapview: MKMapView!
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        } else {
//            let alert = UIAlertView(title: "Location", message: "Location must be enabled for this application to work", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
            print("No location")
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Map View
    
    func addMapAnnotations(lat: String, lng: String, name: String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lng)!)
        annotation.title = name
        
        mapview.addAnnotation(annotation)
    }
}

extension MapTableViewCell: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        let locationArray = locations as NSArray
        let location = locationArray.lastObject as! CLLocation
//        let coord = location.coordinate
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapview.setRegion(region, animated: true)
        mapview.showsUserLocation = true
    }
}