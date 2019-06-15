//
//  Global.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/17/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//public let db = Firestore.firestore()

// Global color variables
struct MyColors {
    
    static let WHITE = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)              // #ffffff
    
    static let PURPLE = UIColor(red:0.64, green:0.45, blue:1.00, alpha:1.0)             // #a472ff
    static let BLUE = UIColor(red:0.51, green:0.56, blue:1.00, alpha:1.0)               // #838eff
    static let HORIZONTAL_GRADIENT = UIColor(patternImage: UIImage(named: "horizontalGradient")!)

    static let LIGHT_GRAY = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)           // #f0f0f0
    static let MEDIUM_GRAY = UIColor(red:0.44, green:0.44, blue:0.47, alpha:1.0)        // #6f7179
    static let DARK_GRAY = UIColor(red:0.25, green:0.32, blue:0.31, alpha:1.0)          // #40514e
    
    static let TRANSPARENT_WHITE = UIColor(red:0.96, green:0.96, blue:0.96, alpha:0.2)
    static let TRANSPARENT_BLACK = UIColor(red:0.04, green:0.04, blue:0.04, alpha:0.1)
    
    static let LOADING_BLACK = UIColor(red:0.04, green:0.04, blue:0.04, alpha:0.95)
    static let DISABLED_BLACK =  UIColor(red:0.04, green:0.04, blue:0.04, alpha:0.4)
}

struct MyDimensions {
    
    static let profilePicSize = 500         // Request 500x500 image from Google profile
    static let navBarProfileButtonSize = 30        // Use smaller images for nav bar
    static let debateCellProfilePicSize = 50
    static let navBarBackButtonSize = 23
    static let navBarSearchButtonSize = 20
    
    static let buttonCornerRadius = CGFloat(20)
    static let buttonBorderWidth = CGFloat(2)
    static let profileButtonBorderWidth = CGFloat(1)
    
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    static let topViewHeight = 190
    static let bottomViewHeight = screenHeight / 4
    static let detailViewHeight = Int(screenHeight) - topViewHeight - Int(bottomViewHeight) - Int(statusBarHeight)
    static let separatorHeight = 0.5
    
    static let answerChoiceWidthRatio = CGFloat(0.7)
    static let segmentedControlHeight = 40
    
    static let profileViewRadius = CGFloat(30)

}

struct Avenir {
    static let light = "AvenirNext-UltraLight"
    static let regular = "AvenirNext-Regular"
    static let medium = "AvenirNext-Medium"
    static let demiBold = "AvenirNext-DemiBold"
}

struct MyFont {
    
    static let topicPreviewTitleKern = 2
    
    static let answerFont = Avenir.medium
    static let loadingFont = Avenir.regular
    static let questionFont = Avenir.regular
    static let navBarSmallFont = Avenir.medium
    static let navBarLargeFont = Avenir.regular
    static let opponentNameFont = Avenir.regular
    static let pageControlFont = Avenir.regular
    static let pageControlSelectedFont = Avenir.demiBold
    static let messageFont = Avenir.regular
    static let unreadNameFont = Avenir.demiBold
    static let unreadFont = Avenir.medium
    
    static let navBarSmallFontSize = 22
    static let navBarLargeFontSize = 30
    static let opponentNameSize = 18
    static let pageControlSize = 22
    static let messageSize = 17
    static let timeLabelSize = 13
    static let (questionFontSize, answerFontSize) = computeSurveyFontSize()

}

struct MyAnimations {
    
    static let cloudsDuration = 6.0
    static let openTopicPreview = 0.6
    static let closeTopicPreview = 0.6
    
}

func computeSurveyFontSize() -> (CGFloat, CGFloat) {
    
    let height = MyDimensions.screenHeight
    let questionSize = min(height * 0.03, 24)
    let answerSize = min(questionSize - 1, 20)
    return (questionSize, answerSize)
    
}

func createBarButton(image: UIImage, size: Int) -> UIButton {
    let button = UIButton(type: .custom)
    
    let buttonSize = CGFloat(size)
    let imageScaled = image.af_imageAspectScaled(toFit: CGSize(width: buttonSize, height: buttonSize))
    button.setImage(imageScaled, for: .normal)
    
    return button
}

func addProfileBorder(profileButton: UIButton) {
    profileButton.layer.cornerRadius = CGFloat(MyDimensions.navBarProfileButtonSize/2)
    profileButton.layer.borderWidth = MyDimensions.profileButtonBorderWidth
    profileButton.layer.borderColor = MyColors.WHITE.cgColor
}

//func enableFirestoreCache() {
//    let settings = FirestoreSettings()
//    settings.isPersistenceEnabled = true
//    Firestore.firestore().settings = settings
//}

func dateToLabel(date: Date) -> String {
    
    let formatter = DateFormatter()
    
    if (date.isInToday) {
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
    else if (date.isInYesterday) {
        return "Yesterday"
    }
    else if (date.isInThisWeek) {
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    else {
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

func customizeButton(button: UIButton) {
    button.clipsToBounds = true
    button.setTitleColor(MyColors.WHITE, for: .normal)
    button.setBackgroundImage(UIImage(named: "horizontalGradient"), for: .normal)
    button.layer.cornerRadius = button.bounds.height/2
}

