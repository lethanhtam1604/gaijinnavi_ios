//
//  NewsFeedViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/2/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift
import Alamofire
import SwiftyJSON
import Kingfisher
import DZNEmptyDataSet
import ESPullToRefresh

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, NewsServiceDelegate, MainViewDelegate {
    
    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var iconProfileImgView = UIImageView()

    var currentPage = 1
    var loadType = false
    
    var refreshHeaderAnimator: ESRefreshHeaderAnimator!
    var refreshFooterAnimator: ESRefreshFooterAnimator!
    
    var cartBarbuttonItem: MIBadgeButton!
    var news = [News]()
    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.tintColor = UIColor.white
        view.clipsToBounds = true
        view.addTapToDismiss()
        
        navigationController?.navigationBar.barTintColor = Global.colorMain
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        let iosPersonIcon = FAKIonIcons.iosPersonIcon(withSize: 30)
        iosPersonIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let iosPersonImg = iosPersonIcon?.image(with: CGSize(width: 30, height: 30))
        
        iconProfileImgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        iconProfileImgView.image = iosPersonImg
        iconProfileImgView.layer.cornerRadius = 15
        iconProfileImgView.layer.borderColor = UIColor.white.cgColor
        iconProfileImgView.layer.borderWidth = 1.5
        iconProfileImgView.clipsToBounds = true
        iconProfileImgView.contentMode = .scaleAspectFill
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userProfile))
        iconProfileImgView.isUserInteractionEnabled = true
        iconProfileImgView.addGestureRecognizer(tapGestureRecognizer)
        let profileBarBtn = UIBarButtonItem(customView: iconProfileImgView)
        self.navigationItem.leftBarButtonItem = profileBarBtn
        
        let notificationIcon = FAKIonIcons.androidNotificationsIcon(withSize: 25)
        notificationIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let notificationImg = notificationIcon?.image(with: CGSize(width: 25, height: 25))
        
        self.cartBarbuttonItem = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        self.cartBarbuttonItem?.setImage(notificationImg, for: .normal)
        self.cartBarbuttonItem?.addTarget(self, action: #selector(notificationBtnClicked), for: UIControlEvents.touchUpInside)
        self.cartBarbuttonItem.badgeEdgeInsets =  UIEdgeInsets(top: 30, left: 2, bottom: 0, right: 0)
        
//        let barButton : UIBarButtonItem = UIBarButtonItem(customView: self.cartBarbuttonItem)
//        self.navigationItem.rightBarButtonItem = barButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        refreshFooterAnimator = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
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
        
        getNotificationBadge()
        
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
        
        setLanguageRuntime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AccountService.getUser() {
            newUser in
            if let user = newUser {
                if user.User.Avatar != "" {
                    self.iconProfileImgView.kf.setImage(with: URL(string: user.User.Avatar))
                }
                else {
                    self.iconProfileImgView.image = UIImage(named: "ic_user")
                }
            }
            else {
                self.iconProfileImgView.image = UIImage(named: "ic_user")
            }
        }
    }

    func userProfile() {
        if MainViewController.isConfirmEmail == false {
            let viewController = ConfirmEmailViewController()
            viewController.closeBtn.isHidden = false
            viewController.mainViewDelegate = self
            self.present(viewController, animated: true, completion: nil)
        }
        else {
            let nav = ProfileViewController()
            self.navigationController?.pushViewController(nav, animated: true)
        }
    }
    
    func confirmedEmail() {
        Utils.showAlert(title: "Gaijinnavi", message: "confirm_email_successfully".localized(), viewController: self)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoAlignAxis(toSuperviewAxis: .vertical)
            tableView.autoPinEdge(toSuperviewMargin: .top)
            tableView.autoPinEdge(toSuperviewMargin: .bottom)
            tableView.autoMatch(.width, to: .width, of: view)
            
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func setLanguageRuntime(){
        title = "news_feed".localized().uppercased()
        
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
            NewsService.reloadNews(currentPage: self.currentPage, newsServiceDelegate: self)
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
            NewsService.reloadNews(currentPage: self.currentPage, newsServiceDelegate: self)
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no_news_entry".localized()
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
        return self.news.count
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
    
    func notificationBtnClicked() {
        let viewController = NotificationViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
    func getNotificationBadge() {
        NotificationServices.getInstance().refreshNotification(type: true, currentPage: 1) { (datas, success) in
            
            if success == true {
                var total = 0
                for each in datas{
                    if (each.SeenFlag == 0) {
                        total += 1
                    }
                }
                
                if total > 0 {
                    self.cartBarbuttonItem.badgeString = total.description
                }
            }
        }
    }
    
}
