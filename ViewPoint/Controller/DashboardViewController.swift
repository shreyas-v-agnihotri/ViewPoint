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
import Presentr
import NVActivityIndicatorView

class DashboardViewController: UITableViewController, NVActivityIndicatorViewable {
    
    var profilePic: UIImage = UIImage(named: "profilePicWhite")!    // Default profile pic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.stopAnimating(nil)
        }
        
        setProfileButton()
        
//        navigationItem.largeTitleDisplayMode = .never
        view.layer.backgroundColor = MyColors.WHITE.cgColor
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.darkGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.6
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
        self.navigationController?.navigationBar.layer.borderColor = UIColor.clear.cgColor
        self.navigationController?.navigationBar.layer.borderWidth = 0
                
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let currentFirebaseUser = user {
                self.updateUserImage(user: currentFirebaseUser)
            }
        }
        
        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                guard let snapshotChannel = Channel(document: change.document) else {
                    return
                }
                self.channel = snapshotChannel
            }
        }
        
    }
    
    func setProfileButton() {
        
        let profileButton = UIButton(type: .custom)
        profileButton.addTarget(self, action: #selector(self.profileButtonPressed), for: .touchUpInside)
        
        let buttonSize = CGFloat(MyDimensions.navBarButtonSize)
        let profilePicScaled = profilePic.af_imageAspectScaled(toFit: CGSize(width: buttonSize, height: buttonSize))
        profileButton.setImage(profilePicScaled, for: .normal)
        
        profileButton.layer.cornerRadius = buttonSize/2
        profileButton.layer.borderWidth = MyDimensions.profileButtonBorderWidth
        profileButton.layer.borderColor = MyColors.WHITE.cgColor
        
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        self.navigationItem.leftBarButtonItem = profileBarButton
        
    }
    
    func updateUserImage(user: User) {
        
        if let photoURL = user.photoURL {

            let profilePicRadius = CGFloat(MyDimensions.profilePicSize/2)

            let processor = RoundCornerImageProcessor(cornerRadius: profilePicRadius)
            
            KingfisherManager.shared.retrieveImage(with: photoURL, options: [.processor(processor)]) { result in

                switch result {
                case .success(let value):
                    self.profilePic = value.image
                    self.setProfileButton()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    
    @objc func profileButtonPressed(sender: UIButton!) {
        
        let presenter: Presentr = {

            let customPresenter = Presentr(presentationType: .popup)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissOnSwipe = true
            customPresenter.cornerRadius = MyDimensions.profileViewRadius
            
            customPresenter.dropShadow = PresentrShadow(shadowColor: UIColor.darkGray, shadowOpacity: 0.6, shadowOffset: CGSize(width: 0, height: 2.0), shadowRadius: 2)
            
            return customPresenter
        }()
        
        let profileViewController: ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        if (self.profilePic != UIImage(named: "profilePicWhite")) {
            profileViewController.profilePic = self.profilePic
        }
        
        customPresentViewController(presenter, viewController: profileViewController, animated: true, completion: nil)

    }
    
    
    private let db = Firestore.firestore()
    private var channelReference: CollectionReference {
        return db.collection("chats")
    }
    private var channelListener: ListenerRegistration?
    var channel = Channel(name: "test_channel")
    
    @IBAction func buttonPressed(_ sender: Any) {
        
//        channelReference.addDocument(data: channel.representation) { error in
//            if let e = error {
//                print("Error saving channel: \(e.localizedDescription)")
//            }
//        }
        
        let vc = ChatViewController(user: Auth.auth().currentUser!, channel: channel, opponentImage: self.profilePic)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


