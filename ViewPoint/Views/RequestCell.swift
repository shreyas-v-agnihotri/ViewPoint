//
//  RequestCell.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 6/11/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        topicLabel.textColor = UIColor(patternImage: UIImage(named: "horizontalGradient")!)
    }

    func customInit(topic: String) {
        self.topicLabel.text = topic
    }
    
}
