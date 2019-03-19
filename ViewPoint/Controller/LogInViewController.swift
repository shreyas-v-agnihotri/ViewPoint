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

class LogInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cloudsView: UIImageView!
    @IBOutlet weak var cloudsViewLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()
        
        designButton(button: signInButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateClouds(seconds: 6)
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
        
        button.backgroundColor = MyColors.TRANSPARENT_WHITE
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = MyColors.WHITE.cgColor
        
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
                    let profilePictureSize = UInt(exactly: MyDimensions.profilePicSize)
                    
                    if let googleImageURL = googleUser.profile.imageURL(withDimension: profilePictureSize!) {
                        changeRequest?.photoURL = googleImageURL
                        print("\n\(googleImageURL)\n")
                    }
                    changeRequest?.commitChanges { (error) in
                        if let error = error {
                            print("\nFailed to save Photo URL: \(error)\n")
                        }
                        else {
                            print("\nSaved photo URL\n")
                        }
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


