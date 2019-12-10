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
        OnboardingItemInfo(informationImage: UIImage(named: "eyeIcon")!.af_imageScaled(to: CGSize(width: MyDimensions.profilePicSize, height: MyDimensions.profilePicSize)),
                           title: "Welcome to ViewPoint",
                           description: "A chat app that matches you with people who disagree with you!",
                           pageIcon: UIImage(named: "search")!,
                           color: MyColors.MEDIUM_GRAY,
                           titleColor: MyColors.WHITE,
                           descriptionColor: MyColors.WHITE,
                           titleFont: UIFont(name: MyFont.onboardingTitleFont, size: CGFloat(MyFont.onboardingTitleFontSize))!,
                           descriptionFont: UIFont(name: MyFont.opponentNameFont, size: CGFloat(MyFont.opponentNameSize))!
        ),
        OnboardingItemInfo(informationImage: UIImage(named: "topicsGrayscale")!,
                           title: "Explore Debate Topics",
                           description: "Browse and research a growing list of controversial debate topics.",
                           pageIcon: UIImage(named: "search")!,
                           color: MyColors.DARK_GRAY,
                           titleColor: MyColors.WHITE,
                           descriptionColor: MyColors.WHITE,
                           titleFont: UIFont(name: MyFont.onboardingTitleFont, size: CGFloat(MyFont.onboardingTitleFontSize))!,
                           descriptionFont: UIFont(name: MyFont.opponentNameFont, size: CGFloat(MyFont.opponentNameSize))!
        ),
        OnboardingItemInfo(informationImage: UIImage(named: "surveyGrayscale")!,
                           title: "Create Debate Requests",
                           description: "Fill out short surveys on the topics of your choice to help us match you with the right opponents.",
                           pageIcon: UIImage(named: "search")!,
                           color: MyColors.MEDIUM_GRAY,
                           titleColor: MyColors.WHITE,
                           descriptionColor: MyColors.WHITE,
                           titleFont: UIFont(name: MyFont.onboardingTitleFont, size: CGFloat(MyFont.onboardingTitleFontSize))!,
                           descriptionFont: UIFont(name: MyFont.opponentNameFont, size: CGFloat(MyFont.opponentNameSize))!
        ),
        OnboardingItemInfo(informationImage: UIImage(named: "chatsGrayscale")!,
                           title: "Start Chatting!",
                           description: "When we find someone with different survey answers, we’ll automatically create a real-time chat for you and your opponent!",
                           pageIcon: UIImage(named: "search")!,
                           color: MyColors.DARK_GRAY,
                           titleColor: MyColors.WHITE,
                           descriptionColor: MyColors.WHITE,
                           titleFont: UIFont(name: MyFont.onboardingTitleFont, size: CGFloat(MyFont.onboardingTitleFontSize))!,
                           descriptionFont: UIFont(name: MyFont.opponentNameFont, size: CGFloat(MyFont.opponentNameSize))!
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
        if (index == pages.count-1) {
            skipButton.isHidden = false
        }
    }
    
}
