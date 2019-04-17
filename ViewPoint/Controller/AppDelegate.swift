//
//  AppDelegate.swift
//  viewPoint
//
//  Created by Shreyas Agnihotri on 3/14/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import ElongationPreview
import AlamofireImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        // Hot reloading with Injection III
//        #if DEBUG
//            Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")!.load()
//        #endif

        // Set up cloud database and third-party sign ins
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        customizeNavBar()
        
        setupElongationConfig()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // Implement the application:openURL:options: method of your app delegate. The method should call the handleURL method of the GIDSignIn instance, which will properly handle the URL that your application receives at the end of the authentication process.
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    
    // For your app to run on iOS 8 and older, also implement the deprecated application:openURL:sourceApplication:annotation: method.
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func customizeNavBar() {
        
        let backgroundImage = imageWithGradient(startColor: MyColors.PURPLE, endColor: MyColors.BLUE, size: CGSize(width: UIScreen.main.bounds.size.width, height: 1))
        UINavigationBar.appearance().barTintColor = UIColor(patternImage: backgroundImage!)
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "horizontalGradient")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: MyColors.WHITE, NSAttributedString.Key.font: UIFont(name: MyFont.medium, size: CGFloat(MyFont.navBarLargeFontSize))!]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: MyColors.WHITE, NSAttributedString.Key.font: UIFont(name: MyFont.medium, size: CGFloat(MyFont.navBarSmallFontSize))!]
        UINavigationBar.appearance().isTranslucent = false

        
    // Customize navigation bar (set gradient background, set font, make opaque)
//        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "horizontalGradient")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: MyColors.WHITE, NSAttributedString.Key.font: UIFont(name: MyFont.medium, size: MyFont.navBarFontSize)!]
        
        let backArrow = UIImage(named: "left-arrow")?.withRenderingMode(.alwaysOriginal)
        let backButtonSize = CGFloat(MyDimensions.navBarBackButtonSize)
        let backArrowScaled = backArrow?.af_imageAspectScaled(toFit: CGSize(width: backButtonSize, height: backButtonSize))
        
        UINavigationBar.appearance().backIndicatorImage = backArrowScaled
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backArrowScaled
        
    }
    
    func imageWithGradient(startColor:UIColor, endColor:UIColor, size:CGSize, horizontally:Bool = true) -> UIImage? {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        if horizontally {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func setupElongationConfig() {
        
        // Customize ElongationConfig properties
        var config = ElongationConfig()
        config.scaleViewScaleFactor = 0.9
        config.topViewHeight = CGFloat(MyDimensions.topViewHeight)
        config.bottomViewHeight = CGFloat(MyDimensions.bottomViewHeight)
        config.bottomViewOffset = 0
        config.parallaxFactor = 100
        config.separatorHeight = CGFloat(MyDimensions.separatorHeight)
        config.separatorColor = MyColors.WHITE
        
        // Set durations for presenting/dismissing detail screen
        config.detailPresentingDuration = MyAnimations.openTopicPreview
        config.detailDismissingDuration = MyAnimations.closeTopicPreview
        
        // Customize behaviour
        config.headerTouchAction = .collapseOnBoth
        config.forceTouchPreviewInteractionEnabled = false
        
        // Save created appearance object as default
        ElongationConfig.shared = config
        
    }


}

