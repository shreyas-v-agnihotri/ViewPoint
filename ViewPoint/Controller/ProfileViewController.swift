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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePicView: UIImageView!
    var profilePic: UIImage = UIImage(named: "profilePicGradient")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profilePicView.image = profilePic
        
        if (profilePic != UIImage(named: "profilePicGradient")) {
            profilePicView.layer.borderColor = MyColors.PURPLE.cgColor
            profilePicView.layer.borderWidth = 3
            profilePicView.layer.cornerRadius = self.profilePicView.frame.width/2
        }

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
