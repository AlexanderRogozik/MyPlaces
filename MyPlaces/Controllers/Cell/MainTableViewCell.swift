//
//  MainTableViewCell.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/22/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit
import Cosmos
class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet{
            cosmosView.settings.updateOnTouch = false 
        }
    }
    @IBOutlet weak var placeImageView: UIImageView! {
        didSet{
            placeImageView.layer.cornerRadius = placeImageView.frame.size.height / 2
            placeImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
}
