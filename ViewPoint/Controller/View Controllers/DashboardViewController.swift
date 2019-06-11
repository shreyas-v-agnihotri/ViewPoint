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
    
    @IBOutlet weak var pendingChatLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var fixedView: UIView!
    @IBOutlet var tableView: UITableView!
    var profilePic: UIImage = UIImage(named: "defaultProfilePic")!    // Default profile pic
    
    let db = Firestore.firestore()
    private var channels = [Channel]()
    
    var channelsRendered = 0

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
            if (self.channels.isEmpty) {
                self.stopAnimating()
                self.channelsRendered = 0
            }
        }
        
        dataView.addSubview(UIView())   // Disables automatic title collapse by breaking connection between navbar and table view
        
        
        dataView.layer.masksToBounds = false
        dataView.layer.shadowColor = UIColor.darkGray.cgColor
        dataView.layer.shadowOpacity = 0.6
        dataView.layer.shadowOffset = CGSize(width: 0, height: 2)
        dataView.layer.shadowRadius = 6
        dataView.layer.cornerRadius = 5
        
        dataView.layer.shadowPath = UIBezierPath(rect: CGRect(x: dataView.bounds.minX, y: dataView.bounds.minY, width: dataView.bounds.width*9/10, height: dataView.bounds.height)).cgPath
        dataView.layer.shouldRasterize = true
        dataView.layer.rasterizationScale = UIScreen.main.scale
        
        pendingChatLabel.textColor = UIColor(patternImage: UIImage(named: "horizontalGradient")!)
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
        channels.sort()
        
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
        channels.sort()
        
//        tableView.reloadData()
        
        // Animate all rows in section at once
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .fade)
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
        navBar.shadowOffset = CGSize(width: 0, height: 3)
        navBar.shadowRadius = 8
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
        
        db.document("chats/\(channel.id)").getDocument { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error finding channel messages: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            let recentMessage = snapshot.data()!["messagePreview"] as Any
            let timestamp = snapshot.data()!["timestamp"] as! Timestamp
            let recentMessageDate = timestamp.dateValue()
            
            let formatter = DateFormatter()
            var recentMessageTimeLabel: String
            
            if (recentMessageDate.isInToday) {
                formatter.dateFormat = "hh:mm a"
                recentMessageTimeLabel = formatter.string(from: recentMessageDate)
            }
            else if (recentMessageDate.isInYesterday) {
                recentMessageTimeLabel = "Yesterday"
            }
            else if (recentMessageDate.isInThisWeek) {
                formatter.dateFormat = "EEEE"
                recentMessageTimeLabel = formatter.string(from: recentMessageDate)
            }
            else {
                formatter.dateFormat = "MMM d"
                recentMessageTimeLabel = formatter.string(from: recentMessageDate)
            }
            
            KingfisherManager.shared.retrieveImage(with: URL(string: channel.opponent.imageURL)!) { result in
                switch result {
                    
                case .success(let value):
                    cell.customInit(
                        profileImage: value.image.af_imageRounded(withCornerRadius: CGFloat(MyDimensions.profilePicSize/2)),
                        topic: channel.topic,
                        name: channel.opponent.name,
                        messagePreview: recentMessage as! String,
                        time: recentMessageTimeLabel
                    )
                case .failure(let error):
                    print(error)
                    cell.customInit(
                        profileImage: UIImage(named: "defaultProfilePic")!,
                        topic: channel.topic,
                        name: channel.opponent.name,
                        messagePreview: recentMessage as! String,
                        time: recentMessageTimeLabel
                    )
                }
                
                self.channelsRendered += 1
                if (self.channelsRendered == self.channels.count-1) {
                    self.stopAnimating()
                    self.channelsRendered = 0
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


