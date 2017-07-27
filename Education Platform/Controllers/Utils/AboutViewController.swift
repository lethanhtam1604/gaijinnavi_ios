//
//  AboutViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/18/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift
import FontAwesomeKit

class AboutViewController: UIViewController {

    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let logoView = UIImageView(image: UIImage(named: "gaijin-greenery.png"))
    let versionLabel = UILabel()
    let aboutButton = UIButton()
    let termButton = UIButton()
    let privacyButton = UIButton()
    let seperatorFirstView = UIView()
    let seperatorSecondView = UIView()

    var constraintsAdded = false
    var user: RoleResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton
        
        logoView.contentMode = .scaleAspectFit
        
        versionLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        versionLabel.adjustsFontSizeToFitWidth = true
        versionLabel.textAlignment = .center
        versionLabel.textColor = Global.colorSelected
        
        seperatorFirstView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        seperatorSecondView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        let arrowIcon = FAKFontAwesome.angleRightIcon(withSize: 30)
        arrowIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSelected)
        let arrowImg  = arrowIcon?.image(with: CGSize(width: 30, height: 30))
        
        aboutButton.setImage(arrowImg, for: .normal)
        aboutButton.setTitleColor(Global.colorSelected, for: .normal)
        aboutButton.addTarget(self, action: #selector(showAbout), for: .touchUpInside)
        aboutButton.titleLabel?.textAlignment = .left
        aboutButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        aboutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        aboutButton.imageView?.contentMode = .right
        
        termButton.setImage(arrowImg, for: .normal)
        termButton.setTitleColor(Global.colorSelected, for: .normal)
        termButton.addTarget(self, action: #selector(showTerms), for: .touchUpInside)
        termButton.titleLabel?.textAlignment = .left
        termButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        termButton.titleLabel?.adjustsFontSizeToFitWidth = true
        termButton.imageView?.contentMode = .right
        
        privacyButton.setImage(arrowImg, for: .normal)
        privacyButton.setTitleColor(Global.colorSelected, for: .normal)
        privacyButton.addTarget(self, action: #selector(showPrivacy), for: .touchUpInside)
        privacyButton.titleLabel?.textAlignment = .left
        privacyButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        privacyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        privacyButton.imageView?.contentMode = .right
        
        view.addSubview(logoView)
        view.addSubview(versionLabel)
        view.addSubview(aboutButton)
        view.addSubview(seperatorFirstView)
        view.addSubview(termButton)
        view.addSubview(seperatorSecondView)
        view.addSubview(privacyButton)
        
        setLanguageRuntime()
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            let margin : CGFloat = 20
            
            privacyButton.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
            privacyButton.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
            privacyButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
            privacyButton.autoSetDimension(.height, toSize: 60)
            privacyButton.autoMatch(.width, to: .width, of: view, withOffset: -2 * margin)
            
            privacyButton.titleLabel?.autoPinEdge(toSuperviewEdge: .top)
            privacyButton.titleLabel?.autoPinEdge(toSuperviewEdge: .bottom)
            privacyButton.titleLabel?.autoPinEdge(toSuperviewEdge: .left)
            privacyButton.titleLabel?.autoPinEdge(toSuperviewEdge: .right, withInset: 60)
            
            privacyButton.imageView?.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            privacyButton.imageView?.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            privacyButton.imageView?.autoPinEdge(toSuperviewEdge: .bottom, withInset: 15)
            privacyButton.imageView?.autoSetDimension(.width, toSize: 30)
            privacyButton.imageView?.autoSetDimension(.height, toSize: 30)
            
            seperatorSecondView.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
            seperatorSecondView.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
            seperatorSecondView.autoPinEdge(.bottom, to: .top, of: privacyButton)
            seperatorSecondView.autoSetDimension(.height, toSize: 1)
            seperatorSecondView.autoMatch(.width, to: .width, of: view, withOffset: -2 * margin)
            
            termButton.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
            termButton.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
            termButton.autoPinEdge(.bottom, to: .top, of: seperatorSecondView)
            termButton.autoSetDimension(.height, toSize: 60)
            termButton.autoMatch(.width, to: .width, of: view, withOffset: -2 * margin)
            
            termButton.titleLabel?.autoPinEdge(toSuperviewEdge: .top)
            termButton.titleLabel?.autoPinEdge(toSuperviewEdge: .bottom)
            termButton.titleLabel?.autoPinEdge(toSuperviewEdge: .left)
            termButton.titleLabel?.autoPinEdge(toSuperviewEdge: .right, withInset: 60)
            
            termButton.imageView?.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            termButton.imageView?.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            termButton.imageView?.autoPinEdge(toSuperviewEdge: .bottom, withInset: 15)
            termButton.imageView?.autoSetDimension(.width, toSize: 30)
            termButton.imageView?.autoSetDimension(.height, toSize: 30)
            
            seperatorFirstView.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
            seperatorFirstView.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
            seperatorFirstView.autoPinEdge(.bottom, to: .top, of: termButton)
            seperatorFirstView.autoSetDimension(.height, toSize: 1)
            seperatorFirstView.autoMatch(.width, to: .width, of: view, withOffset: -2 * margin)
            
            aboutButton.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
            aboutButton.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
            aboutButton.autoPinEdge(.bottom, to: .top, of: seperatorFirstView)
            aboutButton.autoSetDimension(.height, toSize: 60)
            aboutButton.autoMatch(.width, to: .width, of: view, withOffset: -2 * margin)
            
            aboutButton.titleLabel?.autoPinEdge(toSuperviewEdge: .top)
            aboutButton.titleLabel?.autoPinEdge(toSuperviewEdge: .bottom)
            aboutButton.titleLabel?.autoPinEdge(toSuperviewEdge: .left)
            aboutButton.titleLabel?.autoPinEdge(toSuperviewEdge: .right, withInset: 60)
            
            aboutButton.imageView?.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            aboutButton.imageView?.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            aboutButton.imageView?.autoPinEdge(toSuperviewEdge: .bottom, withInset: 15)
            aboutButton.imageView?.autoSetDimension(.width, toSize: 30)
            aboutButton.imageView?.autoSetDimension(.height, toSize: 30)
            
            logoView.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            logoView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            logoView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            logoView.autoSetDimension(.height, toSize: 130)
            
            versionLabel.autoPinEdge(toSuperviewEdge: .left)
            versionLabel.autoPinEdge(toSuperviewEdge: .right)
            versionLabel.autoPinEdge(.top, to: .bottom, of: logoView)
            versionLabel.autoSetDimension(.height, toSize: 30)
            versionLabel.autoMatch(.width, to: .width, of: view)
        }
        super.updateViewConstraints()
    }
    
    func showAbout() {
        let viewController = AboutGaijinnaviViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showTerms() {
        let viewController = TermsViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showPrivacy() {
        let viewController = LicenseViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        
        self.edgesForExtendedLayout = UIRectEdge.left
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setLanguageRuntime(){
        title = "about".localized().uppercased()
        aboutButton.setTitle("about".localized(), for: .normal)
        termButton.setTitle("terms_and_conditions".localized(), for: .normal)
        privacyButton.setTitle("privacy_policy".localized(), for: .normal)
        versionLabel.text = "v1.2.1"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 540
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
