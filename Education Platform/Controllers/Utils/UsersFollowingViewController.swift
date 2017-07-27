//
//  UsersFollowingViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/23/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import SwiftyJSON
import Kingfisher
import DZNEmptyDataSet
import ESPullToRefresh

class UsersFollowingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, FollowServiceDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let followCellReuseIdentifier = "FollowCellReuseIdentifier"
        
    var user: UserResult!
    var usersFollowing = [UserResult]()
    var usersFollowingOwner = [UserResult]()

    var refreshHeaderAnimator: ESRefreshHeaderAnimator!
    var refreshFooterAnimator: ESRefreshFooterAnimator!
    var currentPage = 1
    var loadType = false
    
    var followUserDelegate: FollowUserDelegate!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.contentSizeInPopup = CGSize(width: Global.SCREEN_WIDTH - 30, height: Global.SCREEN_HEIGHT - 100)
            self.landscapeContentSizeInPopup = CGSize(width: Global.SCREEN_HEIGHT - 100, height: Global.SCREEN_WIDTH - 80)
        }
        else if DeviceType.IS_IPAD {
            self.contentSizeInPopup = CGSize(width: Global.SCREEN_WIDTH - 200, height: Global.SCREEN_HEIGHT - 300)
            self.landscapeContentSizeInPopup = CGSize(width: Global.SCREEN_HEIGHT - 300, height: Global.SCREEN_WIDTH - 200)
        }
        else {
            self.contentSizeInPopup = CGSize(width: Global.SCREEN_WIDTH - 50, height: Global.SCREEN_HEIGHT - 200)
            self.landscapeContentSizeInPopup = CGSize(width: Global.SCREEN_HEIGHT - 200, height: Global.SCREEN_WIDTH - 100)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UINib(nibName: "FollowTableViewCell", bundle: nil), forCellReuseIdentifier: followCellReuseIdentifier as String)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        refreshFooterAnimator = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        let _ = self.tableView.es_addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
            self?.refresh()
        }
        //        let _ = self.tableView.es_addInfiniteScrolling(animator: refreshFooterAnimator) { [weak self] in
        //            self?.loadMore()
        //        }
        self.tableView.refreshIdentifier = "defaulttype"
        self.tableView.expriedTimeInterval = 20.0
        
        self.tableView.es_startPullToRefresh()
        
        setLanguageRuntime()
    }
    
    func setLanguageRuntime(){
        self.title = user.DisplayName + " " +  "follows".localized()
    }
    
    func refresh() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "error".localized(), message: "internet_is_not_available_please_try_again".localized(), viewController: self)
            tableView.es_stopPullToRefresh()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.currentPage = 1
            self.loadType = true
            FollowService.getFollowingList(userId: self.user.Id, followServiceDelegate: self)
        }
    }
    
    func loadMore() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "error".localized(), message: "internet_is_not_available_please_try_again".localized(), viewController: self)
            tableView.es_stopLoadingMore()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.currentPage = self.currentPage + 1
            self.loadType = false
            FollowService.getFollowingList(userId: self.user.Id, followServiceDelegate: self)
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no_following_entry".localized()
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
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersFollowing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FollowTableViewCell! = tableView.dequeueReusableCell(withIdentifier: followCellReuseIdentifier as String) as? FollowTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let user = usersFollowing[indexPath.row]
        cell.setData(user: user, usersFollowingOwner: self.usersFollowingOwner)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersFollowing[indexPath.row]
        if followUserDelegate != nil {
            followUserDelegate.userProfileClicked(user: user)
        }
    }
    
    func getFollowingListOwnerFinished(success: Bool, message: String, result: [UserResult]) {
        if success {
            self.usersFollowingOwner.append(contentsOf: result)
            self.tableView.reloadData()
        }
        else {
            Utils.showAlert(title: "error".localized() , message: message, viewController: self)
        }
        
        if loadType {
            self.tableView.es_stopPullToRefresh()
        }
        else {
            self.tableView.es_stopLoadingMore()
        }
    }
    
    func getFollowingListFinished(success: Bool, message: String, result: [UserResult]) {
        if success {
            if loadType {
                self.usersFollowing = [UserResult]()
            }
            self.usersFollowing.append(contentsOf: result)
            FollowService.getFollowingListOwner(followServiceDelegate: self)
        }
        else {
            Utils.showAlert(title: "error".localized() , message: message, viewController: self)
            if loadType {
                self.tableView.es_stopPullToRefresh()
            }
            else {
                self.tableView.es_stopLoadingMore()
            }
        }
    }
    
    func getFollowedListFinished(success: Bool, message: String, result: [UserResult]) {
 
    }
    
    func followFinised(success: Bool, message: String) {
        
    }
    
    func unFollowFinised(success: Bool, message: String) {
        
    }
}
