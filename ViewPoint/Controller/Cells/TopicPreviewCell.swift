//
//  DemoElongationCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 09/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import ElongationPreview
import UIKit

final class TopicPreviewCell: ElongationCell {

    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var localityLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet weak var imageOverlay: UIView!
    
    @IBOutlet var aboutTitleLabel: UILabel!
    @IBOutlet var aboutDescriptionLabel: UILabel!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    func customInit(topic: Topic) {
        
//        customizeButton(button: researchTopicButton)
//        researchTopicButton.addTarget(self, action:#selector(researchTopicPressed), for: .touchUpInside)
        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRegistered))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        self.addGestureRecognizer(swipeRight)

        let spacedTitle = NSMutableAttributedString(
            string: topic.title,
            attributes: [NSAttributedString.Key.kern: MyFont.topicPreviewTitleKern]
        )
        
        self.topImageView?.image = UIImage(named: topic.identifier)
        self.localityLabel?.attributedText = spacedTitle
        self.countryLabel?.text = topic.category
        
//        self.aboutTitleLabel?.text = topic.title
//        self.aboutDescriptionLabel?.text = topic.title
        
        self.aboutTitleLabel.text = "Research This Topic"
        self.aboutDescriptionLabel.text = "\u{2190} Swipe left anywhere on the screen"
        
        self.bottomViewHeight.constant = CGFloat(MyDimensions.bottomViewHeight)
    }
    
//    @objc func swipeRegistered() {
//        print("hello")
//    }
    
}
