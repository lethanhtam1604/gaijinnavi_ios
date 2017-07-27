//
//  ConfirmEmailViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 5/17/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift
import FontAwesomeKit

class ConfirmEmailViewController: UIViewController, AlertDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let closeBtn = UIButton()
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    
    let mailView = UIView()
    let mailField = UITextField()
    let mailAbstract = UIView()
    let mailImgView = UIImageView()
    let mailBorder = UIView()
    
    let resentEmailBtn = UIButton()
    let goToEmailBtn = UIButton()
    
    var constraintsAdded = false
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var mainViewDelegate: MainViewDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        self.view.backgroundColor = UIColor.white
        self.view.tintColor = Global.colorMain
        
        let closeCircledIcon = FAKIonIcons.closeCircledIcon(withSize: 30)
        closeCircledIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.black)
        let closeCircledImg  = closeCircledIcon?.image(with: CGSize(width: 40, height: 40))
        closeBtn.setImage(closeCircledImg, for: .normal)
        closeBtn.tintColor = UIColor.black
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeBtn.imageView?.contentMode = .scaleAspectFit
        closeBtn.isHidden = false
        
        titleLabel.text = "Let's take a second to confirm your email."
        titleLabel.font = UIFont(name: "OpenSans-light", size: 30)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0

        contentLabel.text = "To ensure you have full access to your account, click on the link in the email we sent you."
        contentLabel.font = UIFont(name: "OpenSans", size: 18)
        contentLabel.textAlignment = .center
        contentLabel.textColor = UIColor.black
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        
        mailImgView.clipsToBounds = true
        mailImgView.contentMode = .scaleAspectFit
        mailImgView.image = UIImage(named: "Mail")
        
        mailField.textAlignment = .center
        mailField.placeholder = "Email"
        mailField.textColor = UIColor.black
        mailField.returnKeyType = .done
        mailField.keyboardType = .emailAddress
        mailField.inputAccessoryView = UIView()
        mailField.autocorrectionType = .no
        mailField.autocapitalizationType = .none
        mailField.font = UIFont(name: "OpenSans", size: 17)
        mailBorder.backgroundColor = Global.colorSeparator
        mailAbstract.backgroundColor = UIColor.white
        mailView.bringSubview(toFront: mailAbstract)
        
        resentEmailBtn.setTitle("Resent email", for: .normal)
        resentEmailBtn.backgroundColor = UIColor.clear
        resentEmailBtn.setTitleColor(Global.colorMain, for: .normal)
        resentEmailBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        resentEmailBtn.addTarget(self, action: #selector(resentEmail), for: .touchUpInside)
        resentEmailBtn.layer.cornerRadius = 5
        resentEmailBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        resentEmailBtn.clipsToBounds = true
        
        goToEmailBtn.setTitle("Go to email", for: .normal)
        goToEmailBtn.backgroundColor = Global.colorMain
        goToEmailBtn.setTitleColor(UIColor.white, for: .normal)
        goToEmailBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        goToEmailBtn.addTarget(self, action: #selector(goToEmail), for: .touchUpInside)
        goToEmailBtn.layer.cornerRadius = 5
        goToEmailBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        goToEmailBtn.clipsToBounds = true
        
        mailAbstract.addSubview(mailImgView)
        mailView.addSubview(mailField)
        mailView.addSubview(mailBorder)
        mailView.addSubview(mailAbstract)
        
        containerView.addSubview(closeBtn)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(mailView)
        containerView.addSubview(resentEmailBtn)
        containerView.addSubview(goToEmailBtn)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        view.setNeedsUpdateConstraints()
        
        setLanguageRuntime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    var timer: Timer?
    
    func setLanguageRuntime() {
        titleLabel.text = "confirm_email_title".localized()
        contentLabel.text = "confirm_email_content".localized()
        resentEmailBtn.setTitle("resent_email".localized(), for: .normal)
        goToEmailBtn.setTitle("go_to_email".localized(), for: .normal)
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        AccountService.getUser() {
            newUser in
            if newUser != nil {
                
                self.mailField.text = newUser?.User.Email
               
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerStart), userInfo: nil, repeats: true)
                RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
            }
        }
    }
    
    func timerStart() {
        AccountService.checkAccountConfirmation() {
            result in
            if result == true {
                if self.timer != nil {
                    self.timer?.invalidate()
                    self.timer = nil
                }
                
                if self.mainViewDelegate != nil {
                    self.mainViewDelegate.confirmedEmail()
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            scrollView.autoPinEdgesToSuperviewEdges()
            
            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: view)
            
            let alpha: CGFloat = 40
            
            closeBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            closeBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 30)
            closeBtn.autoSetDimension(.width, toSize: 40)
            closeBtn.autoSetDimension(.height, toSize: 40)
            
            //---------------------------------------------------------------------------
            
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 40)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
            titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 100)
            
            //---------------------------------------------------------------------------
            
            contentLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
            contentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
            contentLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 30)
            
            
            //---------------------------------------------------------------------------
            
            mailView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            mailView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            mailView.autoPinEdge(.top, to: .bottom, of: contentLabel, withOffset: 30)
            mailView.autoSetDimension(.height, toSize: 40)
            
            mailField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            mailField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            mailField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            mailField.autoSetDimension(.height, toSize: 40)
            
            mailAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            mailAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            mailAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            mailAbstract.autoSetDimension(.width, toSize: 25)
            
            mailImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            mailImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            mailImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            mailBorder.autoPinEdge(toSuperviewEdge: .left)
            mailBorder.autoPinEdge(toSuperviewEdge: .right)
            mailBorder.autoPinEdge(toSuperviewEdge: .bottom)
            mailBorder.autoSetDimension(.height, toSize: 0.7)
            
            //---------------------------------------------------------------------------
        
            resentEmailBtn.autoAlignAxis(toSuperviewAxis: .vertical)
            resentEmailBtn.autoPinEdge(.top, to: .bottom, of: mailView, withOffset: 20)
            resentEmailBtn.autoSetDimension(.height, toSize: 40)
            
            //---------------------------------------------------------------------------
            
            goToEmailBtn.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            goToEmailBtn.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            goToEmailBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
            goToEmailBtn.autoSetDimension(.height, toSize: 50)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = Global.SCREEN_HEIGHT
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func resentEmail() {
        SwiftOverlays.showBlockingWaitOverlay()
        AccountService.resentEmail(email: self.mailField.text!) {
            result in
            if result == true {
                Utils.showAlertOpenEmail(title: "Gaijinnavi", message: "your_new_confirmation_has_been_sent_to_your_email".localized(), viewController: self, alertDelegate: self)
            }
            SwiftOverlays.removeAllBlockingOverlays()
        }
    }
    
    func okAlertActionClicked() {
        goToEmail()
    }
    
    func goToEmail() {
        let mailURL = NSURL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL as URL) {
            UIApplication.shared.openURL(mailURL as URL)
        }
    }
    
    func close() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.dismiss(animated: true, completion: nil)
    }
}
