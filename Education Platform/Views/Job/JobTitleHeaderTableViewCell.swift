//
//  JobTitleHeaderTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 6/7/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit

class JobTitleHeaderTableViewCell: UITableViewCell {

    let topView = UIView()
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
                
        topView.backgroundColor = Global.colorPage
        bottomView.backgroundColor = Global.colorPage

        titleLabel.font = UIFont(name: "OpenSans", size: 18)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Global.colorMain
        titleLabel.textAlignment = .center
        
        contentView.addSubview(topView)
        contentView.addSubview(titleLabel)
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
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            titleLabel.autoPinEdge(.bottom, to: .top, of: bottomView)
            
            bottomView.autoPinEdge(toSuperviewEdge: .bottom)
            bottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            bottomView.autoSetDimension(.height, toSize: 10)
            
            abstractView.autoPinEdge(.top, to: .bottom, of: topView)
            abstractView.autoPinEdge(toSuperviewEdge: .right)
            abstractView.autoPinEdge(toSuperviewEdge: .left)
            abstractView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        }
    }
    
    func bindingData(title: String) {
        titleLabel.text = title
    }
}
