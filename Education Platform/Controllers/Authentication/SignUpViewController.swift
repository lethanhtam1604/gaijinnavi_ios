//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate, SSRadioButtonControllerDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let iconImgView = UIImageView()
    let facebookButton = UIButton()
    let googleButton = UIButton()
    let orLabel = UILabel()
    let errorLabel = UILabel()
    let displayNameField = UITextField()
    let displayNameBorder = UIView()
    let dobField = UITextField()
    let dobBorder = UIView()
    let emailField = UITextField()
    let emailBorder = UIView()
    let passwordField = PasswordTextField()
    let passwordBorder = UIView()
    let confirmPasswordField = PasswordTextField()
    let confirmPasswordBorder = UIView()
    let signUpButton = UIButton()
    let calendarBtn = UIButton()

    let alreadyView = UIView()
    let signInBtn = UIButton()
    let oldUserButton = UIButton()
    
    let genderLabel = UILabel()
    let maleButton = SSRadioButton()
    let femaleButton = SSRadioButton()
    var radioButtonController: SSRadioButtonsController?
    var gender = 0
    
    let socialLoginService = SocialLoginService()
    
    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socialLoginService.viewController = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //init navigation bar
        navigationController!.navigationBar.barTintColor = Global.colorMain
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        let closeBarButton = UIBarButtonItem(image: UIImage(named: "ic_close_white"), style: .done, target: self, action: #selector(actionTapToCloseButton))
        closeBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = closeBarButton
        
        self.view.backgroundColor = Global.colorBg
        self.view.tintColor = Global.colorMain
        self.view.addTapToDismiss()
        
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
        
        displayNameField.delegate = self
        displayNameField.textColor = UIColor.black
        displayNameField.addSubview(displayNameBorder)
        displayNameField.returnKeyType = .next
        displayNameField.keyboardType = .namePhonePad
        displayNameField.inputAccessoryView = UIView()
        displayNameField.autocorrectionType = .no
        displayNameField.autocapitalizationType = .none
        displayNameBorder.backgroundColor = Global.colorSeparator
        displayNameField.font = UIFont(name: "OpenSans", size: 17)
        
        dobField.delegate = self
        dobField.textColor = UIColor.black
        dobField.addSubview(dobBorder)
        dobField.returnKeyType = .next
        dobField.keyboardType = .namePhonePad
        dobField.inputAccessoryView = UIView()
        dobField.autocorrectionType = .no
        dobField.autocapitalizationType = .none
        dobBorder.backgroundColor = Global.colorSeparator
        dobField.font = UIFont(name: "OpenSans", size: 17)
        dobField.isUserInteractionEnabled = false
        
        emailField.delegate = self
        emailField.textColor = UIColor.black
        emailField.addSubview(emailBorder)
        emailField.returnKeyType = .next
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailBorder.backgroundColor = Global.colorSeparator
        emailField.font = UIFont(name: "OpenSans", size: 17)
        
        passwordField.delegate = self
        passwordField.textColor = UIColor.black
        passwordField.addSubview(passwordBorder)
        passwordField.returnKeyType = .next
        passwordField.keyboardType = .asciiCapable
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordBorder.backgroundColor = Global.colorSeparator
        passwordField.font = UIFont(name: "OpenSans", size: 17)
        
        confirmPasswordField.delegate = self
        confirmPasswordField.textColor = UIColor.black
        confirmPasswordField.addSubview(confirmPasswordBorder)
        confirmPasswordField.returnKeyType = .go
        confirmPasswordField.keyboardType = .asciiCapable
        confirmPasswordField.inputAccessoryView = UIView()
        confirmPasswordField.autocorrectionType = .no
        confirmPasswordField.autocapitalizationType = .none
        confirmPasswordBorder.backgroundColor = Global.colorSeparator
        confirmPasswordField.font = UIFont(name: "OpenSans", size: 17)
        
        genderLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        genderLabel.textAlignment = .left
        genderLabel.textColor = Global.colorGray
        genderLabel.adjustsFontSizeToFitWidth = true
        genderLabel.font = UIFont(name: "OpenSans-semibold", size: 15)
        
        maleButton.setTitleColor(Global.colorGray, for: .normal)
        maleButton.setTitleColor(Global.colorMain, for: .highlighted)
        maleButton.addTarget(self, action: #selector(male), for: .touchUpInside)
        maleButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        maleButton.sizeToFit()
        maleButton.clipsToBounds = true
        maleButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        maleButton.contentHorizontalAlignment = .left
        maleButton.circleColor = Global.colorMain
        maleButton.circleRadius = 10
        maleButton.isSelected = true
        
        femaleButton.setTitleColor(Global.colorGray, for: .normal)
        femaleButton.setTitleColor(Global.colorMain, for: .highlighted)
        femaleButton.addTarget(self, action: #selector(female), for: .touchUpInside)
        femaleButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        femaleButton.sizeToFit()
        femaleButton.clipsToBounds = true
        femaleButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        femaleButton.contentHorizontalAlignment = .left
        femaleButton.circleColor = Global.colorMain
        femaleButton.circleRadius = 10
        
        radioButtonController = SSRadioButtonsController(buttons: maleButton, femaleButton)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.setTitleColor(Global.colorSelected, for: .highlighted)
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        signUpButton.layer.cornerRadius = 5
        signUpButton.clipsToBounds = true
        signUpButton.backgroundColor = Global.colorMain
        signUpButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        
        oldUserButton.setTitleColor(Global.colorGray, for: .normal)
        oldUserButton.setTitleColor(Global.colorMain, for: .highlighted)
        oldUserButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        oldUserButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        oldUserButton.sizeToFit()
        oldUserButton.clipsToBounds = true
        oldUserButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        oldUserButton.contentHorizontalAlignment = .center
        oldUserButton.isUserInteractionEnabled = false
        
        signInBtn.setTitleColor(Global.colorMain, for: .normal)
        signInBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        signInBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        signInBtn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInBtn.sizeToFit()
        signInBtn.contentHorizontalAlignment = .center
        
        let calendarIcon = FAKFontAwesome.calendarIcon(withSize: 30)
        calendarIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let calendarImg  = calendarIcon?.image(with: CGSize(width: 30, height: 30))
        calendarBtn.setImage(calendarImg, for: .normal)
        calendarBtn.tintColor = Global.colorMain
        calendarBtn.addTarget(self, action: #selector(calenderBtnClicked), for: .touchUpInside)
        calendarBtn.imageView?.contentMode = .scaleAspectFit
        
        containerView.addSubview(iconImgView)
        containerView.addSubview(facebookButton)
        containerView.addSubview(googleButton)
        containerView.addSubview(orLabel)
        containerView.addSubview(errorLabel)
        containerView.addSubview(displayNameField)
        containerView.addSubview(emailField)
        containerView.addSubview(passwordField)
        containerView.addSubview(confirmPasswordField)
        containerView.addSubview(dobField)
        containerView.addSubview(calendarBtn)
        containerView.addSubview(genderLabel)
        containerView.addSubview(maleButton)
        containerView.addSubview(femaleButton)
        containerView.addSubview(signUpButton)
        alreadyView.addSubview(oldUserButton)
        alreadyView.addSubview(signInBtn)
        containerView.addSubview(alreadyView)
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
        self.navigationItem.title = "sign_up".localized().uppercased()
        facebookButton.setTitle("Facebook", for: .normal)
        googleButton.setTitle("Google", for: .normal)
        orLabel.text = "or".localized().uppercased()
        displayNameField.placeholder = "display_name".localized()
        dobField.placeholder = "date_of_birth".localized()
        emailField.placeholder = "email".localized()
        passwordField.placeholder = "new_password".localized()
        confirmPasswordField.placeholder = "confirm_new_password".localized()
        signUpButton.setTitle("create_account".localized().uppercased(), for: .normal)
        oldUserButton.setTitle("already_have_an_account".localized(), for: .normal)
        signInBtn.setTitle("sign_in".localized(), for: .normal)
        genderLabel.text = "gender".localized().uppercased()
        maleButton.setTitle("male".localized(), for: .normal)
        femaleButton.setTitle("female".localized(), for: .normal)
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
            
            displayNameField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            displayNameField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            displayNameField.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 1)
            displayNameField.autoSetDimension(.height, toSize: 40)
            
            displayNameBorder.autoPinEdge(toSuperviewEdge: .left)
            displayNameBorder.autoPinEdge(toSuperviewEdge: .right)
            displayNameBorder.autoPinEdge(toSuperviewEdge: .bottom)
            displayNameBorder.autoSetDimension(.height, toSize: 1)
            
            emailField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            emailField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            emailField.autoPinEdge(.top, to: .bottom, of: displayNameBorder, withOffset: 10)
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
            
            confirmPasswordField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            confirmPasswordField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            confirmPasswordField.autoPinEdge(.top, to: .bottom, of: passwordField, withOffset: 10)
            confirmPasswordField.autoSetDimension(.height, toSize: 40)
            
            confirmPasswordBorder.autoPinEdge(toSuperviewEdge: .left)
            confirmPasswordBorder.autoPinEdge(toSuperviewEdge: .right)
            confirmPasswordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            confirmPasswordBorder.autoSetDimension(.height, toSize: 1)
            
            dobField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            dobField.autoPinEdge(.right, to: .left, of: calendarBtn, withOffset: -10)
            dobField.autoPinEdge(.top, to: .bottom, of: confirmPasswordField, withOffset: 10)
            dobField.autoSetDimension(.height, toSize: 40)
            
            calendarBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            calendarBtn.autoPinEdge(.top, to: .bottom, of: confirmPasswordField, withOffset: 10)
            calendarBtn.autoSetDimension(.height, toSize: 40)
            calendarBtn.autoSetDimension(.width, toSize: 40)

            dobBorder.autoPinEdge(toSuperviewEdge: .left)
            dobBorder.autoPinEdge(toSuperviewEdge: .right)
            dobBorder.autoPinEdge(toSuperviewEdge: .bottom)
            dobBorder.autoSetDimension(.height, toSize: 1)
            
            genderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            genderLabel.autoPinEdge(.top, to: .bottom, of: dobField, withOffset: 20)
            genderLabel.autoSetDimension(.height, toSize: 20)
            
            maleButton.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            maleButton.autoPinEdge(.top, to: .bottom, of: genderLabel, withOffset: 10)
            maleButton.autoSetDimension(.height, toSize: 30)
            maleButton.autoSetDimension(.width, toSize: 100)
            
            femaleButton.autoPinEdge(.left, to: .right, of: maleButton, withOffset: 10)
            femaleButton.autoPinEdge(.top, to: .bottom, of: genderLabel, withOffset: 10)
            femaleButton.autoSetDimension(.height, toSize: 30)
            femaleButton.autoSetDimension(.width, toSize: 100)
            
            signUpButton.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            signUpButton.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            signUpButton.autoPinEdge(.top, to: .bottom, of: maleButton, withOffset: 20)
            signUpButton.autoSetDimension(.height, toSize: 50)
            
            //---------------------------------------------------------------------------
            
            alreadyView.autoPinEdge(.top, to: .bottom, of: signUpButton, withOffset: 30)
            alreadyView.autoSetDimension(.height, toSize: 30)
            alreadyView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            signInBtn.autoPinEdge(toSuperviewEdge: .top)
            signInBtn.autoPinEdge(toSuperviewEdge: .right)
            signInBtn.autoPinEdge(.left, to: .right, of: oldUserButton, withOffset: 5)
            signInBtn.autoSetDimension(.height, toSize: 30)
            
            oldUserButton.autoPinEdge(toSuperviewEdge: .left)
            oldUserButton.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            oldUserButton.autoSetDimension(.height, toSize: 30)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 720
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = containerView.bounds.size
    }
    
    func loginFacebook() {
        socialLoginService.loginFacebook()
    }
    
    func loginGoogle() {
        socialLoginService.loginGoogle()
    }
    
    func male() {
        gender = 0
    }
    
    func female() {
        gender = 1
    }
    
    func signIn() {
        dismiss(animated: true, completion: nil)
    }
    
    func signUp() {
        if !checkInput(textField: displayNameField, value: displayNameField.text) {
            return
        }
        if !checkInput(textField: emailField, value: emailField.text) {
            return
        }
        if !checkInput(textField: passwordField, value: passwordField.text) {
            return
        }
        if !checkInput(textField: confirmPasswordField, value: confirmPasswordField.text) {
            return
        }
        if !checkInput(textField: dobField, value: dobField.text) {
            return
        }
        
        view.endEditing(true)
        
        let displayName = displayNameField.text!
        let dob = dobField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        let userResult = UserResult()
        userResult.DisplayName = displayName
        userResult.Email = email
        userResult.Password = password
        userResult.DOB = dob
        if maleButton.isSelected {
            userResult.Gender = 1
        }
        SwiftOverlays.showBlockingWaitOverlay()
        AccountService.signup(userResult: userResult) { (success, message) in
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
    
    
    var fromDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if fromDate != nil {
                dobField.text = dateFormatter.string(from: fromDate! as Date)
            } else {

            }
        }
    }
    
    func calenderBtnClicked() {
        displayNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()

        var date = NSDate()
        if(fromDate != nil) {
            date = fromDate!
        }
        
        var datePickerViewController : UIViewController!
        datePickerViewController = AIDatePickerController.picker(with: date as Date!, selectedBlock: {
            newDate in
            self.fromDate = newDate as NSDate?
            datePickerViewController.dismiss(animated: true, completion: nil)
        }, cancel: {
            datePickerViewController.dismiss(animated: true, completion: nil)
        }) as! UIViewController
        
        present(datePickerViewController, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case displayNameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                emailField.becomeFirstResponder()
                return true
            }
        case emailField:
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
                return true
            }
        }
        
        return false
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case displayNameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_display_name".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        case emailField:
            if value != nil && value!.isValidEmail() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_email_address".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case passwordField:
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_new_password".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case confirmPasswordField:
            if value != nil && passwordField.text != nil && value! == passwordField.text! {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "new_password_mismatch".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
            
        default:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_birth_date".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
    
    
    func actionTapToCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}
