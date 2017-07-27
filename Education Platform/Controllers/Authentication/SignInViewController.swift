//
//  SignInViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/5/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift
import PasswordTextField
import FontAwesomeKit
import Alamofire
import FacebookLogin
import FacebookCore
import Google
import M13Checkbox

class SignInViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let iconImgView = UIImageView()
    let facebookButton = UIButton()
    let googleButton = UIButton()
    let orLabel = UILabel()
    let errorLabel = UILabel()
    let emailField = UITextField()
    let emailBorder = UIView()
    let passwordField = PasswordTextField()
    let passwordBorder = UIView()
    let forgotButton = UIButton()
    let signInButton = UIButton()
    let rememberBox = M13Checkbox(frame: .zero)
    let rememberButton = UIButton()
    
    let newUserView = UIView()
    let newUserButton = UIButton()
    let signUpBtn = UIButton()
    
    let socialLoginService = SocialLoginService()
    
    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Global.colorBg
        self.view.tintColor = Global.colorMain
        self.view.addTapToDismiss()
        
        socialLoginService.viewController = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //init navigation bar
        navigationController!.navigationBar.barTintColor = Global.colorMain
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        iconImgView.clipsToBounds = true
        iconImgView.image = UIImage(named: "gaijin-greenery")
        iconImgView.contentMode = .scaleAspectFit
        
        let facebookIcon = FAKFoundationIcons.socialFacebookIcon(withSize: 30)
        facebookIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        facebookButton.setImage(facebookIcon?.image(with: CGSize(width: 30, height: 30)), for: .normal)
        facebookIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        facebookButton.setImage(facebookIcon?.image(with: CGSize(width: 30, height: 30)), for: .highlighted)
        facebookButton.setTitleColor(UIColor.white, for: .normal)
        facebookButton.setTitleColor(Global.colorMain, for: .highlighted)
        facebookButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        facebookButton.addTarget(self, action: #selector(loginFacebook), for: .touchUpInside)
        facebookButton.backgroundColor = Global.colorFacebook
        facebookButton.layer.cornerRadius = 5
        facebookButton.clipsToBounds = true
        facebookButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        
        let googleIcon = FAKFoundationIcons.socialGooglePlusIcon(withSize: 30)
        googleIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        googleButton.setImage(googleIcon?.image(with: CGSize(width: 30, height: 30)), for: .normal)
        googleIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        googleButton.setImage(googleIcon?.image(with: CGSize(width: 30, height: 30)), for: .highlighted)
        googleButton.setTitleColor(UIColor.white, for: .normal)
        googleButton.setTitleColor(Global.colorMain, for: .highlighted)
        googleButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        googleButton.addTarget(self, action: #selector(loginGoogle), for: .touchUpInside)
        googleButton.backgroundColor = Global.colorGoogle
        googleButton.layer.cornerRadius = 5
        googleButton.clipsToBounds = true
        
        orLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        orLabel.textAlignment = .center
        orLabel.textColor = Global.colorGray
        orLabel.adjustsFontSizeToFitWidth = true
        orLabel.font = UIFont(name: "OpenSans-semibold", size: 15)
        
        errorLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.font = UIFont(name: "OpenSans", size: 14)
        
        emailField.font = UIFont(name: "OpenSans", size: 17)
        emailField.delegate = self
        emailField.textColor = UIColor.black
        emailField.addSubview(emailBorder)
        emailField.returnKeyType = .next
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailBorder.backgroundColor = Global.colorSeparator
        
        passwordField.font = UIFont(name: "OpenSans", size: 17)
        passwordField.delegate = self
        passwordField.textColor = UIColor.black
        passwordField.addSubview(passwordBorder)
        passwordField.returnKeyType = .go
        passwordField.keyboardType = .asciiCapable
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordBorder.backgroundColor = Global.colorSeparator
        
        forgotButton.setTitleColor(Global.colorGray, for: .normal)
        forgotButton.setTitleColor(Global.colorMain, for: .highlighted)
        forgotButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        forgotButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        forgotButton.sizeToFit()
        forgotButton.contentHorizontalAlignment = .right
        forgotButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        forgotButton.isHidden = true
        
        rememberBox.boxType = .square
        rememberBox.markType = .checkmark
        rememberBox.stateChangeAnimation = .bounce(.stroke)
        
        rememberButton.setTitle("Remember Me?", for: .normal)
        rememberButton.setTitleColor(Global.colorGray, for: .normal)
        rememberButton.setTitleColor(Global.colorMain, for: .highlighted)
        rememberButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        rememberButton.addTarget(self, action: #selector(remember), for: .touchUpInside)
        rememberButton.sizeToFit()
        
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.setTitleColor(Global.colorSelected, for: .highlighted)
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        signInButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        signInButton.backgroundColor = Global.colorMain
        
        newUserButton.setTitleColor(Global.colorGray, for: .normal)
        newUserButton.setTitleColor(Global.colorMain, for: .highlighted)
        newUserButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        newUserButton.sizeToFit()
        newUserButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        newUserButton.contentHorizontalAlignment = .center
        newUserButton.isUserInteractionEnabled = false
        
        signUpBtn.setTitleColor(Global.colorMain, for: .normal)
        signUpBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        signUpBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        signUpBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        signUpBtn.sizeToFit()
        signUpBtn.contentHorizontalAlignment = .center
        
        containerView.addSubview(iconImgView)
        containerView.addSubview(facebookButton)
        containerView.addSubview(googleButton)
        containerView.addSubview(orLabel)
        containerView.addSubview(errorLabel)
        containerView.addSubview(emailField)
        containerView.addSubview(passwordField)
        containerView.addSubview(forgotButton)
        containerView.addSubview(rememberBox)
        containerView.addSubview(rememberButton)
        containerView.addSubview(signInButton)
        containerView.addSubview(newUserView)
        newUserView.addSubview(newUserButton)
        newUserView.addSubview(signUpBtn)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        setLanguageRuntime()
        view.setNeedsUpdateConstraints()
    }
    
    func setLanguageRuntime(){
        self.navigationItem.title = "sign_in".localized().uppercased()
        facebookButton.setTitle("Facebook", for: .normal)
        googleButton.setTitle("Google", for: .normal)
        orLabel.text = "or".localized().uppercased()
        emailField.placeholder = "email".localized()
        passwordField.placeholder = "password".localized()
        signInButton.setTitle("sign_in".localized().uppercased(), for: .normal)
        newUserButton.setTitle("do_you_have_an_account".localized(), for: .normal)
        forgotButton.setTitle("forgot_password".localized() + "?", for: .normal)
        signUpBtn.setTitle("sign_up".localized(), for: .normal)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: view)
            
            iconImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
            iconImgView.autoSetDimensions(to: CGSize(width: 200, height: 100))
            iconImgView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            facebookButton.autoPinEdge(.top, to: .bottom, of: iconImgView, withOffset: 20)
            facebookButton.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            facebookButton.autoSetDimension(.height, toSize: 40)
            let facebookWidth = facebookButton.autoMatch(.width, to: .width, of: view, withMultiplier: 0.5)
            facebookWidth.constant = -15
            
            googleButton.autoPinEdge(.top, to: .bottom, of: iconImgView, withOffset: 20)
            googleButton.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            googleButton.autoSetDimension(.height, toSize: 40)
            googleButton.autoPinEdge(.left, to: .right, of: facebookButton, withOffset: 10)
            
            orLabel.autoPinEdge(toSuperviewEdge: .left)
            orLabel.autoPinEdge(toSuperviewEdge: .right)
            orLabel.autoPinEdge(.top, to: .bottom, of: facebookButton, withOffset: 10)
            orLabel.autoSetDimension(.height, toSize: 30)
            
            errorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            errorLabel.autoPinEdge(.top, to: .bottom, of: orLabel, withOffset: 1)
            errorLabel.autoSetDimension(.height, toSize: 20)
            
            emailField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            emailField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            emailField.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 1)
            emailField.autoSetDimension(.height, toSize: 40)
            
            emailBorder.autoPinEdge(toSuperviewEdge: .left)
            emailBorder.autoPinEdge(toSuperviewEdge: .right)
            emailBorder.autoPinEdge(toSuperviewEdge: .bottom)
            emailBorder.autoSetDimension(.height, toSize: 1)
            
            passwordField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            passwordField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            passwordField.autoPinEdge(.top, to: .bottom, of: emailField, withOffset: 10)
            passwordField.autoSetDimension(.height, toSize: 40)
            
            passwordBorder.autoPinEdge(toSuperviewEdge: .left)
            passwordBorder.autoPinEdge(toSuperviewEdge: .right)
            passwordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            passwordBorder.autoSetDimension(.height, toSize: 1)
            
            forgotButton.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            forgotButton.autoPinEdge(.top, to: .bottom, of: passwordField)
            forgotButton.autoSetDimension(.height, toSize: 30)
            
            rememberBox.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            rememberBox.autoPinEdge(.top, to: .bottom, of: passwordField, withOffset: 7)
            rememberBox.autoSetDimension(.height, toSize: 15)
            rememberBox.autoSetDimension(.width, toSize: 15)
            
            rememberButton.autoPinEdge(.left, to: .right, of: rememberBox, withOffset: 5)
            rememberButton.autoPinEdge(.top, to: .bottom, of: passwordField, withOffset: 7)
            rememberButton.autoSetDimension(.height, toSize: 15)
            
            signInButton.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            signInButton.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            signInButton.autoPinEdge(.top, to: .bottom, of: forgotButton, withOffset: 20)
            signInButton.autoSetDimension(.height, toSize: 50)
            
            //---------------------------------------------------------------------------
            
            newUserView.autoPinEdge(.top, to: .bottom, of: signInButton, withOffset: 30)
            newUserView.autoSetDimension(.height, toSize: 30)
            newUserView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            signUpBtn.autoPinEdge(toSuperviewEdge: .top)
            signUpBtn.autoPinEdge(toSuperviewEdge: .right)
            signUpBtn.autoPinEdge(.left, to: .right, of: newUserButton, withOffset: 5)
            signUpBtn.autoSetDimension(.height, toSize: 30)
            
            newUserButton.autoPinEdge(toSuperviewEdge: .left)
            newUserButton.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            newUserButton.autoSetDimension(.height, toSize: 30)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?){
        if self.presentedViewController != nil {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    func refreshView() {
        let height : CGFloat = 530
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func loginFacebook() {
        socialLoginService.loginFacebook()
    }
    
    func loginGoogle() {
        socialLoginService.loginGoogle()
    }
    
    func signIn() {
        if !checkInput(textField: emailField, value: emailField.text) {
            return
        }
        if !checkInput(textField: passwordField, value: passwordField.text) {
            return
        }
        
        view.endEditing(true)
        
        let email = emailField.text!
        let password = passwordField.text!
        
        var remember = false
        
        if rememberBox.checkState.rawValue == "Checked" {
            remember = true
        }
        
        SwiftOverlays.showBlockingWaitOverlay()
        AccountService.login(email: email, password: password, remember: remember) { (success, message) in
            if success == true {
                SwiftOverlays.removeAllBlockingOverlays()
                UserDefaultManager.getInstance().setCurrentAccountType(value: "normal")
                self.present(MainViewController(), animated:true, completion:nil)                
            }
            else {
                SwiftOverlays.removeAllBlockingOverlays()
                self.errorLabel.text = message
            }
        }
    }
    
    func loginFinished(success: Bool) {

    }
    
    func signUp() {
        let nav = UINavigationController(rootViewController: SignUpViewController())
        self.present(nav, animated:true, completion:nil)
    }
    
    func forgotPassword() {
        
    }
    
    func remember() {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
                return true
            }
        default:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                signIn()
                return true
            }
        }
        return false
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case emailField:
            if value != nil && value!.isValidEmail() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_email_address".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_password".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        }
        return false
    }
}
