//
//  NewsFeedDetailTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/20/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift
import Alamofire
import SwiftyJSON
import Kingfisher
import STPopup
import SwiftyJSON

class NewsFeedDetailTableViewCell: UITableViewCell, CommentDelegate {
    
    let topView = UIView()
    let authorIconBtn = UIButton()
    let authorNameLabel = UILabel()
    let timeLabel = UILabel()
    let authorStatusLabel = UILabel()
    let followBtn = UIButton()
    
    let socialContainerView = UIView()
    let likeBtn = UIButton()
    let commentBtn = UIButton()
    let shareBtn = UIButton()
    let socialBorder = UIView()
    
    let newsImgView = AsyncImageView(frame: CGRect.zero)
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    var constraintsAdded = false
    
    var imageHeightConstraint : NSLayoutConstraint!
    var descHeightConstraint : NSLayoutConstraint!
    
    var news: News!
    var commentPopupController: STPopupController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        authorIconBtn.imageView?.contentMode = .scaleAspectFill
        authorIconBtn.layer.cornerRadius = 20
        authorIconBtn.clipsToBounds = true
        authorIconBtn.setImage(UIImage(named: "ic_user"), for: .normal)
        
        authorNameLabel.font = UIFont(name: "OpenSans", size: 13)
        authorNameLabel.textColor = Global.colorMain
        
        authorStatusLabel.font = UIFont(name: "OpenSans", size: 12)
        authorStatusLabel.textColor = Global.colorGray
        authorStatusLabel.numberOfLines = 0
        authorStatusLabel.lineBreakMode = .byWordWrapping
        authorStatusLabel.textAlignment = .left
        authorStatusLabel.isHidden = true
        
        timeLabel.font = UIFont(name: authorNameLabel.font.fontName, size: 12)
        timeLabel.textColor = Global.colorGray
        timeLabel.numberOfLines = 0
        timeLabel.lineBreakMode = .byWordWrapping
        timeLabel.textAlignment = .left
        
        followBtn.setTitleColor(UIColor.white, for: .normal)
        followBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        followBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        followBtn.titleLabel?.font = UIFont(name: (followBtn.titleLabel?.font.fontName)!, size: 12)
        followBtn.layer.cornerRadius = 2
        followBtn.clipsToBounds = true
        followBtn.backgroundColor = Global.colorFollow
        followBtn.addTarget(self, action: #selector(followBtnClicked), for: .touchUpInside)
        self.setImageForFollowBtn(type: false)
        followBtn.setTitle("follow_btn".localized(), for: .normal)
        
        newsImgView.contentMode = .scaleAspectFill
        newsImgView.clipsToBounds = true
        newsImgView.layer.cornerRadius = 3
        newsImgView.backgroundColor = Global.colorBg
        
        titleLabel.font = UIFont(name: "OpenSans-semibold", size: 30)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .left
        
        descriptionLabel.font = UIFont(name: "OpenSans", size: 20)
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .left
        
        if #available(iOS 10.0, *) {
            descriptionLabel.adjustsFontForContentSizeCategory = true
        }
        descriptionLabel.adjustsFontSizeToFitWidth = true
        
        let heartOIcon = FAKIonIcons.androidFavoriteOutlineIcon(withSize: 25)
        heartOIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let heartOImg  = heartOIcon?.image(with: CGSize(width: 25, height: 25))
        likeBtn.setImage(heartOImg, for: .normal)
        likeBtn.tintColor = Global.colorMain
        likeBtn.imageView?.contentMode = .scaleAspectFit
        
        let iosChatbubbleOutlineIcon = FAKIonIcons.iosChatbubbleOutlineIcon(withSize: 30)
        iosChatbubbleOutlineIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let iosChatbubbleOutlineImg  = iosChatbubbleOutlineIcon?.image(with: CGSize(width: 30, height: 30))
        commentBtn.setImage(iosChatbubbleOutlineImg, for: .normal)
        commentBtn.tintColor = Global.colorMain
        commentBtn.imageView?.contentMode = .scaleAspectFit
        
        let iosUploadOutlineIcon = FAKIonIcons.iosUploadOutlineIcon(withSize: 25)
        iosUploadOutlineIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let iosUploadOutlineImg  = iosUploadOutlineIcon?.image(with: CGSize(width: 30, height: 30))
        shareBtn.setImage(iosUploadOutlineImg, for: .normal)
        shareBtn.tintColor = Global.colorMain
        shareBtn.imageView?.contentMode = .scaleAspectFit
        
        socialBorder.backgroundColor = Global.colorBg
        
        topView.addSubview(authorIconBtn)
        topView.addSubview(authorNameLabel)
        //        topView.addSubview(authorStatusLabel)
        topView.addSubview(timeLabel)
        topView.addSubview(followBtn)

        self.addSubview(topView)
        self.addSubview(titleLabel)
        self.addSubview(newsImgView)
        self.addSubview(descriptionLabel)
        
        //        socialContainerView.addSubview(likeBtn)
        socialContainerView.addSubview(commentBtn)
        socialContainerView.addSubview(shareBtn)
        socialContainerView.addSubview(socialBorder)
        
        topView.isHidden = true
        titleLabel.isHidden = true
        newsImgView.isHidden = true
        descriptionLabel.isHidden = true
        socialContainerView.isHidden = true

        self.addSubview(socialContainerView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeLabel.preferredMaxLayoutWidth = timeLabel.bounds.width
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.bounds.width
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
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "NewsFeedDetailTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func authorIconBtnClicked() {
        
    }
    
    func followBtnClicked() {
        
    }
    
    func likeBtnClicked() {
        
    }
    
    func commentBtnClicked() {
        
    }
    
    func shareBtnClicked() {
        
    }
    
    func post() {
        
    }
}
