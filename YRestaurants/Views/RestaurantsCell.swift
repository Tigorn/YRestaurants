//
//  RestaurantsCell.swift
//  YRestaurants
//
//  Created by Vladimir Svetlanov on 02/11/2018.
//  Copyright © 2018 Svetlanov Vladimir. All rights reserved.
//

import UIKit

class RestaurantsCell: UITableViewCell {
    
    struct Constants {
        public static let imageSize: CGSize = CGSize(width: 100, height: 75)
        public static let estimatedHeight: CGFloat = imageSize.height
    }
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageWidthConstraint.constant = Constants.imageSize.width
        imageHeightConstraint.constant = Constants.imageSize.height
    }
}
