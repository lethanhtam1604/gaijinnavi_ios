//
//  FollowTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/23/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

class FollowTableViewCell: UITableViewCell, FollowServiceDelegate {

    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var imgvUser: UIImageView!
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundCardView.layer.cornerRadius = 3.0
        self.backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.backgroundCardView.layer.shadowOffset = .init(width: 0.0, height: 0.0)
        self.backgroundCardView.layer.shadowOpacity = 0.3
        
        followBtn.setTitleColor(UIColor.white, for: .normal)
        followBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        followBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        followBtn.titleLabel?.font = UIFont(name: (followBtn.titleLabel?.font.fontName)!, size: 12)
        followBtn.layer.cornerRadius = 2
        followBtn.clipsToBounds = true
        followBtn.backgroundColor = Global.colorFollow
        followBtn.setTitle("follow_btn".localized(), for: .normal)
        followBtn.addTarget(self, action: #selector(followBtnClicked), for: .touchUpInside)
        setImageForFollowBtn(type: false)
        
        self.imgvUser.clipsToBounds = true
        self.imgvUser.layer.masksToBounds = true
        self.imgvUser.setCornerRadius(r: 30)
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            labelUser.font = UIFont(name: labelUser.font.fontName, size: 12)
            followBtn.titleLabel?.font = UIFont(name: (followBtn.titleLabel?.font.fontName)!, size: 10)
            imgvUser.autoSetDimensions(to: CGSize(width: 40, height: 40))
            imgvUser.layer.cornerRadius = 20
            followBtn.autoSetDimension(.width, toSize: 100)
            followBtn.autoSetDimension(.height, toSize: 25)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateui(){
        self.imgvUser.setCornerRadius(r: 30)
    }
    
    func setData(user : UserResult?, usersFollowingOwner: [UserResult]?){
        if user?.Avatar != "" {
            imgvUser.kf.setImage(with: URL(string: (user?.Avatar)!))
        }
        else {
            imgvUser.image = UIImage(named: "ic_user")
        }
        self.labelUser.text = user?.DisplayName
        self.followBtn.tag = (user?.Id)!

        let currentUser = UserDefaultManager.getInstance().getCurrentUser()
        if currentUser?.User.Id == user?.Id {
            followBtn.isHidden = true
        }
        else {
            followBtn.isHidden = false
            if usersFollowingOwner != nil {
                var isFollow = false
                for item in usersFollowingOwner! {
                    if item.Id == user?.Id {
                        self.followBtn.setTitle("followed_btn".localized(), for: .normal)
                        self.setImageForFollowBtn(type: true)
                        isFollow = true
                        break
                    }
                }
                
                if !isFollow {
                    self.followBtn.setTitle("follow_btn".localized(), for: .normal)
                    self.setImageForFollowBtn(type: false)
                }
            }
            else {
                self.followBtn.setTitle("followed_btn".localized(), for: .normal)
                self.setImageForFollowBtn(type: true)
            }
        }
    }
    
    func followBtnClicked() {
        
        SwiftOverlays.showBlockingWaitOverlay()
        if self.followBtn.titleLabel?.text == "follow_btn".localized() {
            FollowService.follow(userId: followBtn.tag, followServiceDelegate: self)
            return
        }
        FollowService.unFollow(userId: followBtn.tag, followServiceDelegate: self)
    }
    
    func getFollowingListOwnerFinished(success: Bool, message: String, result: [UserResult]) {
    
    }
    
    func getFollowingListFinished(success: Bool, message: String, result: [UserResult]) {
    
    }
    
    func getFollowedListFinished(success: Bool, message: String, result: [UserResult]) {

    }
    
    func followFinised(success: Bool, message: String) {
        SwiftOverlays.removeAllBlockingOverlays()
        if success {
            self.followBtn.setTitle("followed_btn".localized(), for: .normal)
            self.setImageForFollowBtn(type: true)
        }
    }
    
    func unFollowFinised(success: Bool, message: String) {
        SwiftOverlays.removeAllBlockingOverlays()
        if success {
            self.followBtn.setTitle("follow_btn".localized(), for: .normal)
            self.setImageForFollowBtn(type: false)
        }
    }
    
    func setImageForFollowBtn(type: Bool) {
        if !type {
            let iosPlusEmptyIcon = FAKIonIcons.iosPlusEmptyIcon(withSize: 25)
            iosPlusEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            followBtn.setImage(iosPlusEmptyIcon?.image(with: CGSize(width: 30, height: 30)), for: .normal)
            iosPlusEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
            followBtn.setImage(iosPlusEmptyIcon?.image(with: CGSize(width: 30, height: 30)), for: .highlighted)
        }
        else {
            let iosCheckmarkEmptyIcon = FAKIonIcons.iosCheckmarkEmptyIcon(withSize: 25)
            iosCheckmarkEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            self.followBtn.setImage(iosCheckmarkEmptyIcon?.image(with: CGSize(width: 30, height: 30)), for: .normal)
            iosCheckmarkEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
            self.followBtn.setImage(iosCheckmarkEmptyIcon?.image(with: CGSize(width: 30, height: 30)), for: .highlighted)
        }
    }
    
}
