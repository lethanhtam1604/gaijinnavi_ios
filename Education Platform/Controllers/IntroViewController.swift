//
//  IntroViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/2/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import EAIntroView
import FontAwesomeKit

class IntroViewController: UIViewController, EAIntroDelegate {

    var introView: EAIntroView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showIntro()
    }
    
    func showIntro() {
        
        let page1 = EAIntroPage(customViewFromNibNamed: "IntroPageView")
        let introPage1 = page1?.customView as! IntroPageView
        introPage1.titleLabel.text = "what_is_swallow".localized()
        introPage1.subTitleLabel.text = "why_swallow".localized()
        page1?.bgColor = Global.colorMain
        
        let page2 = EAIntroPage(customViewFromNibNamed: "NewFeatureIntroView")
        let introPage2 = page2?.customView as! NewFeatureIntroView
        introPage2.featureImage.image = UIImage(named: "news")
        introPage2.featureLabel.text = "FEED_YOU_WITH_NEWS".localized()
        page2?.bgColor = Global.colorMain
        
        let page3 = EAIntroPage(customViewFromNibNamed: "NewFeatureIntroView")
        let introPage3 = page3?.customView as! NewFeatureIntroView
        introPage3.featureImage.image = UIImage(named: "school")
        introPage3.featureLabel.text = "FINDING_JAPANESE_SCHOOL".localized()
        page3?.bgColor = Global.colorMain
        
        let page4 = EAIntroPage(customViewFromNibNamed: "NewFeatureIntroView")
        let introPage4 = page4?.customView as! NewFeatureIntroView
        introPage4.featureImage.image = UIImage(named: "message")
        introPage4.featureLabel.text = "CHAT_WITH_FRIENDS_ABOARD".localized()
        page4?.bgColor = Global.colorMain
        
        let page5 = EAIntroPage(customViewFromNibNamed: "NewFeatureIntroView")
        let introPage5 = page5?.customView as! NewFeatureIntroView
        introPage5.featureImage.image = UIImage(named: "job")
        introPage5.featureLabel.text = "many_jobs_in_japan".localized().uppercased()
        page5?.bgColor = Global.colorMain
        
        let page6 = EAIntroPage(customViewFromNibNamed: "IntroPageView")
        let introPage6 = page6?.customView as! IntroPageView
        introPage6.titleLabel.text = "gaijinnavi".localized()
        introPage6.subTitleLabel.text = "CREATE TOMORROW TOGETHER"
        introPage6.getStartedBtn.isHidden = false
        introPage6.getStartedBtn.addTarget(self, action: #selector(getStartedClicked), for: .touchUpInside)
        page6?.bgColor = Global.colorMain
        
        let intro = EAIntroView(frame: self.view.bounds, andPages: [page1!, page2!, page3!, page4!, page5!, page6!])
        intro?.skipButton.isHidden = true
        intro?.delegate = self
        intro?.pageControlY = 40
        intro?.show(in: self.view, animateDuration: 0.3)
        intro?.swipeToExit = false
        introView = intro
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        getStartedClicked()
    }
    
    func getStartedClicked() {
        UserDefaultManager.getInstance().setIsInitApp(value: true)
        openSignIn()
    }
    
    func openSignIn() {
        let nav = UINavigationController(rootViewController: SignInViewController())
        self.present(nav, animated:true, completion:nil)
    }
    
}
