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
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topicLabel.textColor = UIColor(patternImage: UIImage(named: "horizontalGradient")!)
        
        profileImage.layer.borderColor = MyColors.PURPLE.cgColor
        profileImage.layer.cornerRadius = profileImage.bounds.width/2
//        self.markRead()
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func customInit(profileImage: UIImage, topic: String, name: String, messagePreview: String, time: String) {
        self.profileImage.image = profileImage
        self.topicLabel.text = topic
        self.nameLabel.text = name
        self.messageLabel.text = messagePreview
        self.timeLabel.text = time
    }
    
    func markUnread() {
//        profileImage.layer.borderWidth = 4
        nameLabel.font = UIFont(name: MyFont.unreadFont, size: nameLabel.font.pointSize)
        messageLabel.font = UIFont(name: MyFont.unreadFont, size: messageLabel.font.pointSize)
        timeLabel.font = UIFont(name: MyFont.unreadFont, size: timeLabel.font.pointSize)
    }
    
    func markRead() {
        profileImage.layer.borderWidth = 0
        nameLabel.font = UIFont(name: MyFont.messageFont, size: nameLabel.font.pointSize)
        messageLabel.font = UIFont(name: MyFont.messageFont, size: messageLabel.font.pointSize)
        timeLabel.font = UIFont(name: MyFont.messageFont, size: timeLabel.font.pointSize)
    }
    
}
