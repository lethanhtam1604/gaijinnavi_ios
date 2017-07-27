//
//  CompanyViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 3/1/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift
import PasswordTextField
import FontAwesomeKit
import Alamofire
import FacebookLogin
import FacebookCore
import Google
import STPopup

class CompanyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    var constraintsAdded = false
    var jobListResult: JobListResult!
    var comapnyJobListResult = [JobListResult]()
    var loadFinished = 0
    
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
        tableView.register(JobTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CompanyHeaderTableViewCell.self, forCellReuseIdentifier: "header")
        tableView.register(CompanyFooterTableViewCell.self, forCellReuseIdentifier: "footer")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        indicator.startAnimating()
        
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            tableView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            tableView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            tableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
    
    var isLoadHeader = false
    var isLoadFooter = false
    var headerView: CompanyHeaderTableViewCell!
    var footerView: CompanyFooterTableViewCell!
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isLoadHeader {
            isLoadHeader = true
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! CompanyHeaderTableViewCell
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            headerView = cell
            
            cell.bindingData(jobListResult: jobListResult)
            
            cell.contentView.backgroundColor = UIColor.white
            return cell.contentView
        }
        else {
            return headerView.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let margin: CGFloat = 20
        
        let peopleHeight: CGFloat = 20
        let countryHeight: CGFloat = 20
        var addressHeight: CGFloat = 20
        var overviewHeight: CGFloat = 20
        var descriptionHeight: CGFloat = 0
        var jobHeight: CGFloat = 20
        
        if jobListResult.LocationData.FullAddress != "" {
            let rectAddress = NSString(string: jobListResult.LocationData.FullAddress).boundingRect(with: CGSize(width: view.frame.width - margin - 30, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!], context: nil)
            addressHeight = rectAddress.height
        }
        
        let rectOverview = NSString(string: "overview".localized()).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 24)!], context: nil)
        overviewHeight = rectOverview.height
        
        if jobListResult.CompanyData.DescriptionHtml != "" {
            let rectDescription = NSString(string: jobListResult.CompanyData.DescriptionHtml).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!], context: nil)
            descriptionHeight = rectDescription.height
        }
        
        let rectJob = NSString(string: "jobs".localized()).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 24)!], context: nil)
        jobHeight = rectJob.height
        
        if DeviceType.IS_IPAD {
            return peopleHeight + countryHeight + addressHeight + overviewHeight + descriptionHeight + jobHeight + 120 + 250 + 100
        }
        return peopleHeight + countryHeight + addressHeight + overviewHeight + descriptionHeight + jobHeight + 120 + 250
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if !isLoadFooter {
            isLoadFooter = true
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "footer") as! CompanyFooterTableViewCell
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            footerView = cell
            
            cell.bindingData(jobListResult: jobListResult)
            
            cell.contentView.backgroundColor = UIColor.white
            return cell.contentView
        }
        else {
            return footerView.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let margin: CGFloat = 20
        
        var loveWorkingHereHeight: CGFloat = 0
        var descriptionHeight: CGFloat = 0
        var locationnHeight: CGFloat = 0
        var addressHeight: CGFloat = 0
        
        let rectA = NSString(string: "why_you_love_working_here".localized()).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 24)!], context: nil)
        loveWorkingHereHeight = rectA.height
        
        let rectB = NSString(string: "若くて活発な社員\n社員が顧客に良い商品を想像の為に、広く快適な働く環境を作ります。\n\n快適な環境\n当社は新商品を作りための考究又は若くて活発な社員がいます。").boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!], context: nil)
        descriptionHeight = rectB.height
        
        let rectC = NSString(string: "location".localized()).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 24)!], context: nil)
        locationnHeight = rectC.height
        
        let rectD = NSString(string: jobListResult.LocationData.FullAddress).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!], context: nil)
        addressHeight = rectD.height
        
        return loveWorkingHereHeight + descriptionHeight + locationnHeight + addressHeight + 90 + 300
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comapnyJobListResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let jobHighlighted = comapnyJobListResult[indexPath.row]
        
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
        
        let jobListResult = comapnyJobListResult[indexPath.row]
        
        cell.bindingData(jobListResult: jobListResult)
        cell.logoJobButton.addTarget(self, action: #selector(companyIconClicked), for: .touchUpInside)
        cell.logoJobButton.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        cell.contentLocationLabel.isUserInteractionEnabled = true
        cell.contentLocationLabel.addGestureRecognizer(tapGesture)
        cell.contentLocationLabel.tag = indexPath.row

        return cell
    }
    
    func addressTapped(_ sender: UITapGestureRecognizer!) {
        
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        
        let viewController = MapViewController()
        let jobListResult = self.comapnyJobListResult[(sender.view?.tag)!]
        viewController.jobListResult = jobListResult
        let viewControllerPopupController = STPopupController(rootViewController: viewController)
        viewControllerPopupController.containerView.layer.cornerRadius = 4
        viewControllerPopupController.present(in: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = JobDetailViewController()
        let jobListResult = comapnyJobListResult[indexPath.row]
        viewController.jobListResult = jobListResult
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func companyIconClicked(_ sender: UIButton!) {
        let viewController = CompanyViewController()
        let jobListResult = comapnyJobListResult[sender.tag]
        viewController.jobListResult = jobListResult
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func loadData() {
        let parameters = ["jobTypes": jobListResult.JobType.Id, "companyId": jobListResult.CompanyData.Id] as [String : Any]
        
        JobServices.getJobs(parameters: parameters) { (result, success, message) in
            if success == true {
                self.comapnyJobListResult = [JobListResult]()
                self.comapnyJobListResult.append(contentsOf: result)
                self.tableView.reloadData()
                
            }
            else {
                Utils.showAlert(title: "error".localized(), message: message, viewController: self)
            }

            self.indicator.stopAnimating()
        }
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
