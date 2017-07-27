//
//  FollowViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/2/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import Foundation
import FontAwesomeKit
import Localize_Swift
import Alamofire
import SwiftyJSON
import DZNEmptyDataSet
import ESPullToRefresh

class FollowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, FollowServiceDelegate {
    
    let tableView = UITableView()
    let followCellReuseIdentifier = "FollowCellReuseIdentifier"
    
    var refreshHeaderAnimator: ESRefreshHeaderAnimator!
    var refreshFooterAnimator: ESRefreshFooterAnimator!
    var currentPage = 1
    var loadType = false
    
    var usersFollowing = [UserResult]()
    var constraintsAdded = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.left
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UINib(nibName: "FollowTableViewCell", bundle: nil), forCellReuseIdentifier: followCellReuseIdentifier as String)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Global.colorBg
        
        refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        refreshFooterAnimator = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        let _ = self.tableView.es_addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
            self?.refresh()
        }
        
        self.tableView.refreshIdentifier = "defaulttype"
        self.tableView.expriedTimeInterval = 20.0
        
        self.tableView.es_startPullToRefresh()
        
        view.addSubview(tableView)
        setLanguageRuntime()
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoPinEdge(toSuperviewEdge: .top, withInset: 2)
            tableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
            tableView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            tableView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        }
    }
    
    func setLanguageRuntime(){
        self.title = "follow".localized()
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
            FollowService.getFollowingListOwner(followServiceDelegate: self)
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
            FollowService.getFollowingListOwner(followServiceDelegate: self)
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no_follow_entry".localized()
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
        cell.setData(user: user, usersFollowingOwner: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersFollowing[indexPath.row]
        let viewController = UserViewController()
        viewController.user = user
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getFollowingListOwnerFinished(success: Bool, message: String, result: [UserResult]) {
        if success {
            if loadType {
                self.usersFollowing = [UserResult]()
            }
            self.usersFollowing.append(contentsOf: result)
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
        
    }
    
    func getFollowedListFinished(success: Bool, message: String, result: [UserResult]) {
        
    }
    
    func followFinised(success: Bool, message: String) {
        
    }
    
    func unFollowFinised(success: Bool, message: String) {
        
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}

