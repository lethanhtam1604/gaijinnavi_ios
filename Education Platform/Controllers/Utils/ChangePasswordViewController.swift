//
//  ChangePasswordViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/19/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift
import PasswordTextField
import FontAwesomeKit
import Alamofire

class ChangePasswordViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let iconImgView = UIImageView()
    let errorLabel = UILabel()
    let oldPasswordField = PasswordTextField()
    let oldPasswordBorder = UIView()
    let passwordField = PasswordTextField()
    let passwordBorder = UIView()
    let confirmPasswordField = PasswordTextField()
    let confirmPasswordBorder = UIView()
    let sendNewPasswordButton = UIButton()
    
    let gradientView = GradientView()
    let gradientSendNewPasswordBtn = GradientView()
    
    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Global.colorHeader
        self.view.tintColor = Global.colorSecond
        self.view.addTapToDismiss()
        
        iconImgView.clipsToBounds = true
        iconImgView.image = UIImage(named: "citynow")
        
        errorLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        oldPasswordField.delegate = self
        oldPasswordField.textColor = Global.colorSecond
        oldPasswordField.addSubview(oldPasswordBorder)
        oldPasswordField.returnKeyType = .next
        oldPasswordField.keyboardType = .asciiCapable
        oldPasswordField.inputAccessoryView = UIView()
        oldPasswordField.autocorrectionType = .no
        oldPasswordField.autocapitalizationType = .none
        oldPasswordBorder.backgroundColor = Global.colorBg
        
        passwordField.delegate = self
        passwordField.textColor = Global.colorSecond
        passwordField.addSubview(passwordBorder)
        passwordField.returnKeyType = .next
        passwordField.keyboardType = .asciiCapable
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordBorder.backgroundColor = Global.colorBg
        
        confirmPasswordField.delegate = self
        confirmPasswordField.textColor = Global.colorSecond
        confirmPasswordField.addSubview(confirmPasswordBorder)
        confirmPasswordField.returnKeyType = .go
        confirmPasswordField.keyboardType = .asciiCapable
        confirmPasswordField.inputAccessoryView = UIView()
        confirmPasswordField.autocorrectionType = .no
        confirmPasswordField.autocapitalizationType = .none
        confirmPasswordBorder.backgroundColor = Global.colorBg
        
        sendNewPasswordButton.setTitleColor(UIColor.white, for: .normal)
        sendNewPasswordButton.setTitleColor(Global.colorSelected, for: .highlighted)
        sendNewPasswordButton.insertSubview(gradientSendNewPasswordBtn, at: 0)
        sendNewPasswordButton.addTarget(self, action: #selector(sendNewPassword), for: .touchUpInside)
        sendNewPasswordButton.layer.cornerRadius = 5
        sendNewPasswordButton.clipsToBounds = true
        
        containerView.addSubview(iconImgView)
        containerView.addSubview(errorLabel)
        containerView.addSubview(oldPasswordField)
        containerView.addSubview(passwordField)
        containerView.addSubview(confirmPasswordField)
        containerView.addSubview(sendNewPasswordButton)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        setLanguageRuntime()
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    func setLanguageRuntime(){
        self.navigationItem.title = "change_password".localized()
        oldPasswordField.placeholder = "current_password".localized()
        passwordField.placeholder = "new_password".localized()
        confirmPasswordField.placeholder = "confirm_new_password".localized()
        sendNewPasswordButton.setTitle("send_new_password".localized(), for: .normal)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: view)
            
            iconImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
            iconImgView.autoSetDimensions(to: CGSize(width: 100, height: 100))
            iconImgView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            errorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            errorLabel.autoPinEdge(.top, to: .bottom, of: iconImgView, withOffset: 1)
            errorLabel.autoSetDimension(.height, toSize: 20)
            
            oldPasswordField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            oldPasswordField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            oldPasswordField.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 10)
            oldPasswordField.autoSetDimension(.height, toSize: 40)
            
            oldPasswordBorder.autoPinEdge(toSuperviewEdge: .left)
            oldPasswordBorder.autoPinEdge(toSuperviewEdge: .right)
            oldPasswordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            oldPasswordBorder.autoSetDimension(.height, toSize: 1)
            
            passwordField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            passwordField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            passwordField.autoPinEdge(.top, to: .bottom, of: oldPasswordField, withOffset: 10)
            passwordField.autoSetDimension(.height, toSize: 40)
            
            passwordBorder.autoPinEdge(toSuperviewEdge: .left)
            passwordBorder.autoPinEdge(toSuperviewEdge: .right)
            passwordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            passwordBorder.autoSetDimension(.height, toSize: 1)
            
            confirmPasswordField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            confirmPasswordField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            confirmPasswordField.autoPinEdge(.top, to: .bottom, of: passwordField, withOffset: 10)
            confirmPasswordField.autoSetDimension(.height, toSize: 40)
            
            confirmPasswordBorder.autoPinEdge(toSuperviewEdge: .left)
            confirmPasswordBorder.autoPinEdge(toSuperviewEdge: .right)
            confirmPasswordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            confirmPasswordBorder.autoSetDimension(.height, toSize: 1)
            
            sendNewPasswordButton.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            sendNewPasswordButton.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            sendNewPasswordButton.autoPinEdge(.top, to: .bottom, of: confirmPasswordField, withOffset: 20)
            sendNewPasswordButton.autoSetDimension(.height, toSize: 50)
            
            gradientSendNewPasswordBtn.autoPinEdge(toSuperviewEdge: .left)
            gradientSendNewPasswordBtn.autoPinEdge(toSuperviewEdge: .right)
            gradientSendNewPasswordBtn.autoPinEdge(toSuperviewEdge: .top)
            gradientSendNewPasswordBtn.autoSetDimension(.height, toSize: 50)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 380
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = containerView.bounds.size
    }
    
   
    func sendNewPassword() {
        if !checkInput(textField: oldPasswordField, value: oldPasswordField.text) {
            return
        }
        if !checkInput(textField: passwordField, value: passwordField.text) {
            return
        }
        if !checkInput(textField: confirmPasswordField, value: confirmPasswordField.text) {
            return
        }
        
        view.endEditing(true)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case oldPasswordField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
                return true
            }
        case passwordField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                confirmPasswordField.becomeFirstResponder()
                return true
            }
        default:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                sendNewPassword()
                return true
            }
        }
        
        return false
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case oldPasswordField:
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "invalid_current_password".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case passwordField:
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "invalid_new_password".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && passwordField.text != nil && value! == passwordField.text! {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "new_password_mismatch".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
}
