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
    
    static let topViewHeight = 190
    static let bottomViewHeight = 170
}

struct Topic {
    
    let title: String
    let category: String
    let imageName: String
    
    init(title: String, category: String, imageName: String) {
        self.title = title
        self.category = category
        self.imageName = imageName
    }
}

// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

extension Topic {
    
    static var topicList: [Topic] {
        return [
            Topic(title: "iOS vs Android", category: "Technology", imageName: "iOSvsAndroid"),
            Topic(title: "Legalizing Marijuana", category: "Public Policy", imageName: "marijuana"),
            Topic(title: "Abortion", category: "Public Policy", imageName: "abortion"),
            Topic(title: "Health Care", category: "Public Policy", imageName: "healthcare")
        ]
    }
}

