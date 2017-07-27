//
//  JobCategoryViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 2/23/17.
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

class JobCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MainViewDelegate {
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let tableView = UITableView(frame: .zero, style: .grouped)
    var iconProfileImgView = UIImageView()
    
    var currentPage = 1
    var loadType = false
    var constraintsAdded = false
    
    var jobTypes = [JobTypeResult]()
    var jobListResult = [JobListResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.tintColor = Global.colorMain
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HighlightedJobTableViewCell.self, forCellReuseIdentifier: "highLightedJobCell")
        tableView.register(JobCategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(JobTitleHeaderTableViewCell.self, forCellReuseIdentifier: "header")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        
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
    
    func setLanguageRuntime(){
        self.title = "job".localized().uppercased()
        
        self.refresh()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func refresh() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "error".localized(), message: "internet_is_not_available_please_try_again".localized(), viewController: self)
            indicator.stopAnimating()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.currentPage = 1
            self.loadType = true
            self.loadData()
        }
    }
    
    var tableViewHeight: NSLayoutConstraint!
    
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! JobTitleHeaderTableViewCell
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        cell.contentView.backgroundColor = UIColor.white
        
        if section == 0 {
            cell.bindingData(title: "category_jobs".localized())
        }
        else {
            cell.bindingData(title: "highlighted_jobs".localized())
        }
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        else {
            
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return jobTypes.count
        }
        else {
            return jobListResult.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! JobCategoryTableViewCell
            
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            
            let jobType = self.jobTypes[indexPath.row]
            cell.bindingData(jobTypeResult: jobType)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "highLightedJobCell") as! HighlightedJobTableViewCell
            
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            
            cell.bindingData(jobListResult: jobListResult[indexPath.row])
            
            cell.logoJobButton.addTarget(self, action: #selector(companyIconClicked), for: .touchUpInside)
            cell.logoJobButton.tag = indexPath.row
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToAddress))
            cell.contentLocationLabel.addGestureRecognizer(tapGesture)
            cell.contentLocationLabel.tag = indexPath.row
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let jobType = self.jobTypes[indexPath.row]
            let viewController = JobViewController()
            viewController.jobTypeResult = jobType
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            let jobListResult = self.jobListResult[indexPath.row]
            let viewController = JobDetailViewController()
            viewController.jobListResult = jobListResult
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
    
    func companyIconClicked(_ sender: UIButton!) {
        let viewController = CompanyViewController()
        let jobListResult = self.jobListResult[sender.tag]
        viewController.jobListResult = jobListResult
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //-------------------------------------------------
    
    func loadData() {
        indicator.startAnimating()
        JobServices.getListCategoryJob() { (result, success, message) in
            if success == true {
                if self.loadType {
                    self.jobTypes = [JobTypeResult]()
                }
                self.jobTypes.append(contentsOf: result)
                
                JobServices.getHightlightedJobs() { (result, success, message) in
                    if success == true {
                        if self.loadType {
                            self.jobListResult = [JobListResult]()
                        }
                        self.jobListResult.append(contentsOf: result)
                        self.tableView.reloadData()
                    }
                    else {
                        Utils.showAlert(title: "error".localized(), message: message, viewController: self)
                    }
                    self.indicator.stopAnimating()
                }
            }
            else {
                self.indicator.stopAnimating()
                Utils.showAlert(title: "error".localized(), message: message, viewController: self)
            }
        }
    }
}
