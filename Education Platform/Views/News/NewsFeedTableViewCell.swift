//
//  NewsFeedTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/6/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Kingfisher
import SDWebImage
import Localize_Swift

class NewsFeedTableViewCell: UITableViewCell {
    
    let authorIconBtn = UIButton()
    let authorNameLabel = UILabel()
    let timeLabel = UILabel()
    let titleLabel = UILabel()
    let photoImgView = UIImageView()
    let categoryTitleLabel = UILabel()
    let readMoreLabel = UILabel()
    let shortDescriptionLabel = UILabel()
    let bottomView = UIView()
    
    var constraintsAdded = false
    var imageHeightConstraint : NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        backgroundColor = UIColor.white        
        
        bottomView.backgroundColor = Global.colorPage
        
        authorIconBtn.layer.masksToBounds = true
        authorIconBtn.tintColor = Global.colorMain
        authorIconBtn.layer.cornerRadius = 20
        
        authorNameLabel.font = UIFont(name: "OpenSans-semibold", size: 12)
        authorNameLabel.lineBreakMode = .byWordWrapping
        authorNameLabel.numberOfLines = 0
        authorNameLabel.textColor = UIColor.black
        authorNameLabel.textAlignment = .left
        
        timeLabel.font = UIFont(name: "OpenSans", size: 11)
        timeLabel.lineBreakMode = .byWordWrapping
        timeLabel.numberOfLines = 0
        timeLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        timeLabel.textAlignment = .left
        
        categoryTitleLabel.font = UIFont(name: "OpenSans-semibold", size: 16)
        categoryTitleLabel.lineBreakMode = .byWordWrapping
        categoryTitleLabel.numberOfLines = 0
        categoryTitleLabel.textColor = Global.colorMain
        categoryTitleLabel.textAlignment = .left
        
        titleLabel.font = UIFont(name: "OpenSans-semibold", size: 15)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        
        photoImgView.clipsToBounds = true
        photoImgView.layer.masksToBounds = true
        photoImgView.tintColor = Global.colorMain
        photoImgView.contentMode = .scaleAspectFill
        photoImgView.backgroundColor = Global.colorPage
        
        shortDescriptionLabel.font = UIFont(name: "OpenSans", size: 15)
        shortDescriptionLabel.lineBreakMode = .byWordWrapping
        shortDescriptionLabel.numberOfLines = 0
        shortDescriptionLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        shortDescriptionLabel.textAlignment = .left
        
        readMoreLabel.font = UIFont(name: "OpenSans", size: 13)
        readMoreLabel.lineBreakMode = .byWordWrapping
        readMoreLabel.numberOfLines = 0
        readMoreLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        readMoreLabel.textAlignment = .left
        
        addSubview(authorIconBtn)
        addSubview(authorNameLabel)
        addSubview(timeLabel)
        addSubview(categoryTitleLabel)
        addSubview(titleLabel)
        addSubview(photoImgView)
        addSubview(shortDescriptionLabel)
        addSubview(readMoreLabel)
        addSubview(bottomView)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            var margin: CGFloat = 0
            var photo: CGFloat = 0
            
            if DeviceType.IS_IPAD {
                margin = 100
                photo = 10
            }
            
            authorIconBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            authorIconBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            authorIconBtn.autoSetDimensions(to: CGSize(width: 40, height: 40))
            
            authorNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            authorNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            authorNameLabel.autoPinEdge(.left, to: .right, of: authorIconBtn, withOffset: 10)
            
            timeLabel.autoPinEdge(.top, to: .bottom, of: authorNameLabel, withOffset: 5)
            timeLabel.autoPinEdge(.left, to: .left, of: authorNameLabel)
            timeLabel.autoPinEdge(.right, to: .right, of: authorNameLabel)
            
            categoryTitleLabel.autoPinEdge(.top, to: .bottom, of: timeLabel, withOffset: 20)
            categoryTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            categoryTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            
            titleLabel.autoPinEdge(.top, to: .bottom, of: categoryTitleLabel, withOffset: 5)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            
            photoImgView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 10)
            photoImgView.autoPinEdge(toSuperviewEdge: .right, withInset: photo + margin)
            photoImgView.autoPinEdge(toSuperviewEdge: .left, withInset: photo + margin)
            photoImgView.autoSetDimension(.height, toSize: 250)
            
            shortDescriptionLabel.autoPinEdge(.top, to: .bottom, of: photoImgView, withOffset: 10)
            shortDescriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            shortDescriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            
            readMoreLabel.autoPinEdge(.top, to: .bottom, of: shortDescriptionLabel, withOffset: 10)
            readMoreLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            readMoreLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            readMoreLabel.autoSetDimension(.height, toSize: 20)
            
            bottomView.autoPinEdge(toSuperviewEdge: .bottom)
            bottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            bottomView.autoSetDimension(.height, toSize: 10)
        }
    }
    
    func bindingData(news: News) {
        
        if news.author.Avatar != "" {
            authorIconBtn.sd_setImage(with: URL(string: news.author.Avatar), for: .normal)
        }
        else {
            authorIconBtn.setImage(UIImage(named: "ic_user"), for: .normal)
        }
        
        authorIconBtn.imageView?.contentMode = .scaleAspectFill
        authorIconBtn.imageView?.clipsToBounds = true

        shortDescriptionLabel.text = news.newsInterface.ShortDescription
        readMoreLabel.text = "read_more".localized()
        
        var bgURL = ""
        if news.photos.count > 0 {
            bgURL = news.photos[0].Url
        }
        
        photoImgView.sd_setImage(with: URL(string: bgURL))
        
        authorNameLabel.text = news.author.DisplayName
        titleLabel.text = news.newsInterface.Title
        categoryTitleLabel.text = news.category.Name
        
        if let date = Utils.stringtoDate(string: news.newsInterface.created_time) {
            timeLabel.text = NSDate().timeElapsed(date, local: Localize.currentLanguage())
        }
    }
}
