//
//  ItemSchoolTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 5/25/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import SDWebImage

class ItemSchoolTableViewCell: UITableViewCell {
    
    let imgView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let bottomView = UIView()
    let nationBtn = UIButton()

    var constraintsAdded = false
    
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
        
        titleLabel.font = UIFont(name: "OpenSans-semibold", size: 16)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        imgView.tintColor = Global.colorMain
        imgView.contentMode = .scaleAspectFill
        
        descriptionLabel.font = UIFont(name: "OpenSans", size: 15)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        descriptionLabel.textAlignment = .left
        
        nationBtn.layer.cornerRadius = 5
        nationBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        nationBtn.backgroundColor = Global.colorTag
        nationBtn.setTitleColor(UIColor.white, for: .normal)
        nationBtn.setTitleColor(Global.colorGray, for: .highlighted)

        addSubview(titleLabel)
        addSubview(imgView)
        addSubview(descriptionLabel)
        addSubview(nationBtn)
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
            
            titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            
            imgView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 10)
            imgView.autoPinEdge(toSuperviewEdge: .right, withInset: photo + margin)
            imgView.autoPinEdge(toSuperviewEdge: .left, withInset: photo + margin)
            imgView.autoSetDimension(.height, toSize: 250)
            
            descriptionLabel.autoPinEdge(.top, to: .bottom, of: imgView, withOffset: 10)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            
            nationBtn.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: 10)
            nationBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            nationBtn.autoSetDimensions(to: CGSize(width: 100, height: 30))
            
            bottomView.autoPinEdge(.top, to: .bottom, of: nationBtn, withOffset: 10)
            bottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            bottomView.autoSetDimension(.height, toSize: 10)
        }
    }
    
    func bindingData(school: School) {
        
        imgView.sd_setImage(with: URL(string: school.schoolData.Image))
        
        titleLabel.text = school.schoolPost.Title
        descriptionLabel.text = school.schoolPost.ShortDescription
        nationBtn.setTitle(school.areaDatas[0].NameEn, for: .normal)
    }
}
