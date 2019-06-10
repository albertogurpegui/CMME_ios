//
//  MessagesViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 27/05/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import MessageInputBar
import MessageKit

class MessageViewController: MessagesViewController {
    var member: Member!
    var gmailContact: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        member = Member(name: Firebase.sharedInstance.user?.email ?? "", color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension MessageViewController: MessagesDataSource {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return Firebase.sharedInstance.arrMessages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name)
        //return Sender(id: Firebase.sharedInstance.user?.user.uid , displayName: Firebase.sharedInstance.user?.user.uid)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return Firebase.sharedInstance.arrMessages[indexPath.section]
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: message.sender.displayName, attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1), .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
}

extension MessageViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
}

extension MessageViewController: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = Firebase.sharedInstance.arrMessages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

extension MessageViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let newMessage = Message(
            member: member,
            text: text,
            messageId: UUID().uuidString)
        
        /*let date = Date()
         let format = DateFormatter()
         format.dateFormat = "yyyy-MM-dd"
         
         Firebase.sharedInstance.message.sContent = text
         Firebase.sharedInstance.message.sCreated = format.string(from: date)
         Firebase.sharedInstance.message.sSenderID = Firebase.sharedInstance.user?.user.uid
         Firebase.sharedInstance.message.sReceiverID =
         Firebase.sharedInstance.message.sSenderName = */
        
        Firebase.sharedInstance.arrMessages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}
