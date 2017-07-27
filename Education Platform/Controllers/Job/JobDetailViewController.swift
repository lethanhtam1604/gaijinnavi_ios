//
//  JobDetailViewController.swift
//  Education Platform
//
//  Created by nquan on 2/23/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import STPopup
import MessageUI
import UnityAds
import FontAwesomeKit

class JobDetailViewController: UIViewController, MFMailComposeViewControllerDelegate, UnityAdsDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let companytitleLabel = UILabel()
    let companyIconBtn = UIButton()
    let companyNameLabel = UILabel()
    let companyAddressBtn = UIButton()
    let companyAddressLabel = UILabel()
    let companyPeopleBtn = UIButton()
    let companyPeopleLabel = UILabel()
    let companyCountryBtn = UIButton()
    let companyCountryLabel = UILabel()
    let companyOverviewLabel = UILabel()
    let companyDescriptionLabel = UILabel()
    let applyNowBtn = UIButton()
    let companyBottomView = UIView()
    
    let jobLabel = UILabel()
    let typeLabel = UILabel()
    let jobCategoryLabel = UILabel()
    let salaryLabel = UILabel()
    let contactLabel = UILabel()
    let applyFromLabel = UILabel()
    let postDateLabel = UILabel()
    let applicationDocumentLabel = UILabel()
    
    let typeContentLabel = UILabel()
    let jobCategoryContentLabel = UILabel()
    let salaryContentLabel = UILabel()
    let contactContentLabel = UILabel()
    let applyFromContentLabel = UILabel()
    let postDateContentLabel = UILabel()
    let applicationDocumentContentLabel = UILabel()
    let jobBottomView = UIView()
    
    let requirementLabel = UILabel()
    let requirementContentLabel = UILabel()
    let requirementBottomView = UIView()
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var constraintsAdded = false
    var jobListResult: JobListResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.tintColor = UIColor.white
        view.clipsToBounds = true
        view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton
        
        companyBottomView.backgroundColor = Global.colorPage
        jobBottomView.backgroundColor = Global.colorPage
        requirementBottomView.backgroundColor = Global.colorPage
        
        companytitleLabel.font = UIFont(name: "OpenSans-semibold", size: 18)
        companytitleLabel.textColor = Global.colorMain
        companytitleLabel.numberOfLines = 0
        companytitleLabel.lineBreakMode = .byWordWrapping
        companytitleLabel.textAlignment = .left
        
        companyIconBtn.layer.cornerRadius = 1
        companyIconBtn.clipsToBounds = true
        companyIconBtn.contentMode = .scaleAspectFill
        companyIconBtn.imageView?.contentMode = .scaleAspectFit
        companyIconBtn.addTarget(self, action: #selector(actionTapToCompanyIcon), for: .touchUpInside)
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToAddress))
        companyAddressLabel.isUserInteractionEnabled = true
        companyAddressLabel.addGestureRecognizer(tapGesture)
        
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
        
        companyOverviewLabel.font = UIFont(name: "OpenSans-semibold", size: 16)
        companyOverviewLabel.textColor = UIColor.darkGray
        companyOverviewLabel.numberOfLines = 0
        companyOverviewLabel.lineBreakMode = .byWordWrapping
        companyOverviewLabel.textAlignment = .left
        
        companyDescriptionLabel.font = UIFont(name: "OpenSans", size: 15)
        companyDescriptionLabel.textColor = UIColor.darkGray
        companyDescriptionLabel.numberOfLines = 0
        companyDescriptionLabel.lineBreakMode = .byWordWrapping
        companyDescriptionLabel.textAlignment = .left
        
        applyNowBtn.layer.cornerRadius = 5
        applyNowBtn.backgroundColor = UIColor.red
        applyNowBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        applyNowBtn.setTitle("apply_now".localized().uppercased(), for: .normal)
        applyNowBtn.setTitleColor(UIColor.white, for: .normal)
        applyNowBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        applyNowBtn.addTarget(self, action: #selector(actionTapToApplyJob), for: .touchUpInside)
        
        //----------------------------------------------------------------------------
        
        jobLabel.font = UIFont(name: "OpenSans-semibold", size: 18)
        jobLabel.textColor = Global.colorMain
        jobLabel.numberOfLines = 0
        jobLabel.lineBreakMode = .byWordWrapping
        jobLabel.textAlignment = .left
        
        typeLabel.font = UIFont(name: "OpenSans-semibold", size: 14)
        typeLabel.textColor = UIColor.darkGray
        typeLabel.numberOfLines = 0
        typeLabel.lineBreakMode = .byWordWrapping
        typeLabel.textAlignment = .right
        
        typeContentLabel.font = UIFont(name: "OpenSans", size: 13)
        typeContentLabel.textColor = UIColor.darkGray
        typeContentLabel.numberOfLines = 0
        typeContentLabel.lineBreakMode = .byWordWrapping
        typeContentLabel.textAlignment = .left
        
        jobCategoryLabel.font = UIFont(name: "OpenSans-semibold", size: 14)
        jobCategoryLabel.textColor = UIColor.darkGray
        jobCategoryLabel.numberOfLines = 0
        jobCategoryLabel.lineBreakMode = .byWordWrapping
        jobCategoryLabel.textAlignment = .right
        
        jobCategoryContentLabel.font = UIFont(name: "OpenSans", size: 13)
        jobCategoryContentLabel.textColor = UIColor.darkGray
        jobCategoryContentLabel.numberOfLines = 0
        jobCategoryContentLabel.lineBreakMode = .byWordWrapping
        jobCategoryContentLabel.textAlignment = .left
        
        salaryLabel.font = UIFont(name: "OpenSans-semibold", size: 14)
        salaryLabel.textColor = UIColor.darkGray
        salaryLabel.numberOfLines = 0
        salaryLabel.lineBreakMode = .byWordWrapping
        salaryLabel.textAlignment = .right
        
        salaryContentLabel.font = UIFont(name: "OpenSans", size: 13)
        salaryContentLabel.textColor = Global.colorSalary
        salaryContentLabel.numberOfLines = 0
        salaryContentLabel.lineBreakMode = .byWordWrapping
        salaryContentLabel.textAlignment = .left
        
        contactLabel.font = UIFont(name: "OpenSans-semibold", size: 14)
        contactLabel.textColor = UIColor.darkGray
        contactLabel.numberOfLines = 0
        contactLabel.lineBreakMode = .byWordWrapping
        contactLabel.textAlignment = .right
        
        contactContentLabel.font = UIFont(name: "OpenSans", size: 13)
        contactContentLabel.textColor = UIColor.darkGray
        contactContentLabel.numberOfLines = 0
        contactContentLabel.lineBreakMode = .byWordWrapping
        contactContentLabel.textAlignment = .left
        
        applyFromLabel.font = UIFont(name: "OpenSans-semibold", size: 14)
        applyFromLabel.textColor = UIColor.darkGray
        applyFromLabel.numberOfLines = 0
        applyFromLabel.lineBreakMode = .byWordWrapping
        applyFromLabel.textAlignment = .right
        
        applyFromContentLabel.font = UIFont(name: "OpenSans", size: 13)
        applyFromContentLabel.textColor = UIColor.darkGray
        applyFromContentLabel.numberOfLines = 0
        applyFromContentLabel.lineBreakMode = .byWordWrapping
        applyFromContentLabel.textAlignment = .left
        
        postDateLabel.font = UIFont(name: "OpenSans-semibold", size: 14)
        postDateLabel.textColor = UIColor.darkGray
        postDateLabel.numberOfLines = 0
        postDateLabel.lineBreakMode = .byWordWrapping
        postDateLabel.textAlignment = .right
        
        postDateContentLabel.font = UIFont(name: "OpenSans", size: 13)
        postDateContentLabel.textColor = UIColor.darkGray
        postDateContentLabel.numberOfLines = 0
        postDateContentLabel.lineBreakMode = .byWordWrapping
        postDateContentLabel.textAlignment = .left
        
        applicationDocumentLabel.font = UIFont(name: "OpenSans-semibold", size: 14)
        applicationDocumentLabel.textColor = UIColor.darkGray
        applicationDocumentLabel.numberOfLines = 0
        applicationDocumentLabel.lineBreakMode = .byWordWrapping
        applicationDocumentLabel.textAlignment = .right
        
        applicationDocumentContentLabel.font = UIFont(name: "OpenSans", size: 13)
        applicationDocumentContentLabel.textColor = UIColor.darkGray
        applicationDocumentContentLabel.numberOfLines = 0
        applicationDocumentContentLabel.lineBreakMode = .byWordWrapping
        applicationDocumentContentLabel.textAlignment = .left
        
        //----------------------------------------------------------------------------
        
        requirementLabel.font = UIFont(name: "OpenSans-semibold", size: 18)
        requirementLabel.textColor = Global.colorMain
        requirementLabel.numberOfLines = 0
        requirementLabel.lineBreakMode = .byWordWrapping
        requirementLabel.textAlignment = .left
        
        requirementContentLabel.font = UIFont(name: "OpenSans", size: 15)
        requirementContentLabel.textColor = Global.colorGray.withAlphaComponent(0.8)
        requirementContentLabel.numberOfLines = 0
        requirementContentLabel.lineBreakMode = .byWordWrapping
        requirementContentLabel.textAlignment = .left
        
        //----------------------------------------------------------------------------
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        indicator.startAnimating()
        
        containerView.addSubview(companytitleLabel)
        containerView.addSubview(companyIconBtn)
        containerView.addSubview(companyNameLabel)
        containerView.addSubview(companyAddressLabel)
        containerView.addSubview(companyAddressBtn)
        containerView.addSubview(companyPeopleLabel)
        containerView.addSubview(companyPeopleBtn)
        containerView.addSubview(companyCountryLabel)
        containerView.addSubview(companyCountryBtn)
        containerView.addSubview(companyOverviewLabel)
        containerView.addSubview(companyDescriptionLabel)
        containerView.addSubview(applyNowBtn)
        containerView.addSubview(companyBottomView)
        
        containerView.addSubview(jobLabel)
        containerView.addSubview(typeLabel)
        containerView.addSubview(typeContentLabel)
        containerView.addSubview(jobCategoryLabel)
        containerView.addSubview(jobCategoryContentLabel)
        containerView.addSubview(salaryLabel)
        containerView.addSubview(salaryContentLabel)
        containerView.addSubview(contactLabel)
        containerView.addSubview(contactContentLabel)
        containerView.addSubview(applyFromLabel)
        containerView.addSubview(applyFromContentLabel)
        containerView.addSubview(postDateLabel)
        containerView.addSubview(postDateContentLabel)
        containerView.addSubview(applicationDocumentLabel)
        containerView.addSubview(applicationDocumentContentLabel)
        containerView.addSubview(jobBottomView)
        
        containerView.addSubview(requirementLabel)
        containerView.addSubview(requirementContentLabel)
        containerView.addSubview(requirementBottomView)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    var isFinishLoadData = false
    
    func loadData() {
        DispatchQueue.main.async {
            self.companytitleLabel.text = "company".localized()
            self.companyIconBtn.sd_setImage(with: URL(string: self.jobListResult.CompanyData.Image), for: .normal)
            self.companyNameLabel.text = self.jobListResult.CompanyData.Name
            
            let seeMap = "see_map".localized()
            let address = self.jobListResult.LocationData.FullAddress
            let wholeStr = "\(address) \(seeMap)"
            let attributedString = NSMutableAttributedString(string: wholeStr)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: (wholeStr as NSString).range(of: seeMap))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.colorLightGreen, range: (wholeStr as NSString).range(of: seeMap))
            self.companyAddressLabel.attributedText = attributedString
            self.companyPeopleLabel.text = String(self.jobListResult.CompanyData.Size)
            self.companyCountryLabel.text = "Viet nam"
            self.companyOverviewLabel.text = "about".localized()
            
            let attrStr = try! NSAttributedString(
                data: self.jobListResult.CompanyData.DescriptionHtml.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.companyDescriptionLabel.attributedText = attrStr
            
            self.jobLabel.text = "job".localized()
            self.typeLabel.text = "type".localized() + " :"
            self.typeContentLabel.text = self.jobListResult.JobType.Name
            self.jobCategoryLabel.text = "job_category".localized() + " :"
            self.salaryLabel.text = "salary".localized() + " :"
            self.salaryContentLabel.text = self.jobListResult.JobData.MinimumSalary
            self.contactLabel.text = "contact".localized() + " :"
            self.contactContentLabel.text = self.jobListResult.contactData.Email
            self.applyFromLabel.text = "apply_from".localized() + " :"
            self.applyFromContentLabel.text = self.jobListResult.JobData.StartTime
            self.postDateLabel.text = "post_date".localized() + " :"
            self.postDateContentLabel.text = self.jobListResult.JobData.updated_time
            self.applicationDocumentLabel.text = "application_document".localized() + " :"
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attributes: [String : Any] = [NSParagraphStyleAttributeName: paragraph, NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            
            let attrStrDocument = try! NSAttributedString(
                data: self.jobListResult.JobData.Documents.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: attributes,
                documentAttributes: nil)
            
            self.applicationDocumentContentLabel.attributedText = attrStrDocument
            
            self.requirementLabel.text = "requirement".localized()
            
            let attrStrRequirement = try! NSAttributedString(
                data: self.jobListResult.JobData.JobRequest.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            
            self.requirementContentLabel.attributedText = attrStrRequirement
            
            JobServices.getMajorById(majorId: self.jobListResult.JobData.Major) { (result, success, message) in
                if success == true {
                    if let major = result {
                        self.jobListResult.major = major
                        self.jobCategoryContentLabel.text = major.Name
                    }
                }
                
                self.isFinishLoadData = true
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                self.indicator.stopAnimating()
            }
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: view)
            
            indicator.autoPinEdgesToSuperviewEdges()
            
            companytitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            companytitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            companytitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companytitleLabel.autoSetDimension(.height, toSize: 25)
            
            companyIconBtn.autoPinEdge(.top, to: .bottom, of: companytitleLabel, withOffset: 10)
            companyIconBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            companyIconBtn.autoSetDimension(.height, toSize: 80)
            companyIconBtn.autoSetDimension(.width, toSize: 80)
            
            companyNameLabel.autoPinEdge(.top, to: .top, of: companyIconBtn)
            companyNameLabel.autoPinEdge(.left, to: .right, of: companyIconBtn, withOffset: 10)
            companyNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyNameLabel.autoMatch(.height, to: .height, of: companyIconBtn)
            
            companyPeopleLabel.autoPinEdge(.top, to: .bottom, of: companyIconBtn, withOffset: 10)
            companyPeopleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyPeopleLabel.autoPinEdge(.left, to: .right, of: companyPeopleBtn, withOffset: 10)
            
            companyPeopleBtn.autoPinEdge(.top, to: .top, of: companyPeopleLabel)
            companyPeopleBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            companyPeopleBtn.autoSetDimension(.width, toSize: 20)
            companyPeopleBtn.autoMatch(.height, to: .height, of: companyPeopleLabel)
            
            companyCountryLabel.autoPinEdge(.top, to: .bottom, of: companyPeopleLabel, withOffset: 10)
            companyCountryLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyCountryLabel.autoPinEdge(.left, to: .right, of: companyCountryBtn, withOffset: 10)
            
            companyCountryBtn.autoPinEdge(.top, to: .top, of: companyCountryLabel)
            companyCountryBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            companyCountryBtn.autoSetDimension(.width, toSize: 20)
            companyCountryBtn.autoMatch(.height, to: .height, of: companyCountryLabel)
            
            companyAddressLabel.autoPinEdge(.top, to: .bottom, of: companyCountryLabel, withOffset: 10)
            companyAddressLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyAddressLabel.autoPinEdge(.left, to: .right, of: companyAddressBtn, withOffset: 10)
            
            companyAddressBtn.autoPinEdge(.top, to: .top, of: companyAddressLabel)
            companyAddressBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            companyAddressBtn.autoSetDimension(.width, toSize: 20)
            companyAddressBtn.autoMatch(.height, to: .height, of: companyAddressLabel)
            
            companyOverviewLabel.autoPinEdge(.top, to: .bottom, of: companyAddressLabel, withOffset: 10)
            companyOverviewLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyOverviewLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            companyDescriptionLabel.autoPinEdge(.top, to: .bottom, of: companyOverviewLabel, withOffset: 10)
            companyDescriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyDescriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            applyNowBtn.autoPinEdge(.top, to: .bottom, of: companyDescriptionLabel, withOffset: -10)
            applyNowBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            applyNowBtn.autoSetDimensions(to: CGSize(width: 160, height: 40))
            
            companyBottomView.autoPinEdge(.top, to: .bottom, of: applyNowBtn, withOffset: 10)
            companyBottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            companyBottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            companyBottomView.autoSetDimension(.height, toSize: 10)
            
            //------------------------------------------------
            
            jobLabel.autoPinEdge(.top, to: .bottom, of: companyBottomView, withOffset: 10)
            jobLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            jobLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            jobLabel.autoSetDimension(.height, toSize: 25)
            
            typeContentLabel.autoPinEdge(.top, to: .bottom, of: jobLabel, withOffset: 10)
            typeContentLabel.autoPinEdge(.left, to: .right, of: typeLabel, withOffset: 10)
            typeContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            
            typeLabel.autoPinEdge(.top, to: .top, of: typeContentLabel)
            typeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            typeLabel.autoSetDimension(.width, toSize: 100)
            typeLabel.autoMatch(.height, to: .height, of: typeContentLabel)
            
            jobCategoryContentLabel.autoPinEdge(.top, to: .bottom, of: typeContentLabel, withOffset: 10)
            jobCategoryContentLabel.autoPinEdge(.left, to: .right, of: jobCategoryLabel, withOffset: 10)
            jobCategoryContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            
            jobCategoryLabel.autoPinEdge(.top, to: .top, of: jobCategoryContentLabel)
            jobCategoryLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            jobCategoryLabel.autoSetDimension(.width, toSize: 100)
            jobCategoryLabel.autoMatch(.height, to: .height, of: jobCategoryContentLabel)
            
            salaryContentLabel.autoPinEdge(.top, to: .bottom, of: jobCategoryContentLabel, withOffset: 10)
            salaryContentLabel.autoPinEdge(.left, to: .right, of: salaryLabel, withOffset: 10)
            salaryContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            
            salaryLabel.autoPinEdge(.top, to: .top, of: salaryContentLabel)
            salaryLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            salaryLabel.autoSetDimension(.width, toSize: 100)
            salaryLabel.autoMatch(.height, to: .height, of: salaryContentLabel)
            
            contactContentLabel.autoPinEdge(.top, to: .bottom, of: salaryContentLabel, withOffset: 10)
            contactContentLabel.autoPinEdge(.left, to: .right, of: contactLabel, withOffset: 10)
            contactContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            
            contactLabel.autoPinEdge(.top, to: .top, of: contactContentLabel)
            contactLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            contactLabel.autoSetDimension(.width, toSize: 100)
            contactLabel.autoMatch(.height, to: .height, of: contactContentLabel)
            
            applyFromContentLabel.autoPinEdge(.top, to: .bottom, of: contactContentLabel, withOffset: 10)
            applyFromContentLabel.autoPinEdge(.left, to: .right, of: applyFromLabel, withOffset: 10)
            applyFromContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            
            applyFromLabel.autoPinEdge(.top, to: .top, of: applyFromContentLabel)
            applyFromLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            applyFromLabel.autoSetDimension(.width, toSize: 100)
            applyFromLabel.autoMatch(.height, to: .height, of: applyFromContentLabel)
            
            postDateContentLabel.autoPinEdge(.top, to: .bottom, of: applyFromContentLabel, withOffset: 10)
            postDateContentLabel.autoPinEdge(.left, to: .right, of: postDateLabel, withOffset: 10)
            postDateContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            
            postDateLabel.autoPinEdge(.top, to: .top, of: postDateContentLabel)
            postDateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            postDateLabel.autoSetDimension(.width, toSize: 100)
            postDateLabel.autoMatch(.height, to: .height, of: postDateContentLabel)
            
            applicationDocumentContentLabel.autoPinEdge(.top, to: .bottom, of: postDateContentLabel, withOffset: 10)
            applicationDocumentContentLabel.autoPinEdge(.left, to: .right, of: applicationDocumentLabel, withOffset: 10)
            applicationDocumentContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            
            applicationDocumentLabel.autoPinEdge(.top, to: .top, of: applicationDocumentContentLabel)
            applicationDocumentLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            applicationDocumentLabel.autoSetDimension(.width, toSize: 100)
            
            jobBottomView.autoPinEdge(.top, to: .bottom, of: applicationDocumentContentLabel, withOffset: 10)
            jobBottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            jobBottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            jobBottomView.autoSetDimension(.height, toSize: 10)
            
            //------------------------------------------------
            
            requirementLabel.autoPinEdge(.top, to: .bottom, of: jobBottomView, withOffset: 10)
            requirementLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            requirementLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            requirementLabel.autoSetDimension(.height, toSize: 25)
            
            requirementContentLabel.autoPinEdge(.top, to: .bottom, of: requirementLabel, withOffset: 10)
            requirementContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            requirementContentLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            requirementBottomView.autoPinEdge(.top, to: .bottom, of: requirementContentLabel, withOffset: 10)
            requirementBottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            requirementBottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            requirementBottomView.autoSetDimension(.height, toSize: 10)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        if isFinishLoadData {
            let rectPeople = NSString(string: String(self.jobListResult.CompanyData.Size)).boundingRect(with: CGSize(width: view.frame.width - 20, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!], context: nil)
            
            let rectCountry = NSString(string: "Viet nam").boundingRect(with: CGSize(width: view.frame.width - 20, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!], context: nil)
            
            let addressHeight = (self.companyAddressLabel.attributedText?.height(withConstrainedWidth: view.frame.width - 40))!
            
            let rectAbout = NSString(string: "about".localized()).boundingRect(with: CGSize(width: view.frame.width - 20, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 16)!], context: nil)
            
            let descriptionHeight = (self.companyDescriptionLabel.attributedText?.height(withConstrainedWidth: view.frame.width - 20))!
            
            let rectType = NSString(string: self.jobListResult.JobType.Name).boundingRect(with: CGSize(width: view.frame.width - (100 + 20), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!], context: nil)
            
            let rectCategory = NSString(string: self.jobCategoryContentLabel.text!).boundingRect(with: CGSize(width: view.frame.width - (100 + 20), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!], context: nil)

            let rectSalary = NSString(string: self.jobListResult.JobData.MinimumSalary).boundingRect(with: CGSize(width: view.frame.width - (100 + 20), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!], context: nil)

            let rectContact = NSString(string: self.jobListResult.contactData.Email).boundingRect(with: CGSize(width: view.frame.width - (100 + 20), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!], context: nil)

            let rectApplyFrom = NSString(string: self.jobListResult.JobData.StartTime).boundingRect(with: CGSize(width: view.frame.width - (100 + 20), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!], context: nil)

            let rectPostDate = NSString(string: self.jobListResult.JobData.updated_time).boundingRect(with: CGSize(width: view.frame.width - (100 + 20), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!], context: nil)

            let applicationDocumentContentHeight = (self.applicationDocumentContentLabel.attributedText?.height(withConstrainedWidth: view.frame.width - (100 + 20)))!

            let requirementHeight = (self.requirementContentLabel.attributedText?.height(withConstrainedWidth: view.frame.width - 20))!

            
            let height: CGFloat = 100 - 10 + 20 + 80 + rectPeople.height + rectCountry.height + addressHeight + rectAbout.height + descriptionHeight + 40 + 10 + 10 + 20 + 10 + rectType.height + 10 + rectCategory.height + 10 + rectSalary.height + 10 + rectContact.height + 10 + rectApplyFrom.height + 10 + rectPostDate.height + 10 + applicationDocumentContentHeight + 10 + 10 + 20 + 20 + requirementHeight + 10 + 10 + 10 + 15
            
            containerView.autoSetDimension(.height, toSize: height)
            scrollView.contentSize = CGSize(width: view.frame.width, height: height)
        }
    }
    
    func actionTapToCompanyIcon() {
        let viewController = CompanyViewController()
        viewController.jobListResult = jobListResult
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func actionTapToAddress() {
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        
        let viewController = MapViewController()
        viewController.jobListResult = jobListResult
        let viewControllerPopupController = STPopupController(rootViewController: viewController)
        viewControllerPopupController.containerView.layer.cornerRadius = 4
        viewControllerPopupController.present(in: self)
    }
    
    func actionTapToApplyJob() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["hr@citynow.jp"])
            mail.setSubject("".localized())
            mail.setMessageBody("".localized(), isHTML: false)
            mail.navigationBar.isTranslucent = false
            mail.navigationBar.barTintColor = UIColor.red
            mail.navigationBar.tintColor = Global.colorMain
            self.present(mail, animated: true, completion: nil)
        } else {
            Utils.showAlert(title: "error".localized(), message: "you_are_not_logged_in_e_mail_please_check_e_mail_configuration_and_try_again".localized(), viewController: self)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func unityAdsReady(_ placementId: String) {
        
    }
    
    func unityAdsDidStart(_ placementId: String) {
        
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        
    }
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
