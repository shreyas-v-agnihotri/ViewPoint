//
//  DashboardViewController.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/15/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Kingfisher
import AlamofireImage
import Presentr

class DashboardViewController: UIViewController {
    
    var profilePic: UIImage = UIImage(named: "profilePicWhite")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProfileButton()
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let currentFirebaseUser = user {
                self.updateUserImage(user: currentFirebaseUser)
            }
        }
        
    }
    
    func setProfileButton() {
        
        let profileButton = UIButton(type: .custom)
        profileButton.addTarget(self, action: #selector(self.profileButtonPressed), for: .touchUpInside)
        let buttonSize = CGFloat(MyDimensions.navBarButtonSize)
        
        let profilePicScaled = profilePic.af_imageAspectScaled(toFit: CGSize(width: buttonSize, height: buttonSize))
        profileButton.setImage(profilePicScaled, for: .normal)
        
        profileButton.layer.cornerRadius = buttonSize/2
        profileButton.layer.borderWidth = MyDimensions.profileButtonBorderWidth
        profileButton.layer.borderColor = MyColors.WHITE.cgColor
        
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        self.navigationItem.leftBarButtonItem = profileBarButton
        
    }
    
    func updateUserImage(user: User) {
        
        if let photoURL = user.photoURL {

            let profilePicRadius = CGFloat(integerLiteral: MyDimensions.profilePicSize/2)

            let processor = RoundCornerImageProcessor(cornerRadius: profilePicRadius) >> DownsamplingImageProcessor(size: CGSize(width: MyDimensions.navBarButtonSize, height: MyDimensions.navBarButtonSize))
            
            KingfisherManager.shared.retrieveImage(with: photoURL, options: [.processor(processor)]) { result in

                switch result {
                case .success(let value):
                    self.profilePic = value.image
                    self.setProfileButton()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    
    @objc func profileButtonPressed(sender: UIButton!) {
    
        // performSegue(withIdentifier: "goToProfile", sender: self)
        
        let presenter: Presentr = {

            let customPresenter = Presentr(presentationType: .popup)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissOnSwipe = true
            customPresenter.cornerRadius = MyDimensions.profileViewRadius
//            customPresenter.blurBackground = true
//            customPresenter.blurStyle = UIBlurEffect.Style.dark
            return customPresenter
        }()
        
        let profileViewController: ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        customPresentViewController(presenter, viewController: profileViewController, animated: true, completion: nil)

    }
    
    
}


