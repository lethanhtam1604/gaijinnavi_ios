//
//  CompanyHeaderTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 6/7/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit

class CompanyHeaderTableViewCell: UITableViewCell {
    
    let companyImgView = AsyncImageView(frame: CGRect.zero)
    let companyIconImgView = AsyncImageView(frame: CGRect.zero)
    let companyNameLabel = UILabel()
    let companyAddressBtn = UIButton()
    let companyAddressLabel = UILabel()
    let companyPeopleBtn = UIButton()
    let companyPeopleLabel = UILabel()
    let companyCountryBtn = UIButton()
    let companyCountryLabel = UILabel()
    let companyBottomView = UIView()
    
    let companyOverviewLabel = UILabel()
    let companyDescriptionLabel = UILabel()
    let companyInfoBottomView = UIView()

    let companyJobTitleLabel = UILabel()
    
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

        companyBottomView.backgroundColor = Global.colorPage
        companyInfoBottomView.backgroundColor = Global.colorPage
        
        companyImgView.contentMode = .scaleAspectFill
        companyImgView.clipsToBounds = true
        companyImgView.backgroundColor = Global.colorBg
        
        companyIconImgView.contentMode = .scaleAspectFill
        companyIconImgView.clipsToBounds = true
        companyIconImgView.backgroundColor = Global.colorBg
        
        companyNameLabel.font = UIFont(name: "OpenSans-semibold", size: 16)
        companyNameLabel.textColor = Global.colorMain
        companyNameLabel.numberOfLines = 0
        companyNameLabel.lineBreakMode = .byTruncatingTail
        companyNameLabel.textAlignment = .left
        companyNameLabel.sizeToFit()
        
        let iosLocationOutlineIcon = FAKIonIcons.iosLocationOutlineIcon(withSize: 20)
        iosLocationOutlineIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let iosLocationOutlineImg = iosLocationOutlineIcon?.image(with: CGSize(width: 20, height: 20))
        companyAddressBtn.setImage(iosLocationOutlineImg, for: .normal)
        companyAddressBtn.tintColor = Global.colorGray
        companyAddressBtn.imageView?.contentMode = .scaleAspectFit
        
        companyAddressLabel.font = UIFont(name: "OpenSans", size: 15)
        companyAddressLabel.textColor = UIColor.darkGray
        companyAddressLabel.numberOfLines = 0
        companyAddressLabel.lineBreakMode = .byWordWrapping
        companyAddressLabel.textAlignment = .left
        
        let personStalkerIcon = FAKIonIcons.personStalkerIcon(withSize: 15)
        personStalkerIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let personStalkerImg = personStalkerIcon?.image(with: CGSize(width: 15, height: 15))
        companyPeopleBtn.setImage(personStalkerImg, for: .normal)
        companyPeopleBtn.tintColor = Global.colorGray
        companyPeopleBtn.imageView?.contentMode = .scaleAspectFit
        
        companyPeopleLabel.font = UIFont(name: "OpenSans", size: 15)
        companyPeopleLabel.textColor = UIColor.darkGray
        companyPeopleLabel.numberOfLines = 0
        companyPeopleLabel.lineBreakMode = .byWordWrapping
        companyPeopleLabel.textAlignment = .left
        
        let earthIcon = FAKIonIcons.earthIcon(withSize: 15)
        earthIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let earthImg = earthIcon?.image(with: CGSize(width: 15, height: 15))
        companyCountryBtn.setImage(earthImg, for: .normal)
        companyCountryBtn.tintColor = Global.colorGray
        companyCountryBtn.imageView?.contentMode = .scaleAspectFit
        
        companyCountryLabel.font = UIFont(name: "OpenSans", size: 15)
        companyCountryLabel.textColor = UIColor.darkGray
        companyCountryLabel.numberOfLines = 0
        companyCountryLabel.lineBreakMode = .byWordWrapping
        companyCountryLabel.textAlignment = .left
        
        //----------------------------------------------------------------------------
        
        companyOverviewLabel.font = UIFont(name: "OpenSans-semibold", size: 24)
        companyOverviewLabel.textColor = UIColor.darkGray
        companyOverviewLabel.numberOfLines = 0
        companyOverviewLabel.lineBreakMode = .byWordWrapping
        companyOverviewLabel.textAlignment = .left
        
        companyDescriptionLabel.font = UIFont(name: "OpenSans", size: 15)
        companyDescriptionLabel.textColor = UIColor.darkGray
        companyDescriptionLabel.numberOfLines = 0
        companyDescriptionLabel.lineBreakMode = .byWordWrapping
        companyDescriptionLabel.textAlignment = .left
        
        //----------------------------------------------------------------------------
                
        companyJobTitleLabel.font = UIFont(name: "OpenSans-semibold", size: 24)
        companyJobTitleLabel.textColor = UIColor.darkGray
        companyJobTitleLabel.numberOfLines = 0
        companyJobTitleLabel.lineBreakMode = .byWordWrapping
        companyJobTitleLabel.textAlignment = .left
        
        //----------------------------------------------------------------------------
        
        contentView.addSubview(companyImgView)
        contentView.addSubview(companyIconImgView)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(companyAddressLabel)
        contentView.addSubview(companyAddressBtn)
        contentView.addSubview(companyPeopleLabel)
        contentView.addSubview(companyPeopleBtn)
        contentView.addSubview(companyCountryLabel)
        contentView.addSubview(companyCountryBtn)
        contentView.addSubview(companyBottomView)

        contentView.addSubview(companyOverviewLabel)
        contentView.addSubview(companyDescriptionLabel)
        contentView.addSubview(companyInfoBottomView)

        contentView.addSubview(companyJobTitleLabel)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if !constraintAdded {
            constraintAdded = true

            companyImgView.autoPinEdge(toSuperviewEdge: .top)
            companyImgView.autoPinEdge(toSuperviewEdge: .left)
            companyImgView.autoPinEdge(toSuperviewEdge: .right)
            companyImgView.autoSetDimension(.height, toSize: 250)
            
            companyIconImgView.autoPinEdge(.top, to: .bottom, of: companyImgView, withOffset: 10)
            companyIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            companyIconImgView.autoSetDimension(.height, toSize: 80)
            companyIconImgView.autoSetDimension(.width, toSize: 80)
            
            companyNameLabel.autoPinEdge(.top, to: .top, of: companyIconImgView)
            companyNameLabel.autoPinEdge(.left, to: .right, of: companyIconImgView, withOffset: 10)
            companyNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyNameLabel.autoMatch(.height, to: .height, of: companyIconImgView)
            
            companyPeopleLabel.autoPinEdge(.top, to: .bottom, of: companyIconImgView, withOffset: 10)
            companyPeopleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyPeopleLabel.autoPinEdge(.left, to: .right, of: companyPeopleBtn, withOffset: 10)
            
            companyPeopleBtn.autoPinEdge(.top, to: .top, of: companyPeopleLabel)
            companyPeopleBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            companyPeopleBtn.autoSetDimension(.height, toSize: 20)
            companyPeopleBtn.autoSetDimension(.width, toSize: 20)
            
            companyCountryLabel.autoPinEdge(.top, to: .bottom, of: companyPeopleLabel, withOffset: 10)
            companyCountryLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyCountryLabel.autoPinEdge(.left, to: .right, of: companyCountryBtn, withOffset: 10)
            
            companyCountryBtn.autoPinEdge(.top, to: .top, of: companyCountryLabel)
            companyCountryBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            companyCountryBtn.autoSetDimension(.height, toSize: 20)
            companyCountryBtn.autoSetDimension(.width, toSize: 20)
            
            companyAddressLabel.autoPinEdge(.top, to: .bottom, of: companyCountryLabel, withOffset: 10)
            companyAddressLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyAddressLabel.autoPinEdge(.left, to: .right, of: companyAddressBtn, withOffset: 10)
            
            companyAddressBtn.autoPinEdge(.top, to: .top, of: companyAddressLabel)
            companyAddressBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            companyAddressBtn.autoSetDimension(.width, toSize: 20)
            companyAddressBtn.autoMatch(.height, to: .height, of: companyAddressLabel)
            
            companyBottomView.autoPinEdge(.top, to: .bottom, of: companyAddressLabel, withOffset: 10)
            companyBottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            companyBottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            companyBottomView.autoSetDimension(.height, toSize: 10)
            
            //--------------
            
            companyOverviewLabel.autoPinEdge(.top, to: .bottom, of: companyBottomView, withOffset: 10)
            companyOverviewLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyOverviewLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            companyDescriptionLabel.autoPinEdge(.top, to: .bottom, of: companyOverviewLabel, withOffset: 10)
            companyDescriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyDescriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            companyInfoBottomView.autoPinEdge(.top, to: .bottom, of: companyDescriptionLabel, withOffset: 10)
            companyInfoBottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            companyInfoBottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            companyInfoBottomView.autoSetDimension(.height, toSize: 10)
            
            //---------------
            
            companyJobTitleLabel.autoPinEdge(.top, to: .bottom, of: companyInfoBottomView, withOffset: 10)
            companyJobTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyJobTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        }
    }
    
    func bindingData(jobListResult: JobListResult) {
        DispatchQueue.main.async {
            self.companyImgView.imageURL = URL(string: jobListResult.CompanyData.BannerImage)
            self.companyIconImgView.imageURL = URL(string: jobListResult.CompanyData.Image)
            self.companyNameLabel.text = jobListResult.CompanyData.Name
            self.companyAddressLabel.text = jobListResult.LocationData.FullAddress
            self.companyPeopleLabel.text = String(jobListResult.CompanyData.Size)
            self.companyCountryLabel.text = "Viet nam"
            self.companyOverviewLabel.text = "overview".localized()
            
            let attrStr = try! NSAttributedString(
                data: jobListResult.CompanyData.DescriptionHtml.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.companyDescriptionLabel.attributedText = attrStr
            
            self.companyJobTitleLabel.text = "jobs".localized()
        }
    }
}
