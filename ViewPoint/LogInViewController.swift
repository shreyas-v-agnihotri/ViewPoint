//
//  ViewController.swift
//  viewPoint
//
//  Created by Shreyas Agnihotri on 3/14/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

let WHITE = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0) //F9F9F9
let TRANSPARENT_WHITE = UIColor(red:0.96, green:0.96, blue:0.96, alpha:0.2)
let GRAY = UIColor(red:0.25, green:0.32, blue:0.31, alpha:1.0)

class LogInViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var cloudsView: UIImageView!
    @IBOutlet weak var cloudsViewLeading: NSLayoutConstraint!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self    // Set the UI delegate of the GIDSignIn object
        GIDSignIn.sharedInstance()?.signInSilently()    // Sign in silently when possible
        
        designButton(button: signInButton)
        googleSignInButton.backgroundColor = TRANSPARENT_WHITE
        googleSignInButton.layer.cornerRadius = 20
        googleSignInButton.layer.borderWidth = 2
        googleSignInButton.layer.borderColor = WHITE.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateClouds(seconds: 8)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cloudsViewLeading.constant = 0
        self.cloudsView.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent     // .default
    }

    func animateClouds(seconds: Double) {
        
        let distance = self.view.bounds.width - self.cloudsView.bounds.width
        self.cloudsViewLeading.constant = distance
        UIView.animate(withDuration: seconds, delay: 0, options: [.curveLinear, .autoreverse, .repeat], animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    func designButton(button: UIButton) {
        
        button.backgroundColor = TRANSPARENT_WHITE
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = WHITE.cgColor
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
            } else {
                print("Log in successful!")
                SVProgressHUD.dismiss()
                //self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
}



