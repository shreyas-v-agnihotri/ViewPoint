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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set up cloud database and third-party sign ins
        FirebaseApp.configure()
        // let database = Firestore.firestore()
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
        
        // Customize navigation bar (set gradient background, set font, make opaque)
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "horizontalGradient")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: MyColors.WHITE, NSAttributedString.Key.font: UIFont(name: MyFont.medium, size: MyFont.navBarFontSize)!]
        UINavigationBar.appearance().isTranslucent = false
        
//        // Add shadow under navigation bar -> doesn't seem to work
//        UINavigationBar.appearance().layer.masksToBounds = false
//        UINavigationBar.appearance().layer.shadowColor = UIColor.lightGray.cgColor
//        UINavigationBar.appearance().layer.shadowOpacity = 0.8
//        UINavigationBar.appearance().layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        UINavigationBar.appearance().layer.shadowRadius = 2
        
    }
    
    func setupElongationConfig() {
        
        // Customize ElongationConfig properties
        var config = ElongationConfig()
        config.scaleViewScaleFactor = 0.9
        config.topViewHeight = CGFloat(MyDimensions.topViewHeight)
        config.bottomViewHeight = CGFloat(MyDimensions.bottomViewHeight)
        config.bottomViewOffset = 0
        config.parallaxFactor = 100
        config.separatorHeight = 0.5
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

