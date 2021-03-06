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
import SafariServices
import EmptyDataSet_Swift

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, EmptyDataSetSource, EmptyDataSetDelegate {
    
    @IBOutlet weak var dataViewSeparator: UIView!
    @IBOutlet weak var pendingDebatesText: UILabel!
    @IBOutlet weak var pendingChatTableView: UITableView!
    @IBOutlet weak var pendingChatLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var fixedView: UIView!
    @IBOutlet var tableView: UITableView!
    var profilePic: UIImage = UIImage(named: "defaultProfilePic")!    // Default profile pic
    
    let db = Firestore.firestore()
    private var channels = [Channel]()
    private var requests = [String]()
    
//    private let refreshControl = UIRefreshControl()
    
    var channelsRendered = 0

    private var channelListener: ListenerRegistration?
    private var requestListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        startAnimating(
            message: "Loading your debates...",
            messageFont: UIFont(name: MyFont.loadingFont, size: CGFloat(MyFont.navBarSmallFontSize)),
            type: .ballScaleMultiple,
            backgroundColor: MyColors.LOADING_BLACK
        )
        
//        enableFirestoreCache()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
//        tableView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        pendingChatTableView.delegate = self
        pendingChatTableView.dataSource = self
        
        tableView.register(UINib(nibName: "DebateCell", bundle: nil), forCellReuseIdentifier: "debate")
        pendingChatTableView.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "pendingChat")
        
        setProfileButton()
        setNavBarShadow()
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let currentFirebaseUser = user {
                self.updateUserImage(user: currentFirebaseUser)
            }
        }
        
        channelListener = db.collection("chats").whereField("users", arrayContains: Auth.auth().currentUser!.uid).addSnapshotListener { querySnapshot, error in
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
        
        requestListener = db.collection("requests").whereField("user", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error listening for request updates: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            var currentRequests: [String] = []
            snapshot.documents.forEach { document in
                currentRequests.append(document.data()["topic"] as! String)
            }
            self.requests = currentRequests
            self.pendingChatTableView.reloadData()
            
            self.updateEmptyViews()
            
            self.pendingChatLabel.text = String(snapshot.documents.count)
        }
        
        pendingChatTableView.showsVerticalScrollIndicator = true
        pendingChatLabel.textColor = MyColors.HORIZONTAL_GRADIENT
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.stopAnimating()
        }
    }
    
    deinit {
        channelListener?.remove()
        requestListener?.remove()
    }
    
    @objc func refresh() {
        tableView.reloadData()
    }
    
    // Deselect selected chat
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func updateEmptyViews() {
        if (self.requests.isEmpty && self.channels.isEmpty) {
            self.pendingChatTableView.isHidden = true
            self.pendingChatLabel.isHidden = true
            self.pendingDebatesText.isHidden = true
            self.dataViewSeparator.isHidden = true
        } else {
            self.pendingChatTableView.isHidden = false
            self.pendingChatLabel.isHidden = false
            self.pendingDebatesText.isHidden = false
            self.dataViewSeparator.isHidden = false
        }
        self.tableView.reloadEmptyDataSet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        verifyGoogleUser(viewController: self)
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return CGFloat(MyDimensions.emptyStateSpaceHeight)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(
            string: "No Debates Yet",
            attributes: [
                NSAttributedString.Key.foregroundColor: MyColors.DARK_GRAY,
                NSAttributedString.Key.font: UIFont(name: MyFont.navBarSmallFont, size: CGFloat(MyFont.navBarSmallFontSize))!
            ]
        )
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let descriptionText: String
        if (requests.isEmpty) {
            descriptionText = "Start by browsing topics and creating a debate request!\n\nWhen opponents with different ViewPoints are found, new debates will automatically be added here."
        } else {
            descriptionText = "When opponents with different ViewPoints are found, new debates will automatically be added here."
        }
        
        return NSAttributedString(
            string: descriptionText,
            attributes: [
                NSAttributedString.Key.foregroundColor: MyColors.DARK_GRAY,
                NSAttributedString.Key.font: UIFont(name: MyFont.opponentNameFont, size: CGFloat(MyFont.opponentNameSize))!
            ]
        )
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -(self.view.bounds.height * 0.15)
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
        
        self.updateEmptyViews()
    }
    
    private func updateChannel(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        channels[index] = channel
        
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .right)
        
        if (self.navigationController?.visibleViewController is ChatViewController) {
            print("Not marking message unread")
        } else {
            let updatedCell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! DebateCell
            updatedCell.markUnread()
        }
        
        tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
        channels.sort()
        self.updateEmptyViews()
    }
    
    private func removeChannel(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        channels.remove(at: index)

        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
        
        self.updateEmptyViews()
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
                    self.profilePic = value.image.af_imageRoundedIntoCircle()
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
            profileVC.present(image: self.profilePic, dashboardVC: self),
            viewController: profileVC,
            animated: true,
            completion: nil
        )
    }
    
    func openFeedbackWindow() {
        let safari = SFSafariViewController(url: URL(string: MyLinks.feedbackSurvey)!)
        present(safari, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == self.pendingChatTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingChat", for: indexPath) as! RequestCell
            let request = requests[indexPath.row]
            cell.customInit(topic: request)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "debate", for: indexPath) as! DebateCell
        
        let channel = channels[indexPath.row]
        
        db.document("chats/\(channel.id)").getDocument { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error finding channel messages: \(error?.localizedDescription ?? "No error description")")
                self.stopAnimating()
                return
            }
            
            if (snapshot.data() == nil) { return }
            let recentMessage = snapshot.data()!["messagePreview"] as Any
            
            let timestamp = snapshot.data()!["timestamp"] as! Timestamp
            let recentMessageTimeLabel: String = dateToLabel(date: timestamp.dateValue())
            
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
                
                if (self.channelsRendered == self.channels.count) {
                    self.stopAnimating()
                    self.channelsRendered = 0
                }
            }
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.pendingChatTableView) {
            return requests.count
        }
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == self.pendingChatTableView) {
            return 40
        }
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        chatButtonPressed(self)

        let selectedCell = tableView.cellForRow(at: indexPath) as! DebateCell
        selectedCell.markRead()
        
        let channel = channels[indexPath.row]
        let vc = ChatViewController(
            user: Auth.auth().currentUser!,
            channel: channel,
            userImage: profilePic,
            opponentImage: selectedCell.profileImage.image!
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}


