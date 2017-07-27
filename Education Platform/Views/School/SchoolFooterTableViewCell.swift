//
//  SchoolFooterTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 6/6/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit

class SchoolFooterTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let abstractView = UIView()
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
        
        abstractView.touchHighlightingStyle = .lightBackground
        
        bottomView.backgroundColor = Global.colorPage
        
        titleLabel.font = UIFont(name: "OpenSans", size: 18)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Global.colorMain
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomView)
        contentView.addSubview(abstractView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            bottomView.autoPinEdge(toSuperviewEdge: .bottom)
            bottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            bottomView.autoSetDimension(.height, toSize: 10)
            
            titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            titleLabel.autoPinEdge(.bottom, to: .top, of: bottomView)
            
            abstractView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            abstractView.autoPinEdge(toSuperviewEdge: .right)
            abstractView.autoPinEdge(toSuperviewEdge: .left)
            abstractView.autoPinEdge(.bottom, to: .top, of: bottomView)
        }
    }
    
    func bindingData() {
        titleLabel.text = "see_all".localized()
    }
}
