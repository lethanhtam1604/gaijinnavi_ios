//
//  AboutGaijinnaviViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 2/17/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift

class AboutGaijinnaviViewController: UIViewController {
    
    var constraintsAdded = false
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton
        
        textView.isEditable = false

        var resourceURL: URL!
        let languageId = UserDefaultManager.getInstance().getCurrentLanguage()
        if languageId == 0 {
            resourceURL = Bundle.main.url(forResource: "About_en", withExtension: "rtf")!
        }
        else if languageId == 1 {
            resourceURL = Bundle.main.url(forResource: "About_ja", withExtension: "rtf")!
        }
        else if languageId == 2 {
            resourceURL = Bundle.main.url(forResource: "About_en", withExtension: "rtf")!
        }
        else {
            resourceURL = Bundle.main.url(forResource: "About_vi", withExtension: "rtf")!
        }
        
        try! textView.attributedText = NSAttributedString(url: resourceURL, options: [:], documentAttributes: nil)
        
        view.addSubview(textView)
        
        setLanguageRuntime()
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            textView.autoPinEdgesToSuperviewEdges()
        }
        super.updateViewConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        
        self.edgesForExtendedLayout = UIRectEdge.left
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setLanguageRuntime() {
        self.title = "about".localized().uppercased()
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
