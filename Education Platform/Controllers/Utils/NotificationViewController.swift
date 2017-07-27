//
//  NotificationViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/19/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import SwiftyJSON
import Kingfisher
import FontAwesomeKit
import DZNEmptyDataSet
import ESPullToRefresh

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var currentPage = 1
    
    let notificationCellReuseIdentifier = "NotificationCellReuseIdentifier"
    let gradientView = GradientView()
    
    var refreshHeaderAnimator: ESRefreshHeaderAnimator!
    var refreshFooterAnimator: ESRefreshFooterAnimator!
    
    lazy var notificationDatas = [NotificationResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton
        
        title = "notification".localized().uppercased()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: notificationCellReuseIdentifier as String)
        tableView.backgroundColor = Global.colorHeader
        tableView.tableFooterView = UIView()
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        
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
        
        setLanguageRuntime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = UIRectEdge.left
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tableView.es_stopPullToRefresh()
        self.tableView.es_stopLoadingMore()
        
    }
    
    func setLanguageRuntime(){
//        refreshFooterAnimator.loadingMoreDescription = "loading_more".localized()
//        refreshFooterAnimator.noMoreDataDescription = "no_more_data".localized()
//        refreshFooterAnimator.loadingDescription = "loading_more".localized()
    }
    
    func refresh() {
        self.currentPage = 1
        self.refreshData(type: true)
    }
    
    func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.currentPage = self.currentPage + 1
            self.refreshData(type: false)
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no_notification_entry".localized()
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
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationTableViewCell! = tableView.dequeueReusableCell(withIdentifier: notificationCellReuseIdentifier as String) as? NotificationTableViewCell
        //cell.separatorInset = UIEdgeInsets.zero
        let data = notificationDatas[indexPath.row]
        cell.bindData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.notificationDatas[indexPath.row]
        if news.PostType == 1 {
//            let schooldetails = SchoolDetailsController()
//            schooldetails.schoolID = Int(news.langId)
//            self.navigationController?.pushViewController(schooldetails, animated: true)
        }
        else {
            let detailNewsFeedViewController = DetailNewsFeedViewController()
            detailNewsFeedViewController.NewId = Int(news.langId)
            self.navigationController?.pushViewController(detailNewsFeedViewController, animated: true)
        }
        self.notificationDatas[indexPath.row].SeenFlag = 1
        NotificationServices.getInstance().seenNotification(Id: news.Id) { (success) in
            if(success == true) {
                
            }
        }
    }
    
    func refreshData(type: Bool) {
        NotificationServices.getInstance().refreshNotification(type: type, currentPage: self.currentPage) { (data, success) in
            if success == true {
                
                if type {
                    self.notificationDatas = [NotificationResult]()
                }
                
                self.notificationDatas.append(contentsOf: data)
                self.tableView.reloadData()
                
            } else {
                Utils.showAlert(title: "error".localized(), message: "could_not_connect_to_server_please_try_again".localized(), viewController: self)
            }
            self.stopRefresh(type: type)
        }
    }
    
    func stopRefresh(type: Bool) {
        if type {
            self.tableView.es_stopPullToRefresh()
        }
        else {
            self.tableView.es_stopLoadingMore()
        }
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
