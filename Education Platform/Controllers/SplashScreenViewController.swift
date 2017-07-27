//
//  SplashScreenViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 2/14/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift
import FacebookLogin
import FacebookCore

class SplashScreenViewController: UIViewController {
    
    let appNameLabel = UILabel ()
    let iconImgView = UIImageView()
    
    var constraintsAdded = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorMain
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.iconImgView.isHidden = false
        })
        
        appNameLabel.font = UIFont(name: "OpenSans-semibold", size: 50)
        appNameLabel.lineBreakMode = .byWordWrapping
        appNameLabel.numberOfLines = 0
        appNameLabel.textColor = UIColor.white
        appNameLabel.textAlignment = .center
        appNameLabel.text = "gaijinnavi".localized()
        appNameLabel.increaseSize()
        
        iconImgView.clipsToBounds = true
        iconImgView.layer.masksToBounds = true
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.image = UIImage(named: "citynow_create_tomorrow")
        CATransaction.commit()
        
        view.addSubview(appNameLabel)
        view.addSubview(iconImgView)
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let result = UserDefaultManager.getInstance().getIsInitApp()
        if result {
            let user = UserDefaultManager.getInstance().getCurrentUser()
            if user != nil {
                let currrentAccountType = UserDefaultManager.getInstance().getCurrentAccountType()
                let currentToken = UserDefaultManager.getInstance().getCurrentToken()
                if currrentAccountType == "facebook" {
                    AccountService.loginSocial(token: currentToken!, type: "facebook") { (success, message) in
                        if success == true {
                            self.navToMainPage()
                        }
                        else {
                            let loginFacebookManager = LoginManager()
                            loginFacebookManager.logOut()
                            self.navToSignInPage()
                        }
                    }
                }
                else if currrentAccountType == "google" {
                    AccountService.loginSocial(token: currentToken!, type: "google") { (success, message) in
                        if success == true {
                            self.navToMainPage()
                        }
                        else {
                            GIDSignIn.sharedInstance().signOut()
                            self.navToSignInPage()
                        }
                    }
                }
                else {
                    if (user?.User.rememberMe)!  {
                        AccountService.login(email: user!.User.Email, password: user!.User.Password, remember: (user?.User.rememberMe)!) { (success, message) in
                            if success == true {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.present(MainViewController(), animated: true, completion: nil)
                                }
                            }
                            else {
                                self.navToSignInPage()
                            }
                        }
                    }
                    else {
                        self.navToSignInPage()
                    }
                }
            }
            else {
                navToSignInPage()
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = IntroViewController()
            }
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            appNameLabel.autoPinEdge(toSuperviewEdge: .left)
            appNameLabel.autoPinEdge(toSuperviewEdge: .right)
            appNameLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
            appNameLabel.autoSetDimension(.height, toSize: 100)
            
            iconImgView.autoSetDimension(.width, toSize: 200)
            iconImgView.autoSetDimension(.height, toSize: 80)
            iconImgView.autoAlignAxis(toSuperviewAxis: .vertical)
            iconImgView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        }
    }
    
    func navToSignInPage() {
        FriendServices.getInstance().removeAllFriendList()
        Utils.setBadgeIndicator(badgeCount: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let nav = UINavigationController(rootViewController: SignInViewController())
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nav
        }
    }
    
    func navToMainPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = MainViewController()
        }
    }
}
