//
//  ProgressView.swift
//  HiddenGems
//
//  Created by Anthony Williams on 4/13/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    let progressLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    func setup(){
        let lightBlur = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = frame
        addSubview(blurView)
        
        progressLabel.frame = CGRect(x: 20, y: 0, width: frame.size.width-40, height: 100)
        progressLabel.center.y = frame.size.height/2
        progressLabel.text = "Uploading: 0%"
        progressLabel.textColor = UIColor.blackColor()
        progressLabel.layer.borderColor = UIColor.blueColor().CGColor
        progressLabel.layer.borderWidth = 1.0
        progressLabel.layer.masksToBounds = true
        progressLabel.backgroundColor = UIColor(red: 64/255, green: 196/255, blue: 255/255, alpha: 1)
        addSubview(progressLabel)
    }
    
    func updateLabel(percent: String){
        progressLabel.text = "Uploading: \(percent)%"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
