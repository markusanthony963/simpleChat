//
//  ChatViewController.swift
//  simpleChating
//
//  Created by iosdev on 9/30/17.
//  Copyright © 2017 ios3-umn. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    
    lazy var  outgoingBubbleImageView :  JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView : JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private lazy var messageRef: DatabaseReference = self.channelRef!.child("messages")
    private var newMessageRefHandle: DatabaseHandle?
    var channelRef : DatabaseReference?
    
    var messages = [JSQMessage]()
    var channel: Channel? {
        didSet{
        title =  channel?.name
        }
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
        "senderId": senderId!,
        "senderName": senderDisplayName!,
        "text": text!,
        ]
        
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        
    }

    private func setupOutgoingBubble() -> JSQMessagesBubbleImage{
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage{
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    
    }
    
    private func addMessage(with id: String, name : String, text: String){
        if let message = JSQMessage(senderId: id, displayName: name, text: text){
        messages.append(message)
        }
    }
    
    private func observeMessages(){
    messageRef = channelRef!.child("messages")
        let messageQuery = messageRef.queryLimited(toLast: 25)
    
    
    newMessageRefHandle =  messageQuery.observe(.childAdded, with: {(snapshot)-> Void in
    
    let messageData = snapshot.value as! Dictionary<String,String>
    if let id = messageData["senderId"] as String!,
        let name = messageData["senderName"] as String!,
        let text = messageData["text"] as String!,
        text.characters.count > 0 {
        
        self.addMessage(with: id, name: name, text: text)
        self.finishReceivingMessage()
        }else{
        print("Error djieng")
        }
    
    })
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        switch message.senderId {
        case self.senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else{
            assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 13
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId{
        return outgoingBubbleImageView
        }else{
        return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(messages)
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        if message.senderId == senderId{
        cell.textView?.textColor = UIColor.white
        }else{
        cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = Auth.auth().currentUser?.uid
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        observeMessages()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
