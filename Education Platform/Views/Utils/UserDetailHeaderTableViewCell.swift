//
//  UserDetailHeaderTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/30/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift
import Alamofire
import SwiftyJSON
import Kingfisher

class UserDetailHeaderTableViewCell: UITableViewCell, FollowServiceDelegate {
    
    @IBOutlet weak var userIconImgView: UIImageView!
    
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var followedBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var user: UserResult!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomView.backgroundColor = Global.colorPage
        
        userIconImgView.layer.cornerRadius = 50
        userIconImgView.clipsToBounds = true
        userIconImgView.contentMode = .scaleAspectFill

        followBtn.setTitleColor(UIColor.white, for: .normal)
        followBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        followBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        followBtn.titleLabel?.font = UIFont(name: (followBtn.titleLabel?.font.fontName)!, size: 12)
        followBtn.layer.cornerRadius = 2
        followBtn.clipsToBounds = true
        followBtn.backgroundColor = Global.colorFollow
        followBtn.addTarget(self, action: #selector(followBtnClicked), for: .touchUpInside)
        self.followBtn.setTitle("follow_btn".localized(), for: .normal)
        self.setImageForFollowBtn(type: false)

        addFriendBtn.setTitleColor(UIColor.white, for: .normal)
        addFriendBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        addFriendBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        addFriendBtn.titleLabel?.font = UIFont(name: (addFriendBtn.titleLabel?.font.fontName)!, size: 12)
        addFriendBtn.layer.cornerRadius = 2
        addFriendBtn.clipsToBounds = true
        addFriendBtn.backgroundColor = Global.colorFollow
        addFriendBtn.addTarget(self, action: #selector(addFriendBtnClicked), for: .touchUpInside)
        addFriendBtn.setTitle("add_friend".localized(), for: .normal)
        self.setImageForFriendBtn(type: 0)
        
        followingBtn.setTitleColor(UIColor.black, for: .normal)
        followingBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        followingBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            followingBtn.titleLabel?.font = UIFont(name: (followingBtn.titleLabel?.font.fontName)!, size: 12)
        }
        else {
            followingBtn.titleLabel?.font = UIFont(name: (followingBtn.titleLabel?.font.fontName)!, size: 14)
        }
        
        followingBtn.clipsToBounds = true
        followingBtn.backgroundColor = UIColor.white
        followingBtn.titleLabel?.lineBreakMode = .byWordWrapping
        followingBtn.titleLabel?.textAlignment = .center
        followingBtn.setTitle("0\n" + "following".localized(), for: .normal)
        
        followedBtn.setTitleColor(UIColor.black, for: .normal)
        followedBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        followedBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        followedBtn.titleLabel?.font = UIFont(name: (followedBtn.titleLabel?.font.fontName)!, size: 14)
        followedBtn.clipsToBounds = true
        followedBtn.backgroundColor = UIColor.white
        followedBtn.titleLabel?.lineBreakMode = .byWordWrapping
        followedBtn.titleLabel?.textAlignment = .center
        followedBtn.setTitle("0\n" + "follower".localized(), for: .normal)
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            followedBtn.titleLabel?.font = UIFont(name: (followedBtn.titleLabel?.font.fontName)!, size: 12)
            followingBtn.titleLabel?.font = UIFont(name: (followingBtn.titleLabel?.font.fontName)!, size: 12)
            userIconImgView.autoSetDimensions(to: CGSize(width: 80, height: 80))
            userIconImgView.layer.cornerRadius = 40
            followedBtn.autoSetDimension(.width, toSize: 100)
            followingBtn.autoSetDimension(.width, toSize: 100)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "UserDetailHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func loadData() {
        
        FollowService.getFollowingListOwner(followServiceDelegate: self)
        FollowService.getFollowingList(userId: user.Id, followServiceDelegate: self)
        FollowService.getFollowedList(userId: user.Id, followServiceDelegate: self)
        
        if user.Avatar != "" {
            userIconImgView.kf.setImage(with: URL(string: user.Avatar))
        }
        else {
            userIconImgView.image = UIImage(named: "ic_user")
        }
        
        let friendstatus = FriendServices.getInstance().checkUserStatus(UserId: Int64(user.Id))
        switch friendstatus {
        case 3:
            addFriendBtn.setTitle("friends".localized(), for: .normal)
            self.setImageForFriendBtn(type: 2)
            addFriendBtn.isEnabled = false
            break
        case 2:
            addFriendBtn.setTitle("response_to_friend_request".localized(), for: .normal)
            self.setImageForFriendBtn(type: 1)
            addFriendBtn.backgroundColor = UIColor.gray
            addFriendBtn.isEnabled = false
            break
        case 1:
            addFriendBtn.setTitle("waiting_for_accept".localized(), for: .normal)
            self.setImageForFriendBtn(type: 1)
            addFriendBtn.backgroundColor = UIColor.gray
            addFriendBtn.isEnabled = false
            break
        default:
            addFriendBtn.setTitle("add_friend".localized(), for: .normal)
            self.setImageForFriendBtn(type: 0)
            break
        }
        
        let currentUser = UserDefaultManager.getInstance().getCurrentUser()
        if currentUser?.User.Id == user.Id {
            addFriendBtn.isHidden = true
            followBtn.isHidden = true
        }
    }
    
    func getFollowingListOwnerFinished(success: Bool, message: String, result: [UserResult]) {
        if success {
            for item in result {
                if user.Id == item.Id {
                    self.followBtn.setTitle("followed_btn".localized(), for: .normal)
                    self.setImageForFollowBtn(type: true)
                    break
                }
            }
        }
    }
    
    func getFollowingListFinished(success: Bool, message: String, result: [UserResult]) {
        if success {
            self.followingBtn.setTitle(String(result.count) + "\n" + "following".localized(), for: .normal)
        }
    }
    
    func getFollowedListFinished(success: Bool, message: String, result: [UserResult]) {
        if success {
            self.followedBtn.setTitle(String(result.count) + "\n" + "follower".localized(), for: .normal)
        }
    }
    
    func setImageForFollowBtn(type: Bool) {
        
        if !type {
            let iosPlusEmptyIcon = FAKIonIcons.iosPlusEmptyIcon(withSize: 25)
            iosPlusEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            followBtn.setImage(iosPlusEmptyIcon?.image(with: CGSize(width: 25, height: 25)), for: .normal)
            iosPlusEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
            followBtn.setImage(iosPlusEmptyIcon?.image(with: CGSize(width: 25, height: 25)), for: .highlighted)
        }
        else {
            let iosCheckmarkEmptyIcon = FAKIonIcons.iosCheckmarkEmptyIcon(withSize: 25)
            iosCheckmarkEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            self.followBtn.setImage(iosCheckmarkEmptyIcon?.image(with: CGSize(width: 25, height: 25)), for: .normal)
            iosCheckmarkEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
            self.followBtn.setImage(iosCheckmarkEmptyIcon?.image(with: CGSize(width: 25, height: 25)), for: .highlighted)
        }
    }
    
    func setImageForFriendBtn(type: Int) {
        if type == 0{
            let iosPlusEmptyIcon = FAKIonIcons.iosPlusEmptyIcon(withSize: 26)
            iosPlusEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            addFriendBtn.setImage(iosPlusEmptyIcon?.image(with: CGSize(width: 25, height: 25)), for: .normal)
            iosPlusEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
            addFriendBtn.setImage(iosPlusEmptyIcon?.image(with: CGSize(width: 25, height: 25)), for: .highlighted)
        }
        else if type == 1 {
            let iosPersonaddIcon = FAKIonIcons.personAddIcon(withSize: 21)
            iosPersonaddIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            addFriendBtn.setImage(iosPersonaddIcon?.image(with: CGSize(width: 25, height: 25)), for: .normal)
            iosPersonaddIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
            addFriendBtn.setImage(iosPersonaddIcon?.image(with: CGSize(width: 25, height: 25)), for: .highlighted)
        } else {
            let iosPersonaddIcon = FAKIonIcons.personIcon(withSize: 21)
            iosPersonaddIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            addFriendBtn.setImage(iosPersonaddIcon?.image(with: CGSize(width: 25, height: 25)), for: .normal)
            iosPersonaddIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorSecond)
            addFriendBtn.setImage(iosPersonaddIcon?.image(with: CGSize(width: 25, height: 25)), for: .highlighted)
        }
        
    }
    
    func followBtnClicked() {
        SwiftOverlays.showBlockingWaitOverlay()
        if self.followBtn.titleLabel?.text == "follow_btn".localized() {
            FollowService.follow(userId: user.Id, followServiceDelegate: self)
            return
        }
        FollowService.unFollow(userId: user.Id, followServiceDelegate: self)
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
    
    func addFriendBtnClicked() {
        let message:JSON = ["Action": "ADD_FRIEND_REQUEST", "DestUserId": user.Id]
        WebSocketServices.shared.Write(message: message.rawString()!)
        addFriendBtn.setTitle("waiting_for_accept".localized(), for: .normal)
        addFriendBtn.backgroundColor = UIColor.gray
        addFriendBtn.isEnabled = false
        FriendServices.getInstance().getDataUser()
        self.setImageForFriendBtn(type: 1)
    }
}
