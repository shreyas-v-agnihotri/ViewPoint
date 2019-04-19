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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePicView: UIImageView!
    var profilePic: UIImage = UIImage(named: "defaultProfilePic")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profilePicView.image = profilePic

    }
    
    func present(image: UIImage) -> Presentr {
        
        self.profilePic = image
        
        let presenter: Presentr = {
            
            let customPresenter = Presentr(presentationType: .popup)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissOnSwipe = true
            customPresenter.cornerRadius = MyDimensions.profileViewRadius
            
            customPresenter.dropShadow = PresentrShadow(shadowColor: UIColor.darkGray, shadowOpacity: 0.6, shadowOffset: CGSize(width: 0, height: 2.0), shadowRadius: 2)
            
            return customPresenter
        }()
        
        return presenter
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        print("\nAttempting to sign out\n")
//        SVProgressHUD.show(withStatus: "Signing out...")
        
        GIDSignIn.sharedInstance()?.signOut()
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            return
        }
        
        print("\nSigned out\n")
//        SVProgressHUD.dismiss()
        
        performSegue(withIdentifier: "goToLogIn", sender: self)
        
    }
}
