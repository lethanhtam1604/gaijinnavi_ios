//
//  JobViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/12/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Foundation
import FontAwesomeKit
import Localize_Swift
import Alamofire
import SwiftyJSON
import DZNEmptyDataSet
import STPopup
import ESPullToRefresh

class JobViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let tableView = UITableView()
    
    var refreshHeaderAnimator: ESRefreshHeaderAnimator!
    var refreshFooterAnimator: ESRefreshFooterAnimator!
    var currentPage = 1
    var loadType = false
    var constraintsAdded = false

    var jobTypeResult: JobTypeResult!
    var jobListResult = [JobListResult]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.tintColor = Global.colorMain
        view.clipsToBounds = true
        view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(JobTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        refreshFooterAnimator = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        let _ = self.tableView.es_addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
            self?.refresh()
        }
        
        tableView.refreshIdentifier = "defaulttype"
        tableView.expriedTimeInterval = 20.0
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        indicator.startAnimating()

        view.addSubview(tableView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
        
        setLanguageRuntime()
        refresh()
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
        self.title = "job".localized()
    }
    
    func refresh() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "error".localized(), message: "internet_is_not_available_please_try_again".localized(), viewController: self)
            self.tableView.es_stopPullToRefresh()
            indicator.stopAnimating()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.currentPage = 1
            self.loadType = true
            self.loadData()
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no_job_list_entry".localized()
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
        return jobListResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let jobHighlighted = self.jobListResult[indexPath.row]
        
        let margin: CGFloat = 20
        
        let rectTitle = NSString(string: jobHighlighted.PostData.Title).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 16)!], context: nil)
        
        let rectShortDescription = NSString(string: jobHighlighted.PostData.ShortDescription).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!], context: nil)
        
        var timeHeight: CGFloat = 20
        
        if jobHighlighted.JobData.DeadLine != "" {
            let rectTime = NSString(string: jobHighlighted.JobData.DeadLine).boundingRect(with: CGSize(width: view.frame.width - margin - 30, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!], context: nil)
            
            timeHeight = rectTime.height
        }
        
        var salaryHeight: CGFloat = 20
        
        if jobHighlighted.JobData.MinimumSalary != "" {
            
            let rectSalary = NSString(string: jobHighlighted.JobData.MinimumSalary).boundingRect(with: CGSize(width: view.frame.width - margin - 30, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!], context: nil)
            
            salaryHeight = rectSalary.height
        }
        
        var adddressHeight: CGFloat = 20
        
        if jobHighlighted.LocationData.FullAddress != "" {
            
            let rectAddress = NSString(string: jobHighlighted.LocationData.FullAddress + "see_map".localized()).boundingRect(with: CGSize(width: view.frame.width - margin - 30, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!], context: nil)
            
            adddressHeight = rectAddress.height
        }
        
        return 70 + 60 + 20 + rectTitle.height + rectShortDescription.height + timeHeight + salaryHeight + adddressHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! JobTableViewCell

        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let jobListResult = self.jobListResult[indexPath.row]
        
        cell.bindingData(jobListResult: jobListResult)

        cell.logoJobButton.addTarget(self, action: #selector(companyIconClicked), for: .touchUpInside)
        cell.logoJobButton.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToAddress))
        cell.contentLocationLabel.addGestureRecognizer(tapGesture)
        cell.contentLocationLabel.tag = indexPath.row
        
        return cell
    }
    
    func actionTapToAddress(_ sender: UITapGestureRecognizer!) {
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        
        let viewController = MapViewController()
        let jobListResult = self.jobListResult[(sender.view?.tag)!]
        viewController.jobListResult = jobListResult
        let viewControllerPopupController = STPopupController(rootViewController: viewController)
        viewControllerPopupController.containerView.layer.cornerRadius = 4
        viewControllerPopupController.present(in: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobListResult = self.jobListResult[indexPath.row]
        let viewController = JobDetailViewController()
        viewController.jobListResult = jobListResult
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func companyIconClicked(_ sender: UIButton!) {
        let viewController = CompanyViewController()
        let jobListResult = self.jobListResult[sender.tag]
        viewController.jobListResult = jobListResult
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func loadData() {
        let parameters = ["jobTypes": jobTypeResult.Id]
        JobServices.getJobs(parameters: parameters) { (result, success, message) in
            if success == true {
                if self.loadType {
                    self.jobListResult = [JobListResult]()
                }
                self.jobListResult.append(contentsOf: result)
                self.tableView.reloadData()
            }
            else {
                Utils.showAlert(title: "error".localized(), message: message, viewController: self)
                SwiftOverlays.removeAllBlockingOverlays()
            }
            
            if self.loadType {
                self.tableView.es_stopPullToRefresh()
            }
            else {
                self.tableView.es_stopLoadingMore()
            }
            
            self.indicator.stopAnimating()
        }
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
