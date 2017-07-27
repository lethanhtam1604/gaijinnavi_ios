//
//  JobCategoryTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 2/20/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit

class JobCategoryTableViewCell: UITableViewCell {
    
    let iconView = UIView()
    let iconImgView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let midView = UIView()
    let bottomView = UIView()

    var constraintAdded = false
    
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
        
        midView.backgroundColor = UIColor.clear
        bottomView.backgroundColor = Global.colorPage
        iconView.backgroundColor = Global.colorMain
        iconView.layer.cornerRadius = 25
        
        iconImgView.clipsToBounds = true
        iconImgView.layer.masksToBounds = true
        iconImgView.tintColor = UIColor.white
        iconImgView.contentMode = .scaleAspectFill
        
        titleLabel.font = UIFont(name: "OpenSans-semibold", size: 18)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Global.colorMain
        titleLabel.textAlignment = .left
        
        descriptionLabel.font = UIFont(name: "OpenSans", size: 14)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Global.colorMain
        descriptionLabel.textAlignment = .left
        
        iconView.addSubview(iconImgView)
        
        addSubview(midView)
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(bottomView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if !constraintAdded {
            constraintAdded = true
            
            iconView.autoSetDimensions(to: CGSize(width: 50, height: 50))
            iconView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            iconView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            iconImgView.autoSetDimensions(to: CGSize(width: 30, height: 30))
            iconImgView.autoAlignAxis(toSuperviewAxis: .vertical)
            iconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            midView.autoSetDimension(.height, toSize: 2)
            midView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            midView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            midView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            titleLabel.autoSetDimension(.height, toSize: 32)
            titleLabel.autoPinEdge(.left, to: .right, of: iconView, withOffset: 10)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            titleLabel.autoPinEdge(.bottom, to: .top, of: midView)
            
            descriptionLabel.autoSetDimension(.height, toSize: 22)
            descriptionLabel.autoPinEdge(.left, to: .right, of: iconView, withOffset: 10)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            descriptionLabel.autoPinEdge(.top, to: .bottom, of: midView)
            
            bottomView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 70)
            bottomView.autoSetDimension(.height, toSize: 1)
        }
    }
    
    func bindingData(jobTypeResult: JobTypeResult) {
        titleLabel.text = jobTypeResult.Name
        descriptionLabel.text = jobTypeResult.Description
        
        var iconImg: UIImage!
        
        if jobTypeResult.Icon == "home" {
            let homeIcon = FAKFontAwesome.homeIcon(withSize: 30)
            homeIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            iconImg = homeIcon?.image(with: CGSize(width: 30, height: 30))
        }
        else if jobTypeResult.Icon == "laptop"{
            let laptopIcon = FAKFontAwesome.laptopIcon(withSize: 30)
            laptopIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            iconImg = laptopIcon?.image(with: CGSize(width: 30, height: 30))
        }
        else if jobTypeResult.Icon == "office"{
            let buildingIcon = FAKFontAwesome.buildingIcon(withSize: 30)
            buildingIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            iconImg = buildingIcon?.image(with: CGSize(width: 30, height: 30))
        }
        else if jobTypeResult.Icon == "bookmark"{
            let bookmarkIcon = FAKFontAwesome.bookmarkIcon(withSize: 30)
            bookmarkIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            iconImg = bookmarkIcon?.image(with: CGSize(width: 30, height: 30))
        }
        else if jobTypeResult.Icon == "library"{
            iconImg = UIImage(named: "library")?.withRenderingMode(.alwaysTemplate)
        }
        else if jobTypeResult.Icon == "star-empty"{
            let starOIcon = FAKFontAwesome.starOIcon(withSize: 30)
            starOIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            iconImg = starOIcon?.image(with: CGSize(width: 30, height: 30))
        }
        else if jobTypeResult.Icon == "pacman"{
            iconImg = UIImage(named: "pacman")?.withRenderingMode(.alwaysTemplate)
        }
        else if jobTypeResult.Icon == "profile"{
            iconImg = UIImage(named: "profile")?.withRenderingMode(.alwaysTemplate)
        }
        else if jobTypeResult.Icon == "pencil"{
            let editIcon = FAKIonIcons.editIcon(withSize: 30)
            editIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            iconImg = editIcon?.image(with: CGSize(width: 30, height: 30))
        }
        
        if iconImg != nil {
            iconImgView.image = iconImg
        }
    }
}
