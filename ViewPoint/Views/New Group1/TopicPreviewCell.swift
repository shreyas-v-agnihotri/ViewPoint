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

    // @IBOutlet var topImageViewTopConstraint: NSLayoutConstraint!
}
