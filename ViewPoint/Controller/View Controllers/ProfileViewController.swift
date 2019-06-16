//
//  ProfileViewController.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/17/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Presentr
import NVActivityIndicatorView
import SafariServices

class ProfileViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profilePicView: UIImageView!
    var profilePic: UIImage = UIImage(named: "defaultProfilePic")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profilePicView.image = profilePic
        
//        profilePicView.layer.borderColor = UIColor(patternImage: UIImage(named: "horizontalGradient")!).cgColor
//        profilePicView.layer.borderWidth = 5
//        profilePicView.layer.cornerRadius = 100
//        signOutButton.setTitleColor(UIColor(patternImage: UIImage(named: "horizontalGradient")!), for: .normal)
        
        customizeButton(button: signOutButton)
        customizeButton(button: feedbackButton)
        
        nameLabel.text = Auth.auth().currentUser?.displayName
    }
    
    func present(image: UIImage) -> Presentr {
        
        self.profilePic = image
        
        let presenter: Presentr = {
            
            let customPresenter = Presentr(presentationType: .popup)
            customPresenter.transitionType = .coverVerticalFromTop
            
//            customPresenter.transitionType = .coverHorizontalFromRight
            customPresenter.dismissOnSwipe = true
            customPresenter.cornerRadius = MyDimensions.profileViewRadius
            
            customPresenter.dropShadow = PresentrShadow(shadowColor: UIColor.darkGray, shadowOpacity: 0.6, shadowOffset: CGSize(width: 0, height: 2.0), shadowRadius: 2)
            
            return customPresenter
        }()
        
        return presenter
        
    }
    
//    @IBAction func backButtonPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        startAnimating(
            message: "Signing out...",
            messageFont: UIFont(name: MyFont.loadingFont, size: CGFloat(MyFont.navBarSmallFontSize)),
            type: .ballScaleMultiple,
            backgroundColor: MyColors.LOADING_BLACK
        )
        
        GIDSignIn.sharedInstance()?.signOut()
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            stopAnimating()
            return
        }
        
        stopAnimating()
        
        performSegue(withIdentifier: "goToLogIn", sender: self)
        
    }
    
    @IBAction func feedbackPressed(_ sender: Any) {
        let feedbackURL = URL(string: "https://shreyasagnihotri.typeform.com/to/MWeFkf")!
        let safari = SFSafariViewController(url: feedbackURL)
        present(safari, animated: true, completion: nil)
    }
    
}
