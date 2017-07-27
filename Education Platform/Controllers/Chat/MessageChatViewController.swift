//
//  MessageChatViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/8/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift
import JSQMessagesViewController
import Kingfisher
import SwiftyJSON
import DZNEmptyDataSet
import ESPullToRefresh

protocol MessageChatReloadDelegate: class {
    func didMovetoMessage()
}

class MessageChatViewController: JSQMessagesViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var groupId:String = ""
    var Name: String = ""
    var userId: Int64 = 0
    var CurrentUser = RoleResult()

    open weak var delegate: MessageChatReloadDelegate?

    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: Global.colorMain)
    let outgoingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero).outgoingMessagesBubbleImage(with: Global.colorIncomMessage)
    var messages = [JSQMessage]()

    var users = [ChatUserResult]()

    var avatars = Dictionary<Int64, JSQMessagesAvatarImage>()

    var isLoading = false

    var timer:Timer?

    var firstLayout = true

    var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        automaticallyScrollsToMostRecentMessage = true
        ChatAPIservices.getUsersSameGroup(groupId: groupId) { (usersData) in
            self.users = usersData
        }

        self.navigationController?.navigationBar.backItem?.title = " "

        self.setup()

        self.loadChat(isLoadMore: false)

        self.seenChat()

        SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text:"loading".localized())

        let refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let _ = self.collectionView.es_addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
            self?.loadMoreMessage()
        }

        collectionView.collectionViewLayout.outgoingAvatarViewSize = .zero
        collectionView.collectionViewLayout.springinessEnabled = false

        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self

        collectionView.reloadData()
        collectionView.layoutIfNeeded()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKETISRECEIVED"), object: nil, queue: nil, using: self.ReceivedMessage)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKETISTYPING"), object: nil, queue: nil, using: self.TypingMessage)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.collectionViewLayout.springinessEnabled = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dismiss(animated: true) {
            self.delegate?.didMovetoMessage()
            SwiftOverlays.removeAllBlockingOverlays()
        }
    }

    func setLanguageRuntime(){

    }


    func seenChat() {
        ChatAPIservices.seenGroup(groupId: self.groupId) { (Success) in
            if(Success == true)
            {
                ChatAPIservices.loadBagdeMessage()
            }
        }
    }
    func loadMoreMessage(){
        if(self.isLoading) {
            self.collectionView.es_stopPullToRefresh()
            return
        }
        self.loadChat(isLoadMore: true)
    }

    func loadChat(isLoadMore: Bool) {
        if(isLoading == false ) {
            self.isLoading = true
            if isLoadMore {
                self.currentPage = self.currentPage + 1
            }

            ChatAPIservices.getChatbyGroupId(CurrentPage: self.currentPage, PageSize: 30, GroupId: groupId, completion: { (messagesResult) in
                let objects = messagesResult.Messages

                if !isLoadMore {
                    for object in objects
                    {
                        self.addMessage(object: object, isLoadingMore: isLoadMore )
                    }
                    self.finishReceivingMessage(animated: true)
                    //self.reloadMessagesView()
                }
                else {
                    if objects.count > 0 {
                        let histories = objects.reversed()
                        let oldBottomOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y

                        self.collectionView.performBatchUpdates({
                            let lastIdx = histories.count - 1
                            var indexPaths: [AnyObject] = []
                            for i in 0...lastIdx {
                                indexPaths.append(NSIndexPath(item: i, section: 0))
                            }

                            // insert messages and update data source.
                            for object in histories  {
                                let message: JSQMessage!
                                message = JSQMessage(senderId: String(object.User.Id), senderDisplayName: object.User.DisplayName, date:  Utils.stringtoDate(string: object.updated_time), text: object.Message)
                                self.messages.insert(message, at: 0)
                            }

                            self.collectionView.insertItems(at: indexPaths as! [IndexPath])

                            // invalidate layout
                            self.collectionView.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext())

                        }, completion: { (isFinish) in
                            self.finishReceivingMessage(animated: false)
                            self.collectionView.layoutIfNeeded()

                            self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - oldBottomOffset)
                            // self.collectionView.collectionViewLayout.springinessEnabled = true
                        })
                    }
                    else{
                        self.collectionView.es_removeRefreshHeader()
                    }
                }
                self.collectionView.es_stopPullToRefresh()
                self.isLoading = false
                SwiftOverlays.removeAllBlockingOverlays()
            })
        }
    }

    func addMessage(object : ChatRowResult, isLoadingMore: Bool) {
        let message: JSQMessage!
        message = JSQMessage(senderId: String(object.User.Id), senderDisplayName: object.User.DisplayName, date:  Utils.stringtoDate(string: object.updated_time), text: object.Message)
        messages.append(message)
        self.finishReceivingMessage(animated: true)

    }

    func ReceivedMessage(notification:Notification) {
        guard   let userInfo = notification.userInfo,
            let Message = userInfo["Message"] as? String,
            let SenderID = userInfo["UserId"] as? String,
            let GroupId = userInfo["groupId"] as? String
            else {
                return
        }

        if(groupId == GroupId) {
            if(CurrentUser.User.Id == Int(SenderID))
            {
                return
            }
            else {
                let user = self.returnUserdataHas(Id: SenderID)
                let message = JSQMessage(senderId: SenderID, senderDisplayName: user.DisplayName, date:  Date(), text: Message)

                self.showTypingIndicator = false;
                messages.append(message!)
                JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                self.finishReceivingMessage(animated: true)
            }
        }
    }

    func TypingMessage(notification:Notification) {
        guard   let userInfo = notification.userInfo,
            let SenderID = userInfo["UserId"] as? String,
            let GroupId = userInfo["groupId"] as? String
            else {
                return
        }

        if(groupId == GroupId)
        {
            if(CurrentUser.User.Id != Int(SenderID))
            {
                self.showTypingIndicator = true
                self.scrollToBottom(animated: true)
            }

        }
    }

    func sendMessage(_ text: String, image: UIImage?, video:URL?) {
        let data:JSON = ["Action":"SEND_MESSAGE","Message":text,"GroupId":groupId]
        WebSocketServices.shared.Write(message: data.rawString()!)
        let message = JSQMessage(senderId: String(CurrentUser.User.Id), senderDisplayName: CurrentUser.User.DisplayName, date:  Date(), text: text)
        messages.append(message!)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage(animated: true)

    }

    func returnUserdataHas(Id: String) -> ChatUserResult {
        var temp = ChatUserResult()
        for each in users {
            if (each.Id  == Int64(Id)) {
                temp = each
                break
            }
        }
        return temp
    }

    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }

    func setup() {
        self.senderId = String(CurrentUser.User.Id)
        self.senderDisplayName = CurrentUser.User.DisplayName

        self.navigationItem.title = self.Name
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return  self.messages[indexPath.row]
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        self.messages.remove(at: indexPath.row)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {

        let message = messages[indexPath.row]

        let user = self.returnUserdataHas(Id: message.senderId)

        if(user.Id != Int64(CurrentUser.User.Id))
        {
            if self.avatars[user.Id] == nil {
                if Utils.verifyUrl(urlString: user.Avatar)
                {
                    ImageDownloader.default.downloadImage(with: URL(string: user.Avatar)!, options: [], progressBlock: nil) {
                        (image, error, url, data) in
                        if(error == nil)
                        {
                            self.avatars[user.Id] = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 25)
                            self.collectionView.reloadData()
                        }
                    }
                }
                return JSQMessagesAvatarImage(placeholder: UIImage(named: "ic_user"))
            } else {
                return self.avatars[user.Id]
            }
        }
        else{
            return nil
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]

        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.white

        }
        return cell
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {

        let message = self.messages[indexPath.item]

        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }

        if indexPath.item - 1 > 0
        {
            let preMessage = self.messages[indexPath.item - 1]
            if (message.date.timeIntervalSince(preMessage.date) / 60 > 1)
            {
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            }
        }

        return nil
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {

        if indexPath.item == 0
        {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }

        if indexPath.item - 1 > 0
        {
            let message = self.messages[indexPath.item]
            let preMessage = self.messages[indexPath.item - 1]

            if (message.date.timeIntervalSince(preMessage.date) / 60 > 1) {
                return kJSQMessagesCollectionViewCellLabelHeightDefault;
            }

        }
        return 0.0
    }


    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {

        self.sendMessage(text, image: nil, video: nil)

    }

    override func didPressAccessoryButton(_ sender: UIButton!) {

    }

    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        let textLength = textView.text.length()
        self.showTypingIndicator = false
        if(textLength == 1)
        {
            let data:JSON = ["Action":"TYPING","GroupId":groupId]
            WebSocketServices.shared.Write(message: data.rawString()!)
        }
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "message_to_your_friend".localized() + " \(Name)"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "send_a_message".localized()
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline),
                     NSForegroundColorAttributeName: Global.colorMain]
        return NSAttributedString(string: text, attributes: attrs)
    }

    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.inputToolbar.contentView.textView.becomeFirstResponder()
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
