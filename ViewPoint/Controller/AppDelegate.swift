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
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let defaults = UserDefaults.standard
//        if defaults.object(forKey: "isFirstTime") == nil {
//            defaults.set("No", forKey: "isFirstTime")
//            defaults.synchronize()
//            let storyboard = UIStoryboard(name: "Main", bundle: nil) //Write your storyboard name
//            let viewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
//            self.window!.rootViewController = viewController
//            self.window!.makeKeyAndVisible()
//        }

        // Set up cloud database and third-party sign ins
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        // Firebase Cloud Messaging (notifications)
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self

        // Customizations
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
        UIApplication.shared.applicationIconBadgeNumber = 0
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
                
        // Set gradient background for nav bar
        let backgroundImage = imageWithGradient(startColor: MyColors.PURPLE, endColor: MyColors.BLUE, size: CGSize(width: UIScreen.main.bounds.size.width, height: 1))
        UINavigationBar.appearance().backgroundColor = UIColor(patternImage: backgroundImage!)
        UINavigationBar.appearance().barTintColor = UIColor(patternImage: backgroundImage!)
        UINavigationBar.appearance().isTranslucent = false

        // Customize text properties
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: MyColors.WHITE, NSAttributedString.Key.font: UIFont(name: MyFont.navBarLargeFont, size: CGFloat(MyFont.navBarLargeFontSize))!]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: MyColors.WHITE, NSAttributedString.Key.font: UIFont(name: MyFont.navBarSmallFont, size: CGFloat(MyFont.navBarSmallFontSize))!]
        
        // Customize back button
        let backArrow = UIImage(named: "leftArrow")!
        let backButtonSize = CGFloat(MyDimensions.navBarBackButtonSize)
        let backArrowScaled = backArrow.af_imageAspectScaled(toFit: CGSize(width: backButtonSize, height: backButtonSize))
        UINavigationBar.appearance().backIndicatorImage = backArrowScaled
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backArrowScaled
        
        // Set gradient background for status bar in iOS 13
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor(patternImage: backgroundImage!)
            
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: MyColors.WHITE, NSAttributedString.Key.font: UIFont(name: MyFont.navBarLargeFont, size: CGFloat(MyFont.navBarLargeFontSize))!]
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: MyColors.WHITE, NSAttributedString.Key.font: UIFont(name: MyFont.navBarSmallFont, size: CGFloat(MyFont.navBarSmallFontSize))!]

            navBarAppearance.setBackIndicatorImage(backArrowScaled, transitionMaskImage: backArrowScaled)
            
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = navBarAppearance
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = navBarAppearance
        }
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

