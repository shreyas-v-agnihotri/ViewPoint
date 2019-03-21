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
import SVProgressHUD

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func signOutPressed(_ sender: Any) {
        
        print("\nAttempting to sign out\n")
        SVProgressHUD.show(withStatus: "Signing out...")
        
        GIDSignIn.sharedInstance()?.signOut()
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        
        print("\nSigned out\n")
        SVProgressHUD.dismiss()
        
        performSegue(withIdentifier: "goToLogIn", sender: self)
        
    }

}
