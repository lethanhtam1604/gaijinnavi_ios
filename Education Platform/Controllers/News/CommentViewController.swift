//
//  CommentViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/5/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Alamofire

protocol CommentDelegate {
    func post()
}

class CommentViewController: UIViewController {
    
    let contentTV = UITextView()
    
    var constraintsAdded = false
    
    var news: NewsInterface!
    var user: RoleResult!
    var commentDelegate: CommentDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = UserDefaultManager.getInstance().getCurrentUser()
        
        navigationController?.navigationBar.barTintColor = Global.colorMain
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        
        title = "comment".localized().uppercased()
        
        let cancelBarButton = UIBarButtonItem(title: "cancel".localized().uppercased(), style: .done, target: self, action: #selector(cancelClicked))
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        let doneBarBtnItem = UIBarButtonItem(title: "post".localized().uppercased(), style: .done, target: self, action: #selector(postClicked))
        doneBarBtnItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = doneBarBtnItem
        
        contentTV.keyboardType = .default
        contentTV.becomeFirstResponder()
        
        view.addSubview(contentTV)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            contentTV.autoAlignAxis(toSuperviewAxis: .vertical)
            contentTV.autoMatch(.width, to: .width, of: view)
            contentTV.autoPinEdge(toSuperviewMargin: .top)
            contentTV.autoPinEdge(toSuperviewMargin: .bottom)
        }
    }
    
    func postClicked() {
        SwiftOverlays.showBlockingWaitOverlay()
        CommentService.postComment(newId: news.Id, userId: user.User.Id, comment: contentTV.text) { (success, message) in
            if success == true {
                self.contentTV.resignFirstResponder()
                self.commentDelegate.post()
                self.dismiss(animated: true, completion: nil)
            }
            else {
                Utils.showAlert(title: "error".localized(), message:  message, viewController: self)
            }
            SwiftOverlays.removeAllBlockingOverlays()
        }
    }
    
    func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
