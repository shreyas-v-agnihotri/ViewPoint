/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Firebase
import MessageKit
import MessageInputBar
import FirebaseFirestore
import Presentr
import AlamofireImage

final class ChatViewController: MessagesViewController {
    
    let db = Firestore.firestore()

    private var reference: CollectionReference?

    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?

    private let user: User
    private let channel: Channel
    private let opponentImage: UIImage

    init(user: User, channel: Channel, opponentImage: UIImage) {
        self.user = user
        self.channel = channel
        self.opponentImage = opponentImage
        super.init(nibName: nil, bundle: nil)

        title = channel.name
    }

    deinit {
        messageListener?.remove()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func infoPressed() {
        
    }

    override func viewDidLoad() {
        
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(UIView())   // Disables automatic title collapse by breaking connection between navbar and table view
        
        setOpponentProfileButton()
        
//        guard let id = channel.id else {
//            navigationController?.popViewController(animated: true)
//            return
//        }
        
        let id = "hQo9yFPhRu98LbvvWiTX"

        reference = db.collection(["chats", id, "messages"].joined(separator: "/"))

        super.viewDidLoad()

        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = MyColors.PURPLE
        messageInputBar.sendButton.setTitleColor(MyColors.PURPLE, for: .normal)

        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }

            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }

    }

    // MARK: - Helpers

    private func save(_ message: Message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }

            self.messagesCollectionView.scrollToBottom()
        }
    }

    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            return
        }

        switch change.type {
        case .added:
            insertNewMessage(message)
        default:
            break
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    func setOpponentProfileButton() {
        
        let opponentProfileButton = UIButton(type: .custom)
        opponentProfileButton.addTarget(self, action: #selector(self.profileButtonPressed), for: .touchUpInside)
        
        let buttonSize = CGFloat(MyDimensions.navBarButtonSize)
        let profilePicScaled = opponentImage.af_imageAspectScaled(toFit: CGSize(width: buttonSize, height: buttonSize))
        opponentProfileButton.setImage(profilePicScaled, for: .normal)
        
        opponentProfileButton.layer.cornerRadius = buttonSize/2
        opponentProfileButton.layer.borderWidth = MyDimensions.profileButtonBorderWidth
        opponentProfileButton.layer.borderColor = MyColors.WHITE.cgColor
        
        let profileBarButton = UIBarButtonItem(customView: opponentProfileButton)
        
        let opponentName = UIBarButtonItem(title: "John Smithers", style: .plain, target: self, action: #selector(self.profileButtonPressed))

        self.navigationItem.rightBarButtonItems = [profileBarButton, opponentName]
        
    }
    
    @objc func profileButtonPressed(sender: UIButton!) {
        
        // performSegue(withIdentifier: "goToProfile", sender: self)
        
        let presenter: Presentr = {
            
            let customPresenter = Presentr(presentationType: .popup)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissOnSwipe = true
            customPresenter.cornerRadius = MyDimensions.profileViewRadius
            
            customPresenter.dropShadow = PresentrShadow(shadowColor: UIColor.darkGray, shadowOpacity: 0.6, shadowOffset: CGSize(width: 0, height: 2.0), shadowRadius: 2)
            
            return customPresenter
        }()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let profileViewController: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
//        if (self.opponentImage != UIImage(named: "profilePicWhite")) {
            profileViewController.profilePic = self.opponentImage
//        }
        
        customPresentViewController(presenter, viewController: profileViewController, animated: true, completion: nil)
    }


}



// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {

    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {

        // 1
        
//        let horizontalGradient = UIImage(named: "horizontalGradient")!
//        let scaledGradient = horizontalGradient.af_imageAspectScaled(toFit: CGSize(width: MyDimensions.screenWidth, height: MyDimensions.screenHeight))
        
        return isFromCurrentSender(message: message) ? MyColors.BLUE : MyColors.LIGHT_GRAY
    }
    
//    func textColor(for message: MessageType, at indexPath: IndexPath,
//                   in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        
//        return MyColors.WHITE
//    }

    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {

        // 2
        return false
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//
//        // 3
//        return .bubbleTail(corner, .curved)
        
        return .bubble

    }
    
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
//
//    func avatarSize(for message: MessageType, at indexPath: IndexPath,
//                    in messagesCollectionView: MessagesCollectionView) -> CGSize {
//
//        // 1
//        return .zero
//    }

    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {

        // 2
        return CGSize(width: 0, height: 10)
    }

    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {

        // 3
        return 0
    }
}


// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    

    // 1
    func currentSender() -> Sender {
        return Sender(id: user.uid, displayName: "John")
    }

    // 2    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    // 3
    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {

        return messages[indexPath.section]
    }

    // 4
    func cellTopLabelAttributedText(for message: MessageType,
                                    at indexPath: IndexPath) -> NSAttributedString? {

        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: MessageInputBarDelegate {

    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {

        // 1
        let message = Message(user: user, content: text)

        // 2
        save(message)

        // 3
        inputBar.inputTextView.text = ""
    }

}
