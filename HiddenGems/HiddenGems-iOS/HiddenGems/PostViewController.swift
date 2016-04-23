//
//  PostViewController.swift
//  HiddenGems
//
//  Created by Anthony Williams on 3/27/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import CoreLocation
import AWSCore
import AWSS3

class PostViewController: UIViewController {

    // Outlets
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    var showedCamera = true
    
    var currentUser: AnyObject!
    
    // Location
    var locationManager = CLLocationManager()
    var latitude: String!
    var longitude: String!
    var city: String!
    var state: String!
    
    // AWS S3
    var uploadRequest: AWSS3TransferManagerUploadRequest!
    
    // Progress
    let progressView = ProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.attributedPlaceholder = NSAttributedString(string:"Name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        descriptionField.textColor = UIColor.whiteColor()
        
        nameField.delegate = self
        descriptionField.delegate = self
        
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        } else {
            print("Location must be enabled for this application to work")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupImageView()
        
        if showedCamera == true {
            showedCamera = false
            openCamera()
        }
    }
    
    func setupImageView(){
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(red: 7/255, green: 216/255, blue: 160/255, alpha: 1).CGColor
        imageView.layer.masksToBounds = true
        imageView.userInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostViewController.openCamera))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func postGem(sender: UIButton) {
        if imageView.image != nil {
            if nameField.text != "" {
                if descriptionField.text != "Add a description" {
                    postButton.hidden = true
                    navigationController?.navigationBarHidden = true
                    
                    uploadToS3() { imageUrl in
                        Post().createPost(self.currentUser[0]["userId"] as String!, name: self.nameField.text!, imageUrl: imageUrl, city: self.city, state: self.state, laittude: self.latitude, longitude: self.longitude, description: self.descriptionField.text!) {
                        }
                        
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                } else {
                    self.triggerAlert("Missing Description", message: "Make sure to add a description before posting")
                }
            } else {
                self.triggerAlert("Missing Name", message: "Make sure to add a name before posting")
            }
        } else {
            self.triggerAlert("Missing Image", message: "Make sure to add an image before posting")
        }
    }
    
    // MARK: Alert View
    
    func triggerAlert(title: String, message: String){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    // MARK: AWS S3
    
    func uploadToS3(completion: (imageUrl: String) -> ()){
        let img = imageView.image
//        let img = UIImage(named: "Logo")
        
        let randomString = randomStringWithLength(10)
        let userId = currentUser[0]["userId"] as String!
        let pathImageName = "\(userId)/\(randomString).png"
        
        let path = NSTemporaryDirectory().stringByAppendingString("image.png")
        let imageData = UIImagePNGRepresentation(img!)
        imageData?.writeToFile(path, atomically: true)
        
        let url = NSURL(fileURLWithPath: path)
        
        uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = "hidden-gems-secrets"
        
        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead
        uploadRequest.key = pathImageName
        uploadRequest.contentType = "image/png"
        uploadRequest.body = url
        
        uploadRequest.uploadProgress = { bytesSent, totalBytesSent, totalBytesExpectedToSend in
//            self.update(totalBytesSent, filesize: totalBytesExpectedToSend)
        }
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject? in
            if let error = task.error {
                print(error)
            } else if let exception = task.exception {
                print("download failed: [\(exception)]")
            } else {
                let url = "https://s3-us-west-2.amazonaws.com/hidden-gems-secrets/\(pathImageName)"
//                print("URL: \(url)")
                completion(imageUrl: url)
            }
            return nil
        }
    }
    
//    func update(amountUploaded: Int64, filesize: Int64){
//        let percentage = (Float(amountUploaded)/Float(filesize)) * 100
//        updateLabel.text = String(format: "Uploading: %.0f%%", percentage)
//    }
    
    func randomStringWithLength (length : Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: length)
        
        for _ in 0 ..< length {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 35
    }
}

extension PostViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
//        return true
        return textView.text.characters.count + (text.characters.count - range.length) <= 180;
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.whiteColor() {
            textView.text = nil
            textView.textColor = UIColor(red: 7/255, green: 216/255, blue: 160/255, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.whiteColor()
            textView.text = "Add a description"
        }
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.contentMode = .ScaleAspectFit
        imageView.image = chosenImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension PostViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        latitude = String(coord.latitude)
        longitude = String(coord.longitude)
        
//        print("Lat:\(latitude)\nLng:\(longitude)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locationObj, completionHandler: { (placemarks, e) -> Void in
            if let error = e {
                print("Error:  \(error.localizedDescription)")
            } else {
                let placemark = placemarks!.last! as CLPlacemark
                
                self.city = placemark.locality
                self.state = placemark.administrativeArea
            }
        })
    }
}
