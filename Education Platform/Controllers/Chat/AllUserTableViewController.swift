//
//  AllUserTableViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/29/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import SwiftyJSON
import Localize_Swift
import DZNEmptyDataSet
import ESPullToRefresh

class AllUserTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var constraintsAdded = false

    var tempUsersList = [ChatUserResult]()
    var users = [ChatUserResult]()

    let allUserCellIdentifier = "allUserCellIdentifier"
    var searchController : UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search_by_name_or_email".localized()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UINib(nibName: "AllUsersTableViewCell", bundle: nil), forCellReuseIdentifier: allUserCellIdentifier as String)
        tableView.backgroundColor = Global.colorHeader
        tableView.tableFooterView = UIView()

        let refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let _ = self.tableView.es_addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
            self?.loadUser()
        }

        //        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_ADD_FRIEND_REQUEST_RESPONSE"), object: nil, queue: nil, using: self.reloadData)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_DECLINE_FRIEND_REQUEST"), object: nil, queue: nil, using: self.reloadData)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SOCKET_DECLINE_FRIEND_REQUEST_RESPONSE"), object: nil, queue: nil, using: self.reloadData)

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

    func updateSearchResults(for searchController: UISearchController) {

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        seachByNameOrEmail(text: searchText)
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        users = tempUsersList
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.es_stopPullToRefresh(ignoreDate: true)
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func loadUser() {
        ChatAPIservices.getAllAgency(RelationID: 0) {
            userData in
            self.users.removeAll(keepingCapacity: true)
            self.tempUsersList.removeAll()
            self.users.append(contentsOf: userData)

            ChatAPIservices.getAllAgency(RelationID: 1) {
                userDatas in
                self.users.append(contentsOf: userDatas)
                self.tempUsersList.append(contentsOf: self.users)
                self.sortByName ()
                self.tableView.reloadData()
                self.tableView.es_stopPullToRefresh()
                self.indicator.stopAnimating()
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allUserCellIdentifier", for: indexPath) as! AllUsersTableViewCell

        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none

        cell.addFriendBtn.tag = indexPath.row
        cell.addFriendBtn.addTarget(self, action: #selector(self.connectedButtonRequest), for: .touchUpInside)
        cell.bindingDataForCell(user: users[indexPath.row])

        return cell
    }

    func connectedButtonRequest(sender: UIButton) {
        let user = users[sender.tag]
        let message:JSON = ["Action": "ADD_FRIEND_REQUEST", "DestUserId": user.Id]
        WebSocketServices.shared.Write(message: message.rawString()!)

        let charUserResult = cloneUser(user: users[sender.tag])
        charUserResult.ConfirmFlag = 1

        self.editFriendServicesData(user: user, cloneUser: charUserResult)
        users[sender.tag].ConfirmFlag = 1
        sender.isHidden = true
        updateConfirmRequestForTempUserList(userId: users[sender.tag].Id)
        self.tableView.reloadData()
    }

    func updateConfirmRequestForTempUserList(userId: Int64) {
        for item in tempUsersList {
            if item.Id == userId {
                item.ConfirmFlag = 1
                break
            }

        }
    }

    func cloneUser(user: ChatUserResult) -> ChatUserResult {
        let chatUserResult = ChatUserResult()
        chatUserResult.Id = user.Id
        chatUserResult.UserName = user.UserName
        chatUserResult.Password = user.Password
        chatUserResult.DisplayName = user.DisplayName
        chatUserResult.Email = user.Email
        chatUserResult.Avatar = user.Avatar
        chatUserResult.ConfirmFlag = user.ConfirmFlag
        return chatUserResult
    }

    func reloadData(notification: Notification) {
        self.loadUser()
    }

    func sortByName() {
        users.sort(by: { $0.DisplayName < $1.DisplayName })
        tempUsersList.sort(by: { $0.DisplayName < $1.DisplayName })
    }

    func seachByNameOrEmail(text: String) {
        users = [ChatUserResult]()
        if text == "" {
            users.append(contentsOf: tempUsersList)
            sortByName()
            return
        }

        for item in tempUsersList {
            if item.DisplayName.lowercased().range(of: text.lowercased()) != nil || item.Email.lowercased().range(of: text.lowercased()) != nil {
                users.append(item)
            }
        }
        sortByName()
    }

    func editFriendServicesData(user: ChatUserResult, cloneUser: ChatUserResult) {
        let index = FriendServices.getInstance().NoFriend.index(of: user)
        FriendServices.getInstance().NoFriend.remove(at: index!)
        FriendServices.getInstance().waitingThemList.append(cloneUser)
    }

    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
