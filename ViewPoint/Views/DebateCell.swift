//
//  DebateCell.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 4/18/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit

class DebateCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topicLabel.textColor = UIColor(patternImage: UIImage(named: "horizontalGradient")!)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
