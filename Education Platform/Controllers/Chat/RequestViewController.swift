//
//  RequestViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/30/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet
import Localize_Swift
import ESPullToRefresh

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var constraintsAdded = false

    let acceptFriendAccessTableViewCell = "acceptFriendAccessTableViewCell"
    var users = [ChatUserResult]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UINib(nibName: "GrantAccessTableViewCell", bundle: nil), forCellReuseIdentifier: acceptFriendAccessTableViewCell as String)
        tableView.backgroundColor = Global.colorHeader
        tableView.tableFooterView = UIView()

        users.append(contentsOf: FriendServices.getInstance().waitingMeList)

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

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_DECLINE_FRIEND_REQUEST"), object: nil, queue: nil, using: self.reloadData)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_ADD_FRIEND_REQUEST"), object: nil, queue: nil, using: self.reloadData)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_ACCEPT_FRIEND_REQUEST"), object: nil, queue: nil, using: self.reloadData)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_ACCEPT_FRIEND_REQUEST_RESPONSE"), object: nil, queue: nil, using: self.reloadData)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_DECLINE_FRIEND_REQUEST_RESPONSE"), object: nil, queue: nil, using: self.reloadData)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_ADD_FRIEND_REQUEST_RESPONSE"), object: nil, queue: nil, using: self.reloadData)
    }

    func loadUser() {
        ChatAPIservices.getAllAgency(RelationID: 2) { (userDatas) in
            self.users.removeAll(keepingCapacity: true)
            self.users.append(contentsOf: userDatas)
            self.tableView.es_stopPullToRefresh()
            self.tableView.reloadData()
            self.indicator.stopAnimating()

        }
        SwiftOverlays.removeAllBlockingOverlays()
    }

    func reloadData(notification: Notification) {
        self.loadUser()
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no_request_entry".localized()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: acceptFriendAccessTableViewCell, for: indexPath) as! GrantAccessTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none

        cell.bindingFromData(user: users[indexPath.row])
        cell.confirmRequestBtn.tag = indexPath.row
        cell.deleteRequestBtn.tag = indexPath.row
        cell.confirmRequestBtn.addTarget(self, action: #selector(self.connectedButtonAccept), for: .touchUpInside)
        cell.deleteRequestBtn.addTarget(self, action: #selector(self.connectedRemoveRequest), for: .touchUpInside)
        return cell
        //        }
    }

    func connectedButtonAccept(sender: UIButton) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = users[sender.tag]
        let message:JSON = ["Action":"ACCEPT_FRIEND_REQUEST","DestUserId":user.Id]
        WebSocketServices.shared.Write(message: message.rawString()!)
    }

    func connectedRemoveRequest(sender: UIButton) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = users[sender.tag]
        let message:JSON = ["Action":"DECLINE_FRIEND_REQUEST","DestUserId":user.Id]
        WebSocketServices.shared.Write(message: message.rawString()!)
    }
}
