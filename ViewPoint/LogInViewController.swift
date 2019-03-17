//
//  ViewController.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/14/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

let WHITE = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0) //F9F9F9
let TRANSPARENT_WHITE = UIColor(red:0.96, green:0.96, blue:0.96, alpha:0.2)
let GRAY = UIColor(red:0.25, green:0.32, blue:0.31, alpha:1.0)

class LogInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cloudsView: UIImageView!
    @IBOutlet weak var cloudsViewLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self    // Set the UI delegate of the GIDSignIn object
        GIDSignIn.sharedInstance()?.signInSilently()    // Sign in silently when possible
        
        designButton(button: signInButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateClouds(seconds: 8)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetClouds()
    }

    func animateClouds(seconds: Double) {
        
        let distance = self.view.bounds.width - self.cloudsView.bounds.width
        self.cloudsViewLeading.constant = distance
        UIView.animate(withDuration: seconds, delay: 0, options: [.curveLinear, .autoreverse, .repeat], animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    func resetClouds() {
        self.cloudsViewLeading.constant = 0
        self.cloudsView.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
    }
    
    func designButton(button: UIButton) {
        
        button.backgroundColor = TRANSPARENT_WHITE
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = WHITE.cgColor
        
    }

    
    // Present a sign-in with Google window
    @IBAction func googleSignIn(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor googleUser: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = googleUser.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
                
        // Sign user in to Firebase
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (firebaseUser, error) in
            if let error = error {
                print("\nLogin error: \(error.localizedDescription)\n")
                return
            }
            
            _ = Auth.auth().addStateDidChangeListener { (auth, currentFirebaseUser) in
                
                if currentFirebaseUser?.photoURL == nil {
                    let changeRequest = currentFirebaseUser?.createProfileChangeRequest()
                    if let googleImageURL = googleUser.profile.imageURL(withDimension: 250) {
                        changeRequest?.photoURL = googleImageURL
                    }
                    changeRequest?.commitChanges { (error) in
                        print("\nFailed to set URL\n")
                    }
                }
            }
        })
        
        performSegue(withIdentifier: "goToDashboard", sender: self)
    }
    
    
    // Start Google OAuth2 Authentication
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
        
        // Show OAuth2 authentication window
        if let aController = viewController {
            present(aController, animated: true) {() -> Void in }
        }
    }
    
    // After Google OAuth2 authentication
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        // Close OAuth2 authentication window
        dismiss(animated: true) {() -> Void in }
    }
    
    
}



