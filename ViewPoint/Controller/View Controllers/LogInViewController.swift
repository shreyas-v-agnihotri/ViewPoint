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
import NVActivityIndicatorView

class LogInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cloudsView: UIImageView!
    @IBOutlet weak var cloudsViewLeading: NSLayoutConstraint!
    
//    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        
        signInButton.isEnabled = false
        
        startAnimating(
            type: .ballScaleMultiple,
            backgroundColor: MyColors.LOADING_BLACK
        )

        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()
        
        designButton(button: signInButton)
        
        stopAnimating()
        
        signInButton.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show onboarding slides if first time opened
        if !UserDefaults.standard.bool(forKey: "onboarded") {
            self.performSegue(withIdentifier: "goToOnboarding", sender: self)
        }
        
        animateClouds(seconds: MyAnimations.cloudsDuration)
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
        button.layer.cornerRadius = button.bounds.height/2
        button.layer.borderWidth = MyDimensions.signInButtonBorderWidth
        button.layer.borderColor = MyColors.WHITE.cgColor
        
    }
    
    // Present a sign-in with Google window
    @IBAction func googleSignIn(sender: AnyObject) {
//        SVProgressHUD.show()
        GIDSignIn.sharedInstance().signIn()
//        SVProgressHUD.dismiss()
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
                
                if (currentFirebaseUser != nil) {
                    
                    let changeRequest = currentFirebaseUser?.createProfileChangeRequest()
                                        
                    if let googleImageURL = googleUser.profile.imageURL(withDimension: UInt(MyDimensions.profilePicSize)) {
                        changeRequest?.photoURL = googleImageURL
                    }
                    changeRequest?.commitChanges { (error) in
                        if let error = error {
                            print("\nFailed to save Photo URL: \(error)\n")
                            self.performSegue(withIdentifier: "goToDashboard", sender: self)
                        }
                        else {
                            self.performSegue(withIdentifier: "goToDashboard", sender: self)
                        }
                    }
                    
                }

            }
        })
        
        
    }
    
    
    // Start Google OAuth2 Authentication, show authentication window
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
        
        if let aController = viewController {
            present(aController, animated: true) {() -> Void in }
        }
    }
    
    // After Google OAuth2 authentication, close authentication window
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        
        dismiss(animated: true) {() -> Void in }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        _ = Auth.auth().addStateDidChangeListener { (auth, currentFirebaseUser) in
            if (currentFirebaseUser != nil) {
                
                InstanceID.instanceID().instanceID { (result, error) in
                    if let error = error {
                        print("Error fetching remote instance ID: \(error)")
                    } else if let result = result {
                        
                        let tokenRepresentation = ["token": result.token]
                    Firestore.firestore().document("notificationTokens/\(currentFirebaseUser!.uid)").setData(tokenRepresentation)
                    }
                }
            }
        }
    }
}



