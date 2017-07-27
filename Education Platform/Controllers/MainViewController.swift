//
//  MainViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/2/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift

protocol MainViewDelegate {
    func confirmedEmail()
}

class MainViewController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate, MainViewDelegate {
    
    let gradientView = GradientView()
    static var newsFeedViewController = NewsFeedViewController()
    static var jobCategoryViewController = JobCategoryViewController()
    static var messageViewController = MasterChatViewController()
    static var searchViewController = SchoolViewController()
    static var menuViewController = MenuViewController()
    
    var isOpen = false
    static var isConfirmEmail = false
    static var timer: Timer?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    func confirmedEmail() {
        Utils.showAlert(title: "Gaijinnavi", message: "confirm_email_successfully".localized(), viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        view.tintColor = Global.colorMain
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = UIColor.white
        tabBar.backgroundImage = UIImage()
        tabBar.isTranslucent = false
        delegate = self
        selectedIndex = 2
        
        let attributesNormal = [NSForegroundColorAttributeName: Global.colorGray, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10)!]
        let attributesSelected = [NSForegroundColorAttributeName: Global.colorMain, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10)!]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
        MainViewController.newsFeedViewController = NewsFeedViewController()
        MainViewController.jobCategoryViewController = JobCategoryViewController()
        MainViewController.messageViewController = MasterChatViewController()
        MainViewController.searchViewController = SchoolViewController()
        MainViewController.menuViewController = MenuViewController()
        
        let listIcon = FAKFontAwesome.listIcon(withSize: 25)
        listIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorBg)
        let listImg  = listIcon?.image(with: CGSize(width: 25, height: 25))
        
        let newsFeedTabBarItem = UITabBarItem(title: "news_feed".localized().uppercased(), image: listImg, tag: 1)
        MainViewController.newsFeedViewController.tabBarItem = newsFeedTabBarItem
        let nc1 = UINavigationController(rootViewController: MainViewController.newsFeedViewController)
        
        let briefcaseIcon = FAKIonIcons.briefcaseIcon(withSize: 25)
        briefcaseIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorBg)
        let briefcaseImg = briefcaseIcon?.image(with: CGSize(width: 25, height: 25))
        
        let jobTabBarItem = UITabBarItem(title: "job".localized().uppercased(), image: briefcaseImg, tag: 2)
        MainViewController.jobCategoryViewController.tabBarItem = jobTabBarItem
        let nc3 = UINavigationController(rootViewController: MainViewController.jobCategoryViewController)
        
        let chatbubbleWorkingIcon = FAKIonIcons.chatbubbleWorkingIcon(withSize: 25)
        chatbubbleWorkingIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorBg)
        let chatbubbleWorkingImg  = chatbubbleWorkingIcon?.image(with: CGSize(width: 25, height: 25))
        
        let messageTabBarItem = UITabBarItem(title: "message".localized().uppercased(), image: chatbubbleWorkingImg, tag: 3)
        MainViewController.messageViewController.tabBarItem = messageTabBarItem
        let nc4 = UINavigationController(rootViewController: MainViewController.messageViewController)
        
        let searchIcon = FAKIonIcons.universityIcon(withSize: 25)
        searchIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorBg)
        let searchImg  = searchIcon?.image(with: CGSize(width: 25, height: 25))
        
        let searchTabBarItem = UITabBarItem(title: "school".localized().uppercased(), image: searchImg, tag: 4)
        MainViewController.searchViewController.tabBarItem = searchTabBarItem
        let nc2 = UINavigationController(rootViewController: MainViewController.searchViewController)
        
        let barsIcon = FAKFontAwesome.barsIcon(withSize: 25)
        barsIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorBg)
        let barsImg  = barsIcon?.image(with: CGSize(width: 25, height: 25))
        
        let menuTabBarItem = UITabBarItem(title: "more".localized().uppercased(), image: barsImg, tag: 5)
        MainViewController.menuViewController.tabBarItem = menuTabBarItem
        let nc5 = UINavigationController(rootViewController: MainViewController.menuViewController)
        
        self.viewControllers = [nc1, nc3, nc4, nc2, nc5]
        
        FriendServices.getInstance().getDataUser()
        connectWebSocket()
        
        
        if  MainViewController.timer != nil {
            MainViewController.timer?.invalidate()
            MainViewController.timer = nil
        }
        
        MainViewController.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerStart), userInfo: nil, repeats: true)
        RunLoop.current.add(MainViewController.timer!, forMode: RunLoopMode.commonModes)
    }
    
    func timerStart() {
        AccountService.checkAccountConfirmation() {
            result in
            if result == true {
                if MainViewController.timer != nil {
                    MainViewController.timer?.invalidate()
                    MainViewController.timer = nil
                }
                MainViewController.isConfirmEmail = true
            }
            else {
                MainViewController.isConfirmEmail = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ =  FriendServices.getInstance()
        
        if !isOpen {
            isOpen = true
            AccountService.checkAccountConfirmation() {
                result in
                if result == false {
                    MainViewController.isConfirmEmail = false
                    let viewController = ConfirmEmailViewController()
                    viewController.closeBtn.isHidden = false
                    viewController.mainViewDelegate = self
                    self.present(viewController, animated: true, completion: nil)
                }
                else {
                    MainViewController.isConfirmEmail = true
                }
            }
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func connectWebSocket() {
        let currentUser = UserDefaultManager.getInstance().getCurrentUser()
        
        if currentUser == nil {
            return
        }
        
        if(currentUser?.User.Id != 0) {
            WebSocketServices.shared.Connect(UserId: (currentUser?.User.Id)!, Token: (currentUser?.User.Token)!)
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        if self.presentedViewController != nil {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    var previousTag = 1
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 && previousTag == 1 {
            let indexPath = NSIndexPath(row: 0, section: 0)
            MainViewController.newsFeedViewController.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        }
        else if item.tag == 4 && previousTag == 4 {
            let indexPath = NSIndexPath(row: 0, section: 0)
            MainViewController.searchViewController.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        }
        
        previousTag = item.tag
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if(viewController == tabBarController.viewControllers?[2]) {
            if MainViewController.isConfirmEmail == false {
                let viewController = ConfirmEmailViewController()
                viewController.closeBtn.isHidden = false
                viewController.mainViewDelegate = self
                self.present(viewController, animated: true, completion: nil)
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
}
