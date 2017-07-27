//
//  AllShoolViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 6/7/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import PureLayout
import DZNEmptyDataSet
import SDWebImage
import ESPullToRefresh

class AllShoolViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let searchBar = UISearchBar()
    let tableView = UITableView(frame: .zero, style: .grouped)
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var refreshHeaderAnimator: ESRefreshHeaderAnimator!
    var refreshFooterAnimator: ESRefreshFooterAnimator!
    
    var constraintsAdded = false
    var currentPage = 1
    var loadType = false
    
    var schools = [School]()
    var area = AreaData()
    
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
        
        searchBar.frame = CGRect(x: 0, y: 0, width: Global.SCREEN_WIDTH, height: 44)
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search"
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = Global.colorMain
        searchBar.tintColor = Global.colorMain
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor.clear
                    break
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(ItemSchoolTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
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
        
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
        
        setLanguageRuntime()
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
            self.loadData()
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
            self.loadData()
        }
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
        title = area.NameEn
        
        refreshFooterAnimator.loadingMoreDescription = ""
        refreshFooterAnimator.noMoreDataDescription = ""
        refreshFooterAnimator.loadingDescription = ""
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let school = self.schools[indexPath.row]
        
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
        viewController.schoolId = self.schools[indexPath.row].schoolData.SchoolId
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
        cell.nationBtn.tag = indexPath.row
        let school = self.schools[indexPath.row]
        cell.bindingData(school: school)
        
        return cell
    }
    
    func regionBtn(_ sender: UIButton) {
        let viewController = AllShoolViewController()
        viewController.area = self.schools[sender.tag].areaDatas[0]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func loadData() {
        SchoolServices.getSchoolsByAre(pageSize: 20, currentPage: currentPage, groupArea: area.GroupAreaId, area: area.Id) {
            (result, success, message) in
            
            if success {
                if self.loadType {
                    self.schools = [School]()
                }
                self.schools.append(contentsOf: result)
                
                self.tableView.reloadData()
            }
            else {
                Utils.showAlert(title: "error".localized() , message: message, viewController: self)
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

