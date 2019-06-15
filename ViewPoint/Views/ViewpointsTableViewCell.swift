//
//  ViewpointsTableViewCell.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 6/11/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit

class ViewpointsTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userAnswer: UILabel!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentAnswer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customInit(question: String, userImage: UIImage, userAnswer: String, opponentImage: UIImage, opponentAnswer: String) {
        self.questionLabel.text = question
        self.userImageView.image = userImage
        self.userAnswer.text = userAnswer
        self.opponentImageView.image = opponentImage
        self.opponentAnswer.text = opponentAnswer
    }
    
}
