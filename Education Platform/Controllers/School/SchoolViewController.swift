//
//  SchoolViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 5/25/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import PureLayout
import DZNEmptyDataSet
import SDWebImage
import ESPullToRefresh
import FontAwesomeKit

class SchoolViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MainViewDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var searchController : UISearchController!
    var iconProfileImgView = UIImageView()
    
    var refreshHeaderAnimator: ESRefreshHeaderAnimator!
    
    var constraintsAdded = false
    var currentPage = 1
    var loadType = false
    
    var schoolAreas = [SchoolArea]()
    
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
        
        searchController = UISearchController(searchResultsController:  nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by Name"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
//        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(ItemSchoolTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(LocationHeaderTableViewCell.self, forCellReuseIdentifier: "header")
        tableView.register(SchoolFooterTableViewCell.self, forCellReuseIdentifier: "footer")
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        refreshHeaderAnimator = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        
        let _ = self.tableView.es_addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
            self?.refresh()
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
    
    func refresh() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "error".localized(), message: "internet_is_not_available_please_try_again".localized(), viewController: self)
            tableView.es_stopPullToRefresh()
            indicator.stopAnimating()
            return
        }
        
        self.loadData()
    }
    
    func search() {
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoAlignAxis(toSuperviewAxis: .vertical)
            tableView.autoMatch(.width, to: .width, of: view)
            tableView.autoPinEdge(toSuperviewEdge: .top)
            tableView.autoPinEdge(toSuperviewMargin: .bottom)
            
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func setLanguageRuntime() {
        title = "school".localized().uppercased()
        
        refreshHeaderAnimator.loadingDescription = ""
        refreshHeaderAnimator.releaseToRefreshDescription = ""
        refreshHeaderAnimator.pullToRefreshDescription = ""
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "no_school_entry".localized()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return schoolAreas.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! LocationHeaderTableViewCell
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(region))
        cell.abstractView.addGestureRecognizer(viewGesture)
        cell.abstractView.tag = section
        
        cell.bindingData(title: self.schoolAreas[section].areaData.NameEn)
        
        cell.contentView.backgroundColor = UIColor.white
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "footer") as! SchoolFooterTableViewCell
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(region))
        cell.abstractView.addGestureRecognizer(viewGesture)
        cell.abstractView.tag = section
        
        cell.bindingData()
        
        cell.contentView.backgroundColor = UIColor.white
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolAreas[section].school.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let school = self.schoolAreas[indexPath.section].school[indexPath.row]
        
        var margin: CGFloat = 20
        
        if DeviceType.IS_IPAD {
            margin = 320
        }
        
        let rectTitle = NSString(string: school.schoolPost.Title).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 16)!], context: nil)
        
        let rectDescription = NSString(string: school.schoolPost.ShortDescription).boundingRect(with: CGSize(width: view.frame.width - margin, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!], context: nil)
        
        
        return 30 + 250 + rectTitle.height + rectDescription.height + 20 + 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = SchoolDetailViewController()
        viewController.schoolId = self.schoolAreas[indexPath.section].school[indexPath.row].schoolData.SchoolId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemSchoolTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        cell.nationBtn.addTarget(self, action: #selector(regionBtn), for: .touchUpInside)
        cell.nationBtn.tag = indexPath.section
        let school = self.schoolAreas[indexPath.section].school[indexPath.row]
        
        cell.bindingData(school: school)
        
        return cell
    }
    
    func region(_ sender: UITapGestureRecognizer) {
        let view = sender.view
        let viewController = AllShoolViewController()
        viewController.area = schoolAreas[(view?.tag)!].areaData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func regionBtn(_ sender: UIButton) {
        let viewController = AllShoolViewController()
        viewController.area = schoolAreas[sender.tag].areaData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func loadData() {
        SchoolServices.getAreas(amount: 5) { (result, success, message) in
            if success == true {
                self.schoolAreas = [SchoolArea]()
                self.schoolAreas.append(contentsOf: result)
                self.tableView.reloadData()
            }
            else {
                Utils.showAlert(title: "error".localized(), message: message, viewController: self)
                SwiftOverlays.removeAllBlockingOverlays()
            }
            
            self.tableView.es_stopPullToRefresh()
            self.indicator.stopAnimating()
        }
    }
    
    // UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        search()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

