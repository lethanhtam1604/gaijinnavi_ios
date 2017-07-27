//
//  HighlightedJobTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 6/7/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit

class HighlightedJobTableViewCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var logoJobButton = UIButton()
    var contentDueDateLabel = UILabel()
    var contentSalaryLabel = UILabel()
    var companyLabel = UILabel()
    var contentLocationLabel = UILabel()
    var dueDateBtn = UIButton()
    var salaryBtn = UIButton()
    var addressBtn = UIButton()
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
        
        bottomView.backgroundColor = Global.colorPage
        
        titleLabel.font = UIFont(name: "OpenSans-semibold", size: 16)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .left
        
        logoJobButton.layer.cornerRadius = 1
        logoJobButton.clipsToBounds = true
        logoJobButton.contentMode = .scaleAspectFill
        logoJobButton.imageView?.contentMode = .scaleAspectFit

        descriptionLabel.font = UIFont(name: "OpenSans", size: 15)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .left
        
        companyLabel.font = UIFont(name: "OpenSans-semibold", size: 15)
        companyLabel.textColor = Global.colorMain
        companyLabel.numberOfLines = 3
        companyLabel.lineBreakMode = .byTruncatingTail
        companyLabel.textAlignment = .left
        companyLabel.sizeToFit()
        
        contentDueDateLabel.font = UIFont(name: "OpenSans", size: 13)
        contentDueDateLabel.textColor = UIColor.darkGray
        contentDueDateLabel.numberOfLines = 0
        contentDueDateLabel.lineBreakMode = .byWordWrapping
        contentDueDateLabel.textAlignment = .left
        
        contentSalaryLabel.font = UIFont(name: "OpenSans", size: 13)
        contentSalaryLabel.textColor = Global.colorSalary
        contentSalaryLabel.numberOfLines = 0
        contentSalaryLabel.lineBreakMode = .byWordWrapping
        contentSalaryLabel.textAlignment = .left
        
        contentLocationLabel.font = UIFont(name: "OpenSans", size: 13)
        contentLocationLabel.textColor = UIColor.darkGray
        contentLocationLabel.numberOfLines = 0
        contentLocationLabel.lineBreakMode = .byWordWrapping
        contentLocationLabel.textAlignment = .left
        contentLocationLabel.isUserInteractionEnabled = true

        let iosClockOutlineIcon = FAKIonIcons.iosClockOutlineIcon(withSize: 15)
        iosClockOutlineIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let iosClockOutlineImg = iosClockOutlineIcon?.image(with: CGSize(width: 15, height: 15))
        dueDateBtn.setImage(iosClockOutlineImg, for: .normal)
        dueDateBtn.tintColor = Global.colorGray
        dueDateBtn.imageView?.contentMode = .scaleAspectFit
        
        let socialUsdIcon = FAKIonIcons.socialUsdIcon(withSize: 15)
        socialUsdIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorLightGreen)
        let socialUsdImg = socialUsdIcon?.image(with: CGSize(width: 15, height: 15))
        salaryBtn.setImage(socialUsdImg, for: .normal)
        salaryBtn.tintColor = Global.colorLightGreen
        salaryBtn.imageView?.contentMode = .scaleAspectFit
        
        let iosLocationOutlineIcon = FAKIonIcons.iosLocationOutlineIcon(withSize: 20)
        iosLocationOutlineIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let iosLocationOutlineImg = iosLocationOutlineIcon?.image(with: CGSize(width: 20, height: 20))
        addressBtn.setImage(iosLocationOutlineImg, for: .normal)
        addressBtn.tintColor = Global.colorGray
        addressBtn.imageView?.contentMode = .scaleAspectFit
        
        addSubview(descriptionLabel)
        addSubview(dueDateBtn)
        addSubview(salaryBtn)
        addSubview(addressBtn)
        addSubview(contentDueDateLabel)
        addSubview(contentSalaryLabel)
        addSubview(contentLocationLabel)
        addSubview(companyLabel)
        addSubview(logoJobButton)
        addSubview(titleLabel)
        addSubview(bottomView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if !constraintAdded {
            constraintAdded = true
            
            let margin: CGFloat = 0
            
            logoJobButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            logoJobButton.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            logoJobButton.autoSetDimension(.height, toSize: 60)
            logoJobButton.autoSetDimension(.width, toSize: 60)
            
            companyLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            companyLabel.autoMatch(.height, to: .height, of: logoJobButton)
            companyLabel.autoPinEdge(.left, to: .right, of: logoJobButton, withOffset: 10 + margin)
            companyLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            
            titleLabel.autoPinEdge(.top, to: .bottom, of: logoJobButton, withOffset: 10)
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            
            descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 10)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10 + margin)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10 + margin)
            
            dueDateBtn.autoPinEdge(.top, to: .top, of: contentDueDateLabel)
            dueDateBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            dueDateBtn.autoSetDimension(.width, toSize: 20)
            dueDateBtn.autoMatch(.height, to: .height, of: contentDueDateLabel)
            
            contentDueDateLabel.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: 10)
            contentDueDateLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            contentDueDateLabel.autoPinEdge(.left, to: .right, of: dueDateBtn, withOffset: 10)
            contentDueDateLabel.autoSetDimension(.height, toSize: 20)
            
            salaryBtn.autoPinEdge(.top, to: .top, of: contentSalaryLabel)
            salaryBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            salaryBtn.autoSetDimension(.width, toSize: 20)
            salaryBtn.autoMatch(.height, to: .height, of: contentSalaryLabel)
            
            contentSalaryLabel.autoPinEdge(.top, to: .bottom, of: contentDueDateLabel, withOffset: 10)
            contentSalaryLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            contentSalaryLabel.autoPinEdge(.left, to: .right, of: salaryBtn, withOffset: 10)
            contentSalaryLabel.autoSetDimension(.height, toSize: 20)
            
            addressBtn.autoPinEdge(.top, to: .top, of: contentLocationLabel)
            addressBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            addressBtn.autoSetDimension(.width, toSize: 20)
            addressBtn.autoMatch(.height, to: .height, of: contentLocationLabel)
            
            contentLocationLabel.autoPinEdge(.top, to: .bottom, of: contentSalaryLabel, withOffset: 10)
            contentLocationLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            contentLocationLabel.autoPinEdge(.left, to: .right, of: addressBtn, withOffset: 10)
            contentLocationLabel.autoSetDimension(.height, toSize: 40)
            
            bottomView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            bottomView.autoSetDimension(.height, toSize: 10)
        }
    }
    
    func bindingData(jobListResult: JobListResult) {
        DispatchQueue.main.async {
            
            self.logoJobButton.kf.setImage(with: URL(string: jobListResult.JobData.Image),for: .normal)
            self.titleLabel.text = jobListResult.PostData.Title
            self.descriptionLabel.text = jobListResult.PostData.ShortDescription
            
            self.companyLabel.text = jobListResult.CompanyData.Name
            
            let seeMap = "see_map".localized()
            let address = jobListResult.LocationData.FullAddress
            let wholeStr = "\(address) \(seeMap)"
            let attributedString = NSMutableAttributedString(string: wholeStr)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: (wholeStr as NSString).range(of: seeMap))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.colorLightGreen, range: (wholeStr as NSString).range(of: seeMap))
            self.contentLocationLabel.attributedText = attributedString
            
            self.contentDueDateLabel.text = jobListResult.JobData.DeadLine
            self.contentSalaryLabel.text = jobListResult.JobData.MinimumSalary
        }
    }
}
