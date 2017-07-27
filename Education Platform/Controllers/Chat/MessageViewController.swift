//
//  MessageViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/2/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift
import DZNEmptyDataSet
import ESPullToRefresh

protocol MessageViewDelegate {
    func updateMessageCounter(counter: Int)
    func OpenChatMessage( groupID : String, name: String, userId: Int64, currentUser: RoleResult)
}

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var constraintsAdded = false

    var delegate: MessageViewDelegate!

    let messageCellIdentifier = "messageCellIdentifier"
    let gradientView = GradientView()
    var currentUser = RoleResult()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "message".localized()

        currentUser = UserDefaultManager.getInstance().getCurrentUser()!
        assignInstallation()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: messageCellIdentifier as String)
        tableView.backgroundColor = Global.colorHeader
        tableView.tableFooterView = UIView()

        let refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)

        let _ = tableView.es_addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
            self?.loadMessages()
        }

        tableView.expriedTimeInterval = 20.0
        tableView.es_startPullToRefresh()

        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        indicator.startAnimating()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UPDATE_BADEGE_RECEIVED"), object: nil, queue: nil, using: self.ReceivedMessage)

        view.addSubview(tableView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            tableView.autoPinEdgesToSuperviewEdges()
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }

    func loadMessages() {
        ChatAPIservices.getGroupContainUser {
            groupResult in
            GroupMessagesData.getInstance().messages.removeAll(keepingCapacity: true)
            GroupMessagesData.getInstance().messages.append(contentsOf: groupResult)

            self.tableView.reloadData()
            self.tableView.es_stopPullToRefresh()
            self.indicator.stopAnimating()
            self.updateTabCounter()
        }
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no_chat_entry".localized()
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "refresh".localized()
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline),
                     NSForegroundColorAttributeName: Global.colorMain]
        return NSAttributedString(string: text, attributes: attrs)
    }

    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.tableView.es_startPullToRefresh()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupMessagesData.getInstance().messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageTableViewCell! = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier  as String) as? MessageTableViewCell

        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none

        cell.bindingData(data: GroupMessagesData.getInstance().messages[indexPath.row], userId: currentUser.User.Id)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Users = GroupMessagesData.getInstance().messages[indexPath.row].Users
        var tempUser = ChatUserResult()
        for user in Users{
            if (user.Id != Int64(currentUser.User.Id)){
                tempUser = user
            }
        }
        self.openChat(groupID: GroupMessagesData.getInstance().messages[indexPath.row].Id,name: tempUser.DisplayName, userId: tempUser.Id )
    }

    func ReceivedMessage(notification: Notification) {
        self.tableView.reloadData()
    }

    func openChat(groupID: String, name: String, userId: Int64) {
        delegate.OpenChatMessage(groupID: groupID, name: name, userId: userId, currentUser: currentUser)
    }

    func assignInstallation() {
        if UserDefaultManager.getInstance().getIsInitApp() == true {
            //            ParseMessage.saveUserToInstallation(IdUser: currentUser.User.Id)
        }
    }

    func updateTabCounter() {
        let total = GroupMessagesData.getInstance().getCounter()

        if (self.delegate != nil)
        {
            self.delegate.updateMessageCounter(counter: total)
        }
    }
}
