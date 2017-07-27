//
//  AllUsersTableViewCell.swift
//  Education Platform
//
//  Created by nquan on 12/29/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import Kingfisher
import FontAwesomeKit

class AllUsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var requestSentLabel: UILabel!
    @IBOutlet weak var cancelRequestBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImage.kf.indicatorType = .activity
        self.userImage.clipsToBounds = true
        self.userNameLabel.sizeToFit()
        self.userNameLabel.numberOfLines = 0
        
        addFriendBtn.setTitleColor(UIColor.white, for: .normal)
        addFriendBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        addFriendBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        addFriendBtn.titleLabel?.font = UIFont(name: (addFriendBtn.titleLabel?.font.fontName)!, size: 12)
        addFriendBtn.layer.cornerRadius = 5
        addFriendBtn.clipsToBounds = true
        addFriendBtn.backgroundColor = Global.colorFollow
        addFriendBtn.setTitle("add_friend".localized(), for: .normal)
        self.setImageForFriendBtn(type: false)
        
        let iosPersonIcon = FAKIonIcons.iosPersonIcon(withSize: 25)
        iosPersonIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        cancelRequestBtn.setImage(iosPersonIcon?.image(with: CGSize(width: 25, height: 25)), for: .normal)
        iosPersonIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
        cancelRequestBtn.setImage(iosPersonIcon?.image(with: CGSize(width: 25, height: 25)), for: .highlighted)
        cancelRequestBtn.setTitleColor(UIColor.white, for: .normal)
        cancelRequestBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        cancelRequestBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        cancelRequestBtn.titleLabel?.font = UIFont(name: (cancelRequestBtn.titleLabel?.font.fontName)!, size: 12)
        cancelRequestBtn.layer.cornerRadius = 5
        cancelRequestBtn.clipsToBounds = true
        cancelRequestBtn.backgroundColor = Global.colorFollow
        cancelRequestBtn.setTitle("cancel".localized(), for: .normal)
        cancelRequestBtn.isHidden = true

        requestSentLabel.text = "request_sent".localized()
        requestSentLabel.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingDataForCell(user: ChatUserResult) {
        userNameLabel.text = user.DisplayName
        emailLabel.text = user.Email
        
        if Utils.verifyUrl(urlString: user.Avatar) {
            self.userImage.kf.setImage(with: URL(string: user.Avatar))
        }
        else {
            self.userImage.image = UIImage(named: "user_male.jpg")
        }
        
        if user.ConfirmFlag == 1 {
            requestSentLabel.isHidden = false
            //cancelRequestBtn.isHidden = false
            addFriendBtn.isHidden = true
        }
        else {
            requestSentLabel.isHidden = true
            //cancelRequestBtn.isHidden = true
            addFriendBtn.isHidden = false
        }
    }
    
    func setImageForFriendBtn(type: Bool) {
        if !type {
            let iosPlusEmptyIcon = FAKIonIcons.iosPlusEmptyIcon(withSize: 25)
            iosPlusEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            addFriendBtn.setImage(iosPlusEmptyIcon?.image(with: CGSize(width: 25, height: 25)), for: .normal)
            iosPlusEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
            addFriendBtn.setImage(iosPlusEmptyIcon?.image(with: CGSize(width: 25, height: 25)), for: .highlighted)
        }
        else {
            let iosPersonaddIcon = FAKIonIcons.iosPersonaddIcon(withSize: 25)
            iosPersonaddIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            addFriendBtn.setImage(iosPersonaddIcon?.image(with: CGSize(width: 25, height: 25)), for: .normal)
            iosPersonaddIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
            addFriendBtn.setImage(iosPersonaddIcon?.image(with: CGSize(width: 25, height: 25)), for: .highlighted)
        }
    }
}
