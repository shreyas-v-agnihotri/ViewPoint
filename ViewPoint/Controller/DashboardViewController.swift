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

class DashboardViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "horizontalGradient")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if let currentFirebaseUser = user {
                self.setProfileButton(user: currentFirebaseUser)
            }
            
        }

    }
    
    @objc func profileButtonPressed(sender: UIButton!) {
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    
    func setProfileButton(user: User) {
        
        let profileButton = UIButton(type: .custom)
        profileButton.addTarget(self, action: #selector(self.profileButtonPressed), for: .touchUpInside)

        let profileButtonSize = CGFloat(integerLiteral: MyDimensions.statusProfilePicSize)
        
        let defaultProfileImage = UIImage(named: "profilePicWhite")
        let defaultProfileImageScaled = defaultProfileImage!.af_imageAspectScaled(toFit: CGSize(width: profileButtonSize, height: profileButtonSize))
        profileButton.setImage(defaultProfileImageScaled, for: .normal)
        
        if let photoURL = user.photoURL {

            let profilePicRadius = CGFloat(integerLiteral: MyDimensions.profilePicSize/2)

            let processor = RoundCornerImageProcessor(cornerRadius: profilePicRadius) >> DownsamplingImageProcessor(size: CGSize(width: profileButtonSize, height: profileButtonSize))
            
            KingfisherManager.shared.retrieveImage(with: photoURL, options: [.processor(processor)]) { result in

                switch result {
                case .success(let value):
                    profileButton.setImage(value.image, for: .normal)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        profileButton.layer.cornerRadius = profileButtonSize/2
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = MyColors.WHITE.cgColor
        
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        self.navigationItem.leftBarButtonItem = profileBarButton
    }
}


