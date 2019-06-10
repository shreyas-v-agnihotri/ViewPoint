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

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var fixedView: UIView!
    @IBOutlet var tableView: UITableView!
    var profilePic: UIImage = UIImage(named: "defaultProfilePic")!    // Default profile pic
    
    let db = Firestore.firestore()
    private var channels = [Channel]()

    private var channelListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        enableFirestoreCache()
        
        tableView.register(UINib(nibName: "DebateCell", bundle: nil), forCellReuseIdentifier: "debate")
        
        setProfileButton()
        setNavBarShadow()
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let currentFirebaseUser = user {
                self.updateUserImage(user: currentFirebaseUser)
            }
        }
        
//        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
//            guard let snapshot = querySnapshot else {
//                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error description")")
//                return
//            }
//
//            snapshot.documentChanges.forEach { change in
//                guard let snapshotChannel = Channel(document: change.document) else {
//                    return
//                }
//                self.channel = snapshotChannel
//            }
//        }
        
//        channelListener = db.collection("chats").whereField("users", arrayContains: Auth.auth().currentUser?.uid as Any)
//            .addSnapshotListener { querySnapshot, error in
//                guard let snapshot = querySnapshot else {
//                    print("Error listening for channel updates: \(error?.localizedDescription ?? "No error description")")
//                    return
//                }
//                print(snapshot)
//                snapshot.documentChanges.forEach { change in
//                    self.handleDocumentChange(change)
//                }
//        }
        
        channelListener = db.collection("chats").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error description")")
                return
            }
            print("Snapshots: \(snapshot.documents.count)")
            snapshot.documentChanges.forEach { change in
                print("handling change")
                self.handleDocumentChange(change)
            }
        }

    }
    
    deinit {
        channelListener?.remove()
    }
    
    // Deselect selected chat
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func handleDocumentChange(_ change: DocumentChange) {
        
        let channel = Channel(document: change.document)
        
        print("change type: \(change.type)")
        switch change.type {
            case .added:
                addChannel(channel)
            case .modified:
                return
            case .removed:
                removeChannel(channel)
            @unknown default:
                return
            }
    }
    
    private func addChannel(_ channel: Channel) {
        guard !channels.contains(channel) else {
            return
        }
        
        channels.append(channel)
        
        tableView.reloadData()
    }
    
    private func removeChannel(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        channels.remove(at: index)
        tableView.reloadData()
    }
    
    func setNavBarShadow() {
        let navBar = self.navigationController!.navigationBar.layer
        navBar.masksToBounds = false
        navBar.shadowColor = UIColor.darkGray.cgColor
        navBar.shadowOpacity = 0.6
        navBar.shadowOffset = CGSize(width: 0, height: 3.0)
        navBar.shadowRadius = 3
        navBar.borderColor = UIColor.clear.cgColor
        navBar.borderWidth = 0
    }
    
    func setProfileButton() {
        
        let profileButton = createBarButton(image: profilePic, size: MyDimensions.navBarProfileButtonSize)
        addProfileBorder(profileButton: profileButton)
        profileButton.addTarget(self, action: #selector(self.profileButtonPressed), for: .touchUpInside)
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

    
    @objc func profileButtonPressed(sender: Any) {
        
        let profileVC: ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        customPresentViewController(
            profileVC.present(image: self.profilePic),
            viewController: profileVC,
            animated: true,
            completion: nil
        )
        

    }
    
//    @IBAction func chatButtonPressed(_ sender: Any) {
//
////        channelReference.addDocument(data: channel.representation) { error in
////            if let e = error {
////                print("Error saving channel: \(e.localizedDescription)")
////            }
////        }
//
//        let vc = ChatViewController(user: Auth.auth().currentUser!, channel: channel, opponentImage: UIImage(named: "defaultProfilePic")!)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "debate", for: indexPath) as! DebateCell
        
        let channel = channels[indexPath.row]
        cell.customInit(
            profileImage: UIImage(named: "defaultProfilePic")!,
            topic: channel.topic,
            name: "John Smithers",
            messagePreview: "Actually, marijuana has valuable medicinal properties.",
            time: "02:42"
        )

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        chatButtonPressed(self)
        let channel = channels[indexPath.row]
        let vc = ChatViewController(user: Auth.auth().currentUser!, channel: channel, opponentImage: UIImage(named: "defaultProfilePic")!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


