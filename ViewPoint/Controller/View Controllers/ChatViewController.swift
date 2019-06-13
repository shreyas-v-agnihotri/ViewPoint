import UIKit
import Firebase
import MessageKit
import MessageInputBar
import FirebaseFirestore
import Presentr
import AlamofireImage

final class ChatViewController: MessagesViewController {
    
    private let db = Firestore.firestore()

    private var reference: CollectionReference?

    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?

    private let user: User
    private let channel: Channel
    private let userImage: UIImage
    private let opponentImage: UIImage

    init(user: User, channel: Channel, userImage: UIImage, opponentImage: UIImage) {
        self.user = user
        self.channel = channel
        self.userImage = userImage
        self.opponentImage = opponentImage
        super.init(nibName: nil, bundle: nil)

        title = channel.topic
    }

    deinit {
        messageListener?.remove()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableFirestoreCache()
        
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(UIView())   // Disables automatic title collapse by breaking connection between navbar and tableview
        
        setOpponentProfileButton()
        configureMessageCollectionView()
        
//        guard let id = channel.id else {
//            navigationController?.popViewController(animated: true)
//            return
//        }
        
        let id = channel.id
        reference = db.collection(["chats", id, "messages"].joined(separator: "/"))
        
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        designMessageInputBar()
        
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
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].sender == messages[indexPath.section - 1].sender
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].sender == messages[indexPath.section + 1].sender
    }
    
    
    func configureMessageCollectionView() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        
//        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 22)))
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        
        // Set outgoing avatar to overlap with the message bubble
//        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 29, bottom: 17.5, right: 0)))
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: 17.5, right: 0)))
        
        layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -17.5, left: -18, bottom: 17.5, right: 18))
        
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
    }
    
    func designMessageInputBar() {
        messageInputBar.inputTextView.tintColor = MyColors.PURPLE
        messageInputBar.sendButton.setTitleColor(MyColors.PURPLE, for: .normal)
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "upArrow")!
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.textViewPadding.right = -38
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = MyColors.BLUE
                })
            }.onDisabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
                })
        }
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section == 0 {
            return NSAttributedString(
                string: "",
                attributes: [NSAttributedString.Key.foregroundColor: MyColors.DARK_GRAY, NSAttributedString.Key.font: UIFont(name: Avenir.regular, size: CGFloat(MyFont.timeLabelSize))!])
        }
        if !isPreviousMessageSameSender(at: indexPath) {
            return NSAttributedString(
                string: dateToLabel(date: message.sentDate),
                attributes: [NSAttributedString.Key.foregroundColor: MyColors.DARK_GRAY, NSAttributedString.Key.font: UIFont(name: Avenir.regular, size: CGFloat(MyFont.timeLabelSize))!])
        }
        return nil
    }
    
//    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
//
//        return (indexPath.section == 0) ? UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0) : .zero
//    }
    
    // MARK: - Helpers

    private func save(_ message: Message) {
        
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
        }
        
        db.document("chats/\(channel.id)").updateData([
            "messagePreview": message.content,
            "timestamp": message.sentDate
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
        
        self.messagesCollectionView.scrollToBottom()
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
        
        let opponentProfileButton = createBarButton(image: opponentImage, size: MyDimensions.navBarProfileButtonSize)
        addProfileBorder(profileButton: opponentProfileButton)
        opponentProfileButton.addTarget(self, action: #selector(self.profileButtonPressed), for: .touchUpInside)
        let opponentProfileBarButton = UIBarButtonItem(customView: opponentProfileButton)
        
        let opponentNameBarButton = UIBarButtonItem(title: channel.opponent.name, style: .plain, target: self, action: #selector(self.profileButtonPressed))
        opponentNameBarButton.isEnabled = false
        opponentNameBarButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: MyColors.WHITE, NSAttributedString.Key.font: UIFont(name: MyFont.opponentNameFont, size: CGFloat(MyFont.opponentNameSize))!], for: .disabled)

        self.navigationItem.rightBarButtonItems = [opponentProfileBarButton, opponentNameBarButton]
        
    }
    
    @objc func profileButtonPressed(sender: UIButton!) {
        
        let opponentProfileVC: OpponentProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OpponentProfileViewController") as! OpponentProfileViewController
        
        customPresentViewController(
            opponentProfileVC.present(
                userImage: self.userImage,
                opponentImage: self.opponentImage,
                questions: self.channel.questions,
                user1Answers: self.channel.user1Answers,
                user2Answers: self.channel.user2Answers,
                userIndex: channel.currentUserIndex,
                opponentIndex: channel.opponentIndex
            ),
            viewController: opponentProfileVC,
            animated: true,
            completion: nil
        )
    }
}



// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.image = opponentImage

    }

    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? MyColors.BLUE : MyColors.LIGHT_GRAY
    }
    
//    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? MyColors.WHITE : MyColors.DARK_GRAY
//    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        return .bubble

    }

}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {

//    func heightForLocation(message: MessageType, at indexPath: IndexPath,
//                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//
//        return 0
//    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
//        if (indexPath.section == 0) { return CGFloat(MyFont.timeLabelSize + 21) }
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? CGFloat(MyFont.timeLabelSize + 11) : 0.5
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? CGFloat(MyFont.timeLabelSize + 27) : 0.5
        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 12 : 0.5
    }
    
    
}


// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    

    // 1
    func currentSender() -> Sender {
        return Sender(id: user.uid, displayName: user.displayName ?? "ViewPoint User")
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
