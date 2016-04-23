//
//  GemImageTableViewCell.swift
//  HiddenGems
//
//  Created by Anthony Williams on 4/12/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit

@objc protocol GemImageTableViewCellDelegate {
    optional func didTapImage()
}

class GemImageTableViewCell: UITableViewCell {

    @IBOutlet weak var gemImageView: UIImageView!
    
    var delegate: GemImageTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        gemImageView.userInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GemImageTableViewCell.fullscreenImage))
        tapGesture.numberOfTapsRequired = 1
        gemImageView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fullscreenImage(){
        delegate?.didTapImage!()
    }
}
