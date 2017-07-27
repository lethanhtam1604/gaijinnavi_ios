//
//  SocialLoginService.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/8/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Google
import Alamofire

class SocialLoginService: NSObject, GIDSignInDelegate {
    
    var viewController: UIViewController!
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func loginFacebook() {
        if AccessToken.current != nil {
            viewController.present(MainViewController(), animated:true, completion:nil)
        }
        else {
            let loginManager = LoginManager()
            
            loginManager.logIn([.publicProfile, .email], viewController: self.viewController, completion: {(loginResult: LoginResult) in
                switch loginResult {
                case .cancelled:
                    loginManager.logOut()
                    Utils.showAlert(title: "error".localized(), message: "could_not_login_please_try_again".localized(), viewController: self.viewController)
                case .failed(_):
                    loginManager.logOut()
                    Utils.showAlert(title: "error".localized(), message: "could_not_login_please_try_again".localized(), viewController: self.viewController)
                case .success(let grantedPermissions, _, let accessToken):
                    
                    if !grantedPermissions.isEmpty {
                        let connection = GraphRequestConnection()
                        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields":"id,email,name,picture.type(large),gender"], accessToken: accessToken, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion)) { httpResponse, result in
                            switch result {
                            case .success(_):
                                SwiftOverlays.showBlockingWaitOverlay()
                                AccountService.loginSocial(token: accessToken.authenticationToken, type: "facebook") { (success, message) in
                                    SwiftOverlays.removeAllBlockingOverlays()
                                    if success == true {
                                        UserDefaultManager.getInstance().setCurrentToken(value: accessToken.authenticationToken)
                                        UserDefaultManager.getInstance().setCurrentAccountType(value: "facebook")
                                        self.viewController.present(MainViewController(), animated:true, completion:nil)
                                    }
                                    else {
                                        loginManager.logOut()
                                        Utils.showAlert(title: "error".localized(), message: message, viewController: self.viewController)
                                    }
                                }
                            case .failed(_):
                                loginManager.logOut()
                                Utils.showAlert(title: "error".localized(), message: "could_not_login_please_try_again".localized(), viewController: self.viewController)
                            }
                        }
                        connection.start()
                    }
                    else {
                        loginManager.logOut()
                    }
                }
            })
        }
    }
    
    func checkAccountParse(isHad: Bool) {

    }
    
    func loginFinished(success: Bool) {
        print(success)
    }
    
    func loginGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            SwiftOverlays.showBlockingWaitOverlay()
            let token = user.authentication.accessToken as String
            
            AccountService.loginSocial(token: token, type: "google") { (success, message) in
                SwiftOverlays.removeAllBlockingOverlays()
                if success == true {
                    UserDefaultManager.getInstance().setCurrentToken(value: token)
                    UserDefaultManager.getInstance().setCurrentAccountType(value: "google")
                    self.viewController.present(MainViewController(), animated:true, completion:nil)
                }
                else {
                    GIDSignIn.sharedInstance().signOut()
                    Utils.showAlert(title: "error".localized(), message: message, viewController: self.viewController)
                }
            }
        }
        else {
            GIDSignIn.sharedInstance().signOut()
            Utils.showAlert(title: "error".localized(), message: "could_not_login_please_try_again".localized(), viewController: self.viewController)
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        GIDSignIn.sharedInstance().signOut()
        Utils.showAlert(title: "error".localized(), message: "could_not_login_please_try_again".localized(), viewController: self.viewController)
    }
    
}
