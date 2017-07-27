//
//  UserMessageViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/30/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift
import SwiftyJSON
import DZNEmptyDataSet
import ESPullToRefresh

protocol SelectSingleViewControllerDelegate: class {
    func didSelectSingleUser(_ user: ChatUserResult)
}

class UserMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var constraintsAdded = false

    let messageChatCellIdentifier = "messageChatCellIdentifier"
    open weak var delegate: SelectSingleViewControllerDelegate?
    var users = [ChatUserResult]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UINib(nibName: "UserChatTableViewCell", bundle: nil), forCellReuseIdentifier: messageChatCellIdentifier as String)
        tableView.backgroundColor = Global.colorHeader
        tableView.tableFooterView = UIView()

        let refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let _ = self.tableView.es_addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
            self?.loadUser()
        }

        tableView.expriedTimeInterval = 20.0
        tableView.es_startPullToRefresh()

        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        indicator.startAnimating()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_ACCEPT_FRIEND_REQUEST"), object: nil, queue: nil, using: self.reloadUser)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_ACCEPT_FRIEND_REQUEST_RESPONSE"), object: nil, queue: nil, using: self.reloadUser)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_LOGIN_LOGOUT"), object: nil, queue: nil, using: self.reloadTable)
    }


    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no_friend_entry".localized()
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
        return users.count
    }

    func loadUser() {
        ChatAPIservices.getAllAgency(RelationID: 3) {
            Users in
            self.users.removeAll(keepingCapacity: true)
            self.users.append(contentsOf: Users)
            self.tableView.reloadData()
            self.tableView.es_stopPullToRefresh(ignoreDate: true)
            self.indicator.stopAnimating()
        }
    }

    func reloadUser(notification: Notification) {
        self.loadUser()
    }

    func reloadTable(notificaton: Notification) {
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserChatTableViewCell! = tableView.dequeueReusableCell(withIdentifier: messageChatCellIdentifier  as String) as? UserChatTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none

        cell.bindingData(user: users[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.didSelectSingleUser(self.users[indexPath.row])
        }
    }
}
