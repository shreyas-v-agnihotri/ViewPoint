//
//  Global.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/17/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import Foundation
import UIKit

// Global color variables
struct MyColors {
    
    static let WHITE = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)              // #ffffff
    static let PURPLE = UIColor(red:0.64, green:0.45, blue:1.00, alpha:1.0)             // #a472ff
    static let BLUE = UIColor(red:0.51, green:0.56, blue:1.00, alpha:1.0)               // #838eff
    static let GRAY = UIColor(red:0.25, green:0.32, blue:0.31, alpha:1.0)               // #40514e
    static let TRANSPARENT_WHITE = UIColor(red:0.96, green:0.96, blue:0.96, alpha:0.2)
    
}

struct MyDimensions {
    
    static let profilePicSize = 500         // Request 500x500 image from Google profile
    static let navBarButtonSize = 30        // Use smaller images for nav bar
    
    static let buttonCornerRadius = CGFloat(20)
    static let buttonBorderWidth = CGFloat(2)
    static let profileButtonBorderWidth = CGFloat(1)
    
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    static let topViewHeight = 190
    static let bottomViewHeight = 223
    static let detailViewHeight = Int(screenHeight) - Int(statusBarHeight) - topViewHeight - bottomViewHeight // - computeDetailViewAdjustment(statusBarHeight: statusBarHeight)
    
    static let answerChoiceWidthRatio = CGFloat(0.7)
    
    static let profileViewRadius = CGFloat(30)

}

struct MyFont {

    static let normal = "Avenir Next"
    static let medium = "AvenirNext-Medium"
    
    static let topicPreviewTitleKern = 2
    
    static let navBarFontSize = CGFloat(20)
    static let (questionFontSize, answerFontSize) = computeSurveyFontSize()

}

struct MyAnimations {
    
    static let cloudsDuration = 6.0
    static let openTopicPreview = 0.5
    static let closeTopicPreview = 0.5
    
}

func computeDetailViewAdjustment(statusBarHeight: CGFloat) -> Int {
    
    var modelDependentDetailViewAdjustment = 0
    if statusBarHeight > 20 {
        modelDependentDetailViewAdjustment = Int(statusBarHeight)
    }
    return modelDependentDetailViewAdjustment
}

func computeSurveyFontSize() -> (CGFloat, CGFloat) {
    
    let height = MyDimensions.screenHeight
    
    if height == 480 { return (16, 15) }  // 2G, 3G, 3GS, 4, 4S
    if height == 568 { return (17, 16) }  // 5, 5S, 5C, SE
    if height == 667 { return (18, 17) }  // 6, 6S, 7, 8
    if height == 736 { return (21, 18) }  // 6+, 6S+, 7+, 8+
    if height == 812 { return (23, 19) }  // X, XS
    if height == 896 { return (25, 20) }  // XR, XS Max
    if height > 896 { return (25, 20) }   // Any larger device
    else { return (16, 15) }              // Any smaller device
    
}

