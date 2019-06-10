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
        
        startAnimating(
            message: "Loading your chats...",
            messageFont: UIFont(name: MyFont.regular, size: CGFloat(MyFont.navBarSmallFontSize)),
            type: .ballScaleMultiple,
            backgroundColor: MyColors.LOADING_BLACK
        )
        
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
        
        channelListener = db.collection("chats").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error description")")
                return
            }
            snapshot.documentChanges.forEach { change in
                self.handleChannelChange(change)
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
    
    func handleChannelChange(_ change: DocumentChange) {
        
        let channel = Channel(document: change.document)
        
        switch change.type {
            case .added:
                addChannel(channel)
            case .modified:
                updateChannel(channel)
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

        
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .right)
    }
    
    private func updateChannel(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        channels[index] = channel
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .right)
    }
    
    private func removeChannel(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        channels.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "debate", for: indexPath) as! DebateCell
        
        let channel = channels[indexPath.row]
        var recentMessage: Any = "New debate!"
        db.collection("chats/\(channel.id)/messages").order(by: "created").getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error finding channel messages: \(error?.localizedDescription ?? "No error description")")
                return
            }
            if (!snapshot.isEmpty) {
                recentMessage = snapshot.documents[snapshot.documents.count-1].data()["content"]!
                
                KingfisherManager.shared.retrieveImage(with: URL(string: channel.opponent.imageURL)!) { result in
                    switch result {
                    case .success(let value):
                        
                        cell.customInit(
                            profileImage: value.image.af_imageRounded(withCornerRadius: CGFloat(MyDimensions.profilePicSize/2)),
                            topic: channel.topic,
                            name: channel.opponent.name,
                            messagePreview: recentMessage as! String,
                            time: "02:42"
                        )
                    case .failure(let error):
                        print(error)
                        cell.customInit(
                            profileImage: UIImage(named: "defaultProfilePic")!,
                            topic: channel.topic,
                            name: channel.opponent.name,
                            messagePreview: recentMessage as! String,
                            time: "02:42"
                        )
                    }
                    
                    if (indexPath.row == self.channels.count-1) {
                        self.stopAnimating()
                    }
                }
            }
        }

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
        let currentCell = tableView.cellForRow(at: indexPath) as! DebateCell
        let channel = channels[indexPath.row]
        let vc = ChatViewController(
            user: Auth.auth().currentUser!,
            channel: channel,
            opponentImage: currentCell.profileImage.image!
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


