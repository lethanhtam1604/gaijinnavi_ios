//
//  LocationHeaderTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 5/31/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit

class LocationHeaderTableViewCell: UITableViewCell {

    let topView = UIView()
    let titleLabel = UILabel()
    let bottomView = UIView()
    let abstractView = UIView()
    let arrowRightImgView = UIImageView()

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
        
        abstractView.touchHighlightingStyle = .lightBackground
        
        topView.backgroundColor = Global.colorPage
        bottomView.backgroundColor = Global.colorPage
        
        titleLabel.font = UIFont(name: "OpenSans-semibold", size: 16)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.gray
        titleLabel.textAlignment = .center
        
        arrowRightImgView.clipsToBounds = true
        arrowRightImgView.contentMode = .scaleAspectFit
        arrowRightImgView.image = UIImage(named: "ArrowRight")
        
        contentView.addSubview(topView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowRightImgView)
        contentView.addSubview(abstractView)
        contentView.addSubview(bottomView)

        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if !constraintsAdded {
            constraintsAdded = true
            
            topView.autoPinEdge(toSuperviewEdge: .top)
            topView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            topView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            topView.autoSetDimension(.height, toSize: 10)
            
            titleLabel.autoPinEdge(.top, to: .bottom, of: topView)
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            titleLabel.autoPinEdge(.bottom, to: .top, of: bottomView)
            titleLabel.autoPinEdge(.right, to: .left, of: arrowRightImgView, withOffset: 5)
            
            arrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            arrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            arrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

            bottomView.autoPinEdge(toSuperviewEdge: .bottom)
            bottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            bottomView.autoSetDimension(.height, toSize: 10)
            
            abstractView.autoPinEdge(.top, to: .bottom, of: topView)
            abstractView.autoPinEdge(toSuperviewEdge: .right)
            abstractView.autoPinEdge(toSuperviewEdge: .left)
            abstractView.autoPinEdge(.bottom, to: .top, of: bottomView)
        }
    }
    
    func bindingData(title: String) {
        titleLabel.text = title
    }
}
