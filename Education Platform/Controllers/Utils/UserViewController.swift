//
//  UserViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 5/16/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift
import Alamofire
import SwiftyJSON
import Kingfisher
import STPopup
import ESPullToRefresh

protocol FollowUserDelegate {
    func userProfileClicked(user: UserResult)
}

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FollowUserDelegate, NewsServiceDelegate {
    
    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    var currentPage = 1
    var loadType = false
    
    let newsFeedCellReuseIdentifier = "NewsFeedCellReuseIdentifier"
    let newsFeedCollectionCellReuseIdentifier = "NewsFeedCollectionCellReuseIdentifier"
    
    let gradientView = GradientView()
    var headerView: UserDetailHeaderTableViewCell!
    var user: UserResult!
    var news = [News]()
    
    var refreshHeaderAnimator: ESRefreshHeaderAnimator!
    var refreshFooterAnimator: ESRefreshFooterAnimator!
    
    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton
        
        refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        refreshFooterAnimator = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        headerView = UserDetailHeaderTableViewCell.instanceFromNib() as? UserDetailHeaderTableViewCell
        headerView.user = user
        tableView.tableHeaderView = headerView
        headerView.followedBtn.addTarget(self, action: #selector(showUsersFollowed), for: .touchUpInside)
        headerView.followingBtn.addTarget(self, action: #selector(showUsersFollowing), for: .touchUpInside)
        
        let _ = self.tableView.es_addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
            self?.refresh()
        }
        let _ = self.tableView.es_addInfiniteScrolling(animator: refreshFooterAnimator) { [weak self] in
            self?.loadMore()
        }
        self.tableView.refreshIdentifier = "defaulttype"
        self.tableView.expriedTimeInterval = 20.0
        
        self.tableView.es_startPullToRefresh()
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        indicator.startAnimating()
        
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
        
        setLanguageRuntime()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoAlignAxis(toSuperviewAxis: .vertical)
            tableView.autoMatch(.width, to: .width, of: view)
            tableView.autoPinEdge(toSuperviewMargin: .top)
            tableView.autoPinEdge(toSuperviewMargin: .bottom)
            
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func setLanguageRuntime(){
        self.title = user.DisplayName
        
        headerView.loadData()

        refreshFooterAnimator.loadingMoreDescription = ""
        refreshFooterAnimator.noMoreDataDescription = ""
        refreshFooterAnimator.loadingDescription = ""
        
        refreshHeaderAnimator.loadingDescription = ""
        refreshHeaderAnimator.releaseToRefreshDescription = ""
        refreshHeaderAnimator.pullToRefreshDescription = ""
    }
    
    func refresh() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "error".localized(), message: "internet_is_not_available_please_try_again".localized(), viewController: self)
            tableView.es_stopPullToRefresh()
            indicator.stopAnimating()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.currentPage = 1
            self.loadType = true
            NewsService.reloadNewsByOwnerUser(currentPage: self.currentPage, userId: self.user.Id, newsServiceDelegate: self)
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
            NewsService.reloadNewsByOwnerUser(currentPage: self.currentPage, userId: self.user.Id, newsServiceDelegate: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let news = self.news[indexPath.row]
        
        var margin: CGFloat = 20
        
        if DeviceType.IS_IPAD {
            margin = 320
        }
        
        let rectAuthorName = NSString(string: news.author.DisplayName).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 12)!], context: nil)
        
        let rectTime = NSString(string: news.newsInterface.created_time).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 11)!], context: nil)
        
        let rectCategory = NSString(string: news.category.Name).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 16)!], context: nil)
        
        let rectTitle = NSString(string: news.newsInterface.Title).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], context: nil)
        
        let rectShortDescription = NSString(string: news.newsInterface.ShortDescription).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!], context: nil)
        
        return 80 + 250 + rectAuthorName.height + rectTime.height + rectCategory.height + rectTitle.height + rectShortDescription.height + 20 + 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsFeedTableViewCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let news = self.news[indexPath.row]
        cell.authorIconBtn.tag = indexPath.row
        cell.authorIconBtn.addTarget(self, action: #selector(authorIconBtnClicked), for: .touchUpInside)
        
        cell.bindingData(news: news)
        
        return cell
    }
    
    func authorIconBtnClicked(_ sender: UIButton) {
        let news = self.news[sender.tag]
        let viewController = UserViewController()
        viewController.user = news.author
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.news[indexPath.row]
        let detailNewsFeedViewController = DetailNewsFeedViewController()
        detailNewsFeedViewController.NewId = news.newsInterface.NewsId
        self.navigationController?.pushViewController(detailNewsFeedViewController, animated: true)
    }
    
    
    func loadNewsFinished(success: Bool, message: String, news: [News]) {
        if success {
            if loadType {
                self.news = [News]()
            }
            self.news.append(contentsOf: news)
            tableView.reloadData()
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
        
        indicator.stopAnimating()
    }
    
    var viewPopupController: STPopupController!
    
    func showUsersFollowing() {
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 16)!]
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 14)!]
        }
        
        let viewController = UsersFollowingViewController()
        viewController.user = user
        viewController.followUserDelegate = self
        viewPopupController = STPopupController(rootViewController: viewController)
        viewPopupController.containerView.layer.cornerRadius = 4
        viewPopupController.present(in: self)
    }
    
    func showUsersFollowed() {
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 16)!]
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 14)!]
        }
        
        let viewController = UsersFollowedViewController()
        viewController.user = user
        viewController.followUserDelegate = self
        viewPopupController = STPopupController(rootViewController: viewController)
        viewPopupController.containerView.layer.cornerRadius = 4
        viewPopupController.present(in: self)
    }
    
    func userProfileClicked(user: UserResult) {
        viewPopupController.dismiss()
        let nav = UserViewController()
        nav.user = user
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
