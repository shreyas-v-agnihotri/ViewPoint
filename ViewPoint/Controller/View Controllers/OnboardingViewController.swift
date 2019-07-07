//
//  OnboardingViewController.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 6/17/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {
    
    @IBOutlet weak var skipButton: UIButton!
    
    let pages = [
        OnboardingItemInfo(informationImage: UIImage(named: "search")!,
                           title: "Welcome to ViewPoint",
                           description: "A debate platform that matches you with people who disagree with you.",
                           pageIcon: UIImage(named: "search")!,
                           color: MyColors.BLUE,
                           titleColor: MyColors.WHITE,
                           descriptionColor: MyColors.WHITE,
                           titleFont: UIFont(name: MyFont.navBarLargeFont, size: CGFloat(MyFont.navBarLargeFontSize))!,
                           descriptionFont: UIFont(name: MyFont.opponentNameFont, size: CGFloat(MyFont.opponentNameSize))!
        ),
        OnboardingItemInfo(informationImage: UIImage(named: "search")!,
                           title: "title",
                           description: "description",
                           pageIcon: UIImage(named: "search")!,
                           color: MyColors.PURPLE,
                           titleColor: MyColors.WHITE,
                           descriptionColor: MyColors.WHITE,
                           titleFont: UIFont(name: MyFont.navBarLargeFont, size: CGFloat(MyFont.navBarLargeFontSize))!,
                           descriptionFont: UIFont(name: MyFont.navBarLargeFont, size: CGFloat(MyFont.navBarLargeFontSize))!
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onboarding = PaperOnboarding()
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0
            )
            view.addConstraint(constraint)
        }
        
        self.skipButton.isHidden = true
        view.bringSubviewToFront(skipButton)
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return pages[index]
    }
    
    func onboardingItemsCount() -> Int {
        return pages.count
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
//        skipButton.isHidden = index == pages.count-1 ? false : true
        if (index == pages.count-1) {
            skipButton.isHidden = false
        }
    }
    
}
