//
//  MenuViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/2/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift
import FacebookLogin
import FacebookCore
import Google
import Kingfisher
import STPopup
import MessageUI

class MenuViewController: UIViewController, AlertDelegate, SettingLanguageDelegate, MFMailComposeViewControllerDelegate, MainViewDelegate {
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let firstView = UIView()
    let secondView = UIView()
    let thirdView = UIView()
    let fourView = UIView()
    
    var profileView: MenuView!
    var followPostView: MenuView!
    
    var newPostView: MenuView!
    var myfollowerView: MenuView!
    
    var languageView: MenuView!
    var feedBackView: MenuView!
    var aboutView: MenuView!
    var rateAndReviewView: MenuView!
    
    var changePasswordView: MenuView!
    var logoutView: MenuView!
    
    let gradientView = GradientView()
    var constraintsAdded = false
    var user: RoleResult!
    
    var settingLanguagePopupController: STPopupController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = UIColor.white
        view.clipsToBounds = true
        
        navigationController?.navigationBar.barTintColor = Global.colorMain
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = Global.colorHeader
        containerView.backgroundColor = Global.colorHeader
        
        firstView.backgroundColor = UIColor.white
        firstView.layer.cornerRadius = 5
        
        secondView.backgroundColor = UIColor.white
        secondView.layer.cornerRadius = 5
        
        thirdView.backgroundColor = UIColor.white
        thirdView.layer.cornerRadius = 5
        
        fourView.backgroundColor = UIColor.white
        fourView.layer.cornerRadius = 5
        
        profileView = MenuView.instanceFromNib() as! MenuView
        profileView.layer.cornerRadius = 5

        profileView.iconBtn.imageView?.contentMode = .scaleAspectFill
        profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (profiledetailView)))
        
        followPostView = MenuView.instanceFromNib() as! MenuView
        let starIcon = FAKIonIcons.socialTwitterIcon(withSize: 20)
        starIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let starImg  = starIcon?.image(with: CGSize(width: 20, height: 20))
        followPostView.iconBtn.setImage(starImg, for: .normal)
        followPostView.iconBtn.tintColor = UIColor.white
        followPostView.iconBtn.imageView?.contentMode = .scaleAspectFit
        followPostView.iconBtn.backgroundColor = Global.colorMain
        followPostView.iconBtn.layer.cornerRadius = 3
        followPostView.lineView.isHidden = true
        followPostView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (followCall)))
        
        newPostView = MenuView.instanceFromNib() as! MenuView
        let plusCircledIcon = FAKFontAwesome.plusCircleIcon(withSize: 20)
        plusCircledIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let plusCircledImg  = plusCircledIcon?.image(with: CGSize(width: 20, height: 20))
        newPostView.iconBtn.setImage(plusCircledImg, for: .normal)
        newPostView.iconBtn.tintColor = UIColor.white
        newPostView.iconBtn.imageView?.contentMode = .scaleAspectFit
        newPostView.iconBtn.backgroundColor = Global.colorMain
        newPostView.iconBtn.layer.cornerRadius = 3
        
        myfollowerView = MenuView.instanceFromNib() as! MenuView
        let checkCircleIcon = FAKFontAwesome.checkCircleIcon(withSize: 20)
        checkCircleIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let checkCircleImg  = checkCircleIcon?.image(with: CGSize(width: 20, height: 20))
        myfollowerView.iconBtn.setImage(checkCircleImg, for: .normal)
        myfollowerView.iconBtn.tintColor = UIColor.white
        myfollowerView.iconBtn.imageView?.contentMode = .scaleAspectFit
        myfollowerView.iconBtn.backgroundColor = Global.colorMain
        myfollowerView.iconBtn.layer.cornerRadius = 3
        myfollowerView.lineView.isHidden = true
        
        languageView = MenuView.instanceFromNib() as! MenuView
        let globeIcon = FAKFontAwesome.globeIcon(withSize: 20)
        globeIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let globeImg  = globeIcon?.image(with: CGSize(width: 20, height: 20))
        languageView.iconBtn.setImage(globeImg, for: .normal)
        languageView.iconBtn.tintColor = UIColor.white
        languageView.iconBtn.imageView?.contentMode = .scaleAspectFit
        languageView.iconBtn.backgroundColor = Global.colorMain
        languageView.iconBtn.layer.cornerRadius = 3
        languageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (settingLanguage)))
        
        feedBackView = MenuView.instanceFromNib() as! MenuView
        let chatboxWorkingIcon = FAKIonIcons.chatboxWorkingIcon(withSize: 20)
        chatboxWorkingIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let chatboxWorkingImg  = chatboxWorkingIcon?.image(with: CGSize(width: 20, height: 20))
        feedBackView.iconBtn.setImage(chatboxWorkingImg, for: .normal)
        feedBackView.iconBtn.tintColor = UIColor.white
        feedBackView.iconBtn.imageView?.contentMode = .scaleAspectFit
        feedBackView.iconBtn.backgroundColor = Global.colorMain
        feedBackView.iconBtn.layer.cornerRadius = 3
        feedBackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (feedBackCall)))
        
        aboutView = MenuView.instanceFromNib() as! MenuView
        let iosInformationIcon = FAKIonIcons.iosInformationIcon(withSize: 20)
        iosInformationIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let iosInformationImg  = iosInformationIcon?.image(with: CGSize(width: 20, height: 20))
        aboutView.iconBtn.setImage(iosInformationImg, for: .normal)
        aboutView.iconBtn.tintColor = UIColor.white
        aboutView.iconBtn.imageView?.contentMode = .scaleAspectFit
        aboutView.iconBtn.backgroundColor = Global.colorMain
        aboutView.iconBtn.layer.cornerRadius = 3
        aboutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (aboutCall)))
        
        rateAndReviewView = MenuView.instanceFromNib() as! MenuView
        let rateIcon = FAKFontAwesome.starIcon(withSize: 20)
        rateIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let rateImg  = rateIcon?.image(with: CGSize(width: 20, height: 20))
        rateAndReviewView.iconBtn.setImage(rateImg, for: .normal)
        rateAndReviewView.iconBtn.tintColor = UIColor.white
        rateAndReviewView.iconBtn.imageView?.contentMode = .scaleAspectFit
        rateAndReviewView.iconBtn.backgroundColor = Global.colorMain
        rateAndReviewView.iconBtn.layer.cornerRadius = 3
        rateAndReviewView.lineView.isHidden = true
        rateAndReviewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (rateAndReviewCall)))
        
        changePasswordView = MenuView.instanceFromNib() as! MenuView
        let keyIcon = FAKFontAwesome.keyIcon(withSize: 20)
        keyIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let keyImg  = keyIcon?.image(with: CGSize(width: 20, height: 20))
        changePasswordView.iconBtn.setImage(keyImg, for: .normal)
        changePasswordView.iconBtn.tintColor = UIColor.white
        changePasswordView.iconBtn.imageView?.contentMode = .scaleAspectFit
        changePasswordView.iconBtn.backgroundColor = Global.colorMain
        changePasswordView.iconBtn.layer.cornerRadius = 3
        changePasswordView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (changePasswordCall)))
        
        logoutView = MenuView.instanceFromNib() as! MenuView
        logoutView.lineView.isHidden = true
        let signOutIcon = FAKFontAwesome.signOutIcon(withSize: 20)
        signOutIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let signOutImg  = signOutIcon?.image(with: CGSize(width: 20, height: 20))
        logoutView.iconBtn.setImage(signOutImg, for: .normal)
        logoutView.iconBtn.tintColor = UIColor.white
        logoutView.iconBtn.imageView?.contentMode = .scaleAspectFit
        logoutView.iconBtn.backgroundColor = Global.colorMain
        logoutView.iconBtn.layer.cornerRadius = 3
        logoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (logOut)))
        logoutView.tintColor = Global.colorGray
        logoutView.nextBtn.isHidden = true
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        indicator.startAnimating()
        
        firstView.addSubview(profileView)
        firstView.addSubview(followPostView)
        //        secondView.addSubview(newPostView)
        //        secondView.addSubview(myPostView)
        //        secondView.addSubview(myfollowerView)
        thirdView.addSubview(languageView)
        thirdView.addSubview(feedBackView)
        thirdView.addSubview(aboutView)
        thirdView.addSubview(rateAndReviewView)
        //        fourView.addSubview(changePasswordView)
        fourView.addSubview(logoutView)
        containerView.addSubview(firstView)
        //        containerView.addSubview(secondView)
        containerView.addSubview(thirdView)
        containerView.addSubview(fourView)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        view.addSubview(indicator)

        setLanguageRuntime()
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        
        loadData()
    }
    
    func loadData() {
        AccountService.getUser() {
            newUser in
            
            if newUser != nil {
                self.user = newUser
                if self.user.User.Avatar != "" {
                    self.profileView.iconBtn.kf.setImage(with: URL(string: self.user.User.Avatar), for: .normal)
                }
                self.profileView.titleLabel.text = self.user.User.DisplayName
            }
            else {
                self.profileView.iconBtn.setImage(UIImage(named: "ic_user"), for: .normal)
            }
            
            self.profileView.iconBtn.imageView?.layer.cornerRadius = 5
            self.indicator.stopAnimating()
        }
    }
    
    func setLanguageRuntime(){
        self.navigationItem.title = "more".localized().uppercased()
        followPostView.titleLabel.text = "follow".localized().uppercased()
        newPostView.titleLabel.text = "new_post".localized().uppercased()
        myfollowerView.titleLabel.text = "my_followers".localized().uppercased()
        languageView.titleLabel.text = "setting_language".localized().uppercased()
        feedBackView.titleLabel.text = "feedback".localized().uppercased()
        aboutView.titleLabel.text = "about".localized().uppercased()
        rateAndReviewView.titleLabel.text = "rate_and_review".localized().uppercased()
        changePasswordView.titleLabel.text = "change_password".localized().uppercased()
        logoutView.titleLabel.text = "logout".localized().uppercased()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: view)
            
            if DeviceType.IS_IPAD {
                firstView.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
                firstView.autoPinEdge(toSuperviewEdge: .right, withInset: 50)
                firstView.autoPinEdge(toSuperviewEdge: .left, withInset: 50)
                firstView.autoSetDimension(.height, toSize: 120)
                
                //                secondView.autoPinEdge(.top, to: .bottom, of: firstView, withOffset: 20)
                //                secondView.autoPinEdge(toSuperviewEdge: .right, withInset: 50)
                //                secondView.autoPinEdge(toSuperviewEdge: .left, withInset: 50)
                //                secondView.autoSetDimension(.height, toSize: 180)
                
                thirdView.autoPinEdge(.top, to: .bottom, of: firstView, withOffset: 20)
                thirdView.autoPinEdge(toSuperviewEdge: .right, withInset: 50)
                thirdView.autoPinEdge(toSuperviewEdge: .left, withInset: 50)
                thirdView.autoSetDimension(.height, toSize: 240)
                
                fourView.autoPinEdge(.top, to: .bottom, of: thirdView, withOffset: 20)
                fourView.autoPinEdge(toSuperviewEdge: .right, withInset: 50)
                fourView.autoPinEdge(toSuperviewEdge: .left, withInset: 50)
                fourView.autoSetDimension(.height, toSize: 60)
                
            }
            else {
                firstView.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
                firstView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
                firstView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
                firstView.autoSetDimension(.height, toSize: 120)
                
                //                secondView.autoPinEdge(.top, to: .bottom, of: firstView, withOffset: 20)
                //                secondView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
                //                secondView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
                //                secondView.autoSetDimension(.height, toSize: 180)
                //
                thirdView.autoPinEdge(.top, to: .bottom, of: firstView, withOffset: 20)
                thirdView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
                thirdView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
                thirdView.autoSetDimension(.height, toSize: 240)
                
                fourView.autoPinEdge(.top, to: .bottom, of: thirdView, withOffset: 20)
                fourView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
                fourView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
                fourView.autoSetDimension(.height, toSize: 60)
            }
            
            profileView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            profileView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            profileView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            profileView.autoSetDimension(.height, toSize: 60)
            
            followPostView.autoPinEdge(.top, to: .bottom, of: profileView, withOffset: 0)
            followPostView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            followPostView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            followPostView.autoSetDimension(.height, toSize: 60)
            
            //            newPostView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            //            newPostView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            //            newPostView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            //            newPostView.autoSetDimension(.height, toSize: 60)
            //
            //            myPostView.autoPinEdge(.top, to: .bottom, of: newPostView, withOffset: 0)
            //            myPostView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            //            myPostView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            //            myPostView.autoSetDimension(.height, toSize: 60)
            //
            //            myfollowerView.autoPinEdge(.top, to: .bottom, of: myPostView, withOffset: 0)
            //            myfollowerView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            //            myfollowerView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            //            myfollowerView.autoSetDimension(.height, toSize: 60)
            
            languageView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            languageView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            languageView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            languageView.autoSetDimension(.height, toSize: 60)
            
            feedBackView.autoPinEdge(.top, to: .bottom, of: languageView, withOffset: 0)
            feedBackView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            feedBackView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            feedBackView.autoSetDimension(.height, toSize: 60)
            
            aboutView.autoPinEdge(.top, to: .bottom, of: feedBackView, withOffset: 0)
            aboutView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            aboutView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            aboutView.autoSetDimension(.height, toSize: 60)
            
            rateAndReviewView.autoPinEdge(.top, to: .bottom, of: aboutView, withOffset: 0)
            rateAndReviewView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            rateAndReviewView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            rateAndReviewView.autoSetDimension(.height, toSize: 60)
            
            //            changePasswordView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            //            changePasswordView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            //            changePasswordView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            //            changePasswordView.autoSetDimension(.height, toSize: 60)
            
            //            logoutView.autoPinEdge(.top, to: .bottom, of: changePasswordView, withOffset: 0)
            logoutView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            logoutView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            logoutView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            logoutView.autoSetDimension(.height, toSize: 60)
            
            indicator.autoPinEdgesToSuperviewEdges()
        }
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 500
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func profiledetailView() {
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
    
    func settingLanguage() {
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        
        let settingLanguageViewController = SettingLanguageViewController()
        settingLanguageViewController.settingLanguageDelegate = self
        settingLanguagePopupController = STPopupController(rootViewController: settingLanguageViewController)
        settingLanguagePopupController.containerView.layer.cornerRadius = 4
        settingLanguagePopupController.present(in: self)
    }
    
    func languageClicked(language: Language) {
        var code = language.code
        if language.code == "" {
            code = "en"
        }
        if language.code == "ja" {
            UserDefaultManager.getInstance().setLanguageCode(value: "jp")
        }
        else if language.code == "vi" {
            UserDefaultManager.getInstance().setLanguageCode(value: "vn")
        }
        else {
            UserDefaultManager.getInstance().setLanguageCode(value: language.code)
        }

        Localize.setCurrentLanguage(code)
        settingLanguagePopupController.dismiss()
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = SplashScreenViewController()
    }
    
    func logOut() {
        Utils.showAlertAction(title: "logout".localized(), message: "are_you_sure_want_to_logout".localized(), viewController: self, alertDelegate: self)
    }
    
    func okAlertActionClicked() {
        if MainViewController.timer != nil {
            MainViewController.timer?.invalidate()
            MainViewController.timer = nil
        }
        
        let nav = UINavigationController(rootViewController: SignInViewController())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nav
        
        UserDefaultManager.getInstance().setCurrentUser(roleResult: nil)
        let loginFacebookManager = LoginManager()
        loginFacebookManager.logOut()
        
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
        
        FriendServices.getInstance().removeAllFriendList()
        WebSocketServices.shared.Disconnect()
        Utils.setBadgeIndicator(badgeCount: 0)
        GIDSignIn.sharedInstance().signOut()
    }
    
    func logoutParse(error: Error) {

    }
    
    func followCall() {
        let viewController = FollowViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func feedBackCall() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["gaijinnavi@gmail.com"])
            mail.setSubject("feedback_for_swallow_application".localized())
            mail.setMessageBody("feedback_content_for_swallow_application".localized(), isHTML: false)
            mail.navigationBar.isTranslucent = false
            mail.navigationBar.barTintColor = UIColor.red
            mail.navigationBar.tintColor = Global.colorMain
            self.present(mail, animated: true, completion: nil)
        } else {
            Utils.showAlert(title: "error".localized(), message: "you_are_not_logged_in_e_mail_please_check_e_mail_configuration_and_try_again".localized(), viewController: self)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func aboutCall() {
        let viewController = AboutViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func rateAndReviewCall() {
        rateApp(appId: "id1182853331") { success in

        }
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    func changePasswordCall() {
        let viewController = ChangePasswordViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
