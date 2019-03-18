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
    static let TRANSPARENT_WHITE = UIColor(red:0.96, green:0.96, blue:0.96, alpha:0.2)
    static let GRAY = UIColor(red:0.25, green:0.32, blue:0.31, alpha:1.0)
    
}

struct MyDimensions {
    
    static let profilePicSize = 500         // Request 500x500 image from Google profile
    static let statusProfilePicSize = 30    // Use smaller icon for status bar
}

struct Topic {
    var title: String
}
    
let iOSvsAndroid = Topic(title: "iOS vs Android")
let Abortion = Topic(title: "Pro-Choice vs Pro-Life")

var topics = [iOSvsAndroid, Abortion]

