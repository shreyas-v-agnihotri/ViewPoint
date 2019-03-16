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

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            self.profilePicture.kf.setImage(with: user?.photoURL)

        }



    }
    
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        print("\nAttempting to sign out\n")
        
        GIDSignIn.sharedInstance()?.signOut()
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }

        print("\nSigned out\n")
        performSegue(withIdentifier: "goToLogIn", sender: self)
        
    }
    
    
    
}


