//
//  SettingLanguageViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/3/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit

protocol SettingLanguageDelegate {
    func languageClicked(language: Language)
}

class SettingLanguageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    let languageCellReuseIdentifier = "LanguageCellReuseIdentifier"
    var currentIndex = 0
    var settingLanguageDelegate: SettingLanguageDelegate!
    
    var constraintsAdded = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "language".localized()
        
        if DeviceType.IS_IPAD {
            self.contentSizeInPopup = CGSize(width: Global.SCREEN_WIDTH - 200, height: Global.SCREEN_HEIGHT - 300)
            self.landscapeContentSizeInPopup = CGSize(width: Global.SCREEN_HEIGHT - 300, height: Global.SCREEN_WIDTH - 200)
        }
        else {
            self.contentSizeInPopup = CGSize(width: Global.SCREEN_WIDTH - 50, height: Global.SCREEN_HEIGHT - 200)
            self.landscapeContentSizeInPopup = CGSize(width: Global.SCREEN_HEIGHT - 200, height: Global.SCREEN_WIDTH - 100)
        }
        
        let doneBarBtnItem = UIBarButtonItem(title: "done".localized().uppercased(), style: .done, target: self, action: #selector(doneClicked))
        doneBarBtnItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = doneBarBtnItem
        
        currentIndex = UserDefaultManager.getInstance().getCurrentLanguage()!
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LanguageTableViewCell", bundle: nil), forCellReuseIdentifier: languageCellReuseIdentifier as String)
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageManager.getInstance().languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LanguageTableViewCell! = tableView.dequeueReusableCell(withIdentifier: languageCellReuseIdentifier as String) as? LanguageTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let language = LanguageManager.getInstance().languages[indexPath.row]
        cell.languageLabel.text = language.language
        
        if currentIndex == language.id {
            cell.checkBtn.isHidden = false
        }
        else {
            cell.checkBtn.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        tableView.reloadData()
    }
    
    func doneClicked() {
        UserDefaultManager.getInstance().setCurrentLanguage(value: currentIndex)
        let language = LanguageManager.getInstance().languages[currentIndex]
        if settingLanguageDelegate != nil {
            settingLanguageDelegate.languageClicked(language: language)
        }
    }
}
