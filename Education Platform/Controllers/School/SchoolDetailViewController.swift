//
//  SchoolDetailViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 6/7/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import MessageUI

class SchoolDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var imgView = UIImageView()
    var overviewTitleLabel = UILabel()
    var descriptionLabel = UILabel()
    var descriptionBottomView = UIView()
    var serviceTitleLabel = UILabel()
    var serviceContentLabel = UILabel()
    var contactUsLabel = UILabel()
    var contactPersonLabel = UILabel()
    var contactPersonBtn = UIButton()
    var phoneNumberLabel = UILabel()
    var phoneNumberBtn = UIButton()
    var emailLabel = UILabel()
    var emailBtn = UIButton()
    var websiteLabel = UILabel()
    var websiteBtn = UIButton()
    var mapLabel = UILabel()
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var anotation = MKPointAnnotation()

    var bottomView = UIView()
    
    var constraintsAdded = false
    var schoolId: Int = 0
    var school: School!
    
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
        
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.backgroundColor = Global.colorBg
        
        overviewTitleLabel.text = "overview".localized()
        overviewTitleLabel.font = UIFont(name: "OpenSans-semibold", size: 24)
        overviewTitleLabel.textColor = Global.colorMain
        overviewTitleLabel.numberOfLines = 0
        overviewTitleLabel.lineBreakMode = .byWordWrapping
        overviewTitleLabel.textAlignment = .center
        
        descriptionLabel.font = UIFont(name: "OpenSans", size: 20)
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .left
        
        descriptionBottomView.backgroundColor = Global.colorPage
        
        serviceTitleLabel.text = "services".localized()
        serviceTitleLabel.font = UIFont(name: "OpenSans-semibold", size: 24)
        serviceTitleLabel.textColor = Global.colorMain
        serviceTitleLabel.numberOfLines = 0
        serviceTitleLabel.lineBreakMode = .byWordWrapping
        serviceTitleLabel.textAlignment = .center
        
        serviceContentLabel.font = UIFont(name: "OpenSans", size: 16)
        serviceContentLabel.textColor = UIColor.black
        serviceContentLabel.numberOfLines = 0
        serviceContentLabel.lineBreakMode = .byWordWrapping
        serviceContentLabel.textAlignment = .left
        
        contactUsLabel.text = "contact_us".localized()
        contactUsLabel.font = UIFont(name: "OpenSans-semibold", size: 24)
        contactUsLabel.textColor = Global.colorMain
        contactUsLabel.numberOfLines = 0
        contactUsLabel.lineBreakMode = .byWordWrapping
        contactUsLabel.textAlignment = .center
        
        contactPersonLabel.text = "contact_person".localized()
        contactPersonLabel.font = UIFont(name: "OpenSans", size: 16)
        contactPersonLabel.textColor = UIColor.black
        contactPersonLabel.numberOfLines = 0
        contactPersonLabel.lineBreakMode = .byWordWrapping
        contactPersonLabel.textAlignment = .left
        
        contactPersonBtn.setTitleColor(Global.colorTag, for: .normal)
        contactPersonBtn.setTitleColor(Global.colorGray, for: .highlighted)
        contactPersonBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        contactPersonBtn.addTarget(self, action: #selector(contactPerson), for: .touchUpInside)
        contactPersonBtn.contentHorizontalAlignment = .left
        contactPersonBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        
        phoneNumberLabel.text = "phone_number".localized()
        phoneNumberLabel.font = UIFont(name: "OpenSans", size: 16)
        phoneNumberLabel.textColor = UIColor.black
        phoneNumberLabel.numberOfLines = 0
        phoneNumberLabel.lineBreakMode = .byWordWrapping
        phoneNumberLabel.textAlignment = .left
        
        phoneNumberBtn.setTitleColor(Global.colorTag, for: .normal)
        phoneNumberBtn.setTitleColor(Global.colorGray, for: .highlighted)
        phoneNumberBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        phoneNumberBtn.addTarget(self, action: #selector(phoneNumber), for: .touchUpInside)
        phoneNumberBtn.contentHorizontalAlignment = .left
        phoneNumberBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        
        emailLabel.text = "Email"
        emailLabel.font = UIFont(name: "OpenSans", size: 16)
        emailLabel.textColor = UIColor.black
        emailLabel.numberOfLines = 0
        emailLabel.lineBreakMode = .byWordWrapping
        emailLabel.textAlignment = .left
        
        emailBtn.setTitleColor(Global.colorTag, for: .normal)
        emailBtn.setTitleColor(Global.colorGray, for: .highlighted)
        emailBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        emailBtn.addTarget(self, action: #selector(email), for: .touchUpInside)
        emailBtn.contentHorizontalAlignment = .left
        emailBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        
        websiteLabel.text = "Website"
        websiteLabel.font = UIFont(name: "OpenSans", size: 16)
        websiteLabel.textColor = UIColor.black
        websiteLabel.numberOfLines = 0
        websiteLabel.lineBreakMode = .byWordWrapping
        websiteLabel.textAlignment = .left
        
        websiteBtn.setTitleColor(Global.colorTag, for: .normal)
        websiteBtn.setTitleColor(Global.colorGray, for: .highlighted)
        websiteBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        websiteBtn.addTarget(self, action: #selector(website), for: .touchUpInside)
        websiteBtn.contentHorizontalAlignment = .left
        websiteBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        
        mapLabel.text = "map".localized()
        mapLabel.font = UIFont(name: "OpenSans-semibold", size: 24)
        mapLabel.textColor = Global.colorMain
        mapLabel.numberOfLines = 0
        mapLabel.lineBreakMode = .byWordWrapping
        mapLabel.textAlignment = .center
        
        bottomView.backgroundColor = Global.colorPage
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        indicator.startAnimating()
        
        containerView.addSubview(imgView)
        containerView.addSubview(overviewTitleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(descriptionBottomView)
        containerView.addSubview(serviceTitleLabel)
        containerView.addSubview(serviceContentLabel)
        containerView.addSubview(contactUsLabel)
        containerView.addSubview(contactPersonLabel)
        containerView.addSubview(contactPersonBtn)
        containerView.addSubview(phoneNumberLabel)
        containerView.addSubview(phoneNumberBtn)
        containerView.addSubview(emailLabel)
        containerView.addSubview(emailBtn)
        containerView.addSubview(websiteLabel)
        containerView.addSubview(websiteBtn)
        containerView.addSubview(mapLabel)
        containerView.addSubview(mapView)
        containerView.addSubview(bottomView)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    func loadData() {
        
        SchoolServices.getSchoolById(schoolId: schoolId) {
            (result, success, message) in
            
            if success == true {
                DispatchQueue.main.async {
                    self.imgView.imageURL = URL(string: (result?.schoolData.Image)!)
                    
                    let attrStr = try! NSMutableAttributedString(
                        data: (result?.schoolPost.DescriptionHtml.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                        options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                        documentAttributes: nil)
                    
                    
                    attrStr.enumerateAttribute(NSAttachmentAttributeName, in: NSMakeRange(0, attrStr.length), options: NSAttributedString.EnumerationOptions.init(rawValue: 0)) { (value, range, stop) -> Void in
                        if let attachement = value as? NSTextAttachment {
                            let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)
                            let screenSize: CGRect = UIScreen.main.bounds
                            if (image?.size.width)! > screenSize.width - 20 {
                                let newImage = image?.resizeImage(scale: (screenSize.width - 20)/(image?.size.width)!)
                                let newAttribut = NSTextAttachment()
                                newAttribut.image = newImage
                                attrStr.addAttribute(NSAttachmentAttributeName, value: newAttribut, range: range)
                            }
                        }
                    }
                    
                    self.descriptionLabel.attributedText = attrStr
                    
                    var service = ""
                    for i in 0..<(result?.services)!.count {
                        if i == (result?.services.count)! - 1 {
                            service += (result?.services[i].Name)!
                        }
                        else {
                            service += (result?.services[i].Name)! + "<br>"
                        }
                    }
                    
                    let attrStrService = try! NSAttributedString(
                        data: service.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                        options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                        documentAttributes: nil)
                    
                    self.serviceContentLabel.attributedText = attrStrService
                    self.contactPersonBtn.setTitle(result?.contactData.Name, for: .normal)
                    self.phoneNumberBtn.setTitle(result?.contactData.PhoneNumber, for: .normal)
                    self.emailBtn.setTitle(result?.contactData.Email, for: .normal)
                    self.websiteBtn.setTitle(result?.contactData.Website, for: .normal)
                    
                    self.indicator.stopAnimating()
                    self.school = result
                    self.customLocation = false
                    self.mapView.showsUserLocation = true
                    self.mapView.delegate = self
                    self.mapView.addAnnotation(self.anotation)
                    self.mapView.backgroundColor = Global.colorBg
                    self.locationManager.delegate = self
                    self.locationManager.requestWhenInUseAuthorization()
                    
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }
            }
            else {
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
            
            imgView.autoPinEdge(toSuperviewEdge: .top)
            imgView.autoPinEdge(toSuperviewEdge: .left)
            imgView.autoPinEdge(toSuperviewEdge: .right)
            imgView.autoSetDimension(.height, toSize: 250)
            
            overviewTitleLabel.autoPinEdge(.top, to: .bottom, of: imgView, withOffset: 20)
            overviewTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            overviewTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            descriptionLabel.autoPinEdge(.top, to: .bottom, of: overviewTitleLabel, withOffset: 10)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            descriptionBottomView.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: 10)
            descriptionBottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            descriptionBottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            descriptionBottomView.autoSetDimension(.height, toSize: 10)
            
            serviceTitleLabel.autoPinEdge(.top, to: .bottom, of: descriptionBottomView, withOffset: 10)
            serviceTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            serviceTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            serviceContentLabel.autoPinEdge(.top, to: .bottom, of: serviceTitleLabel, withOffset: 10)
            serviceContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            serviceContentLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            contactUsLabel.autoPinEdge(.top, to: .bottom, of: serviceContentLabel, withOffset: 10)
            contactUsLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            contactUsLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            contactPersonLabel.autoPinEdge(.top, to: .bottom, of: contactUsLabel, withOffset: 10)
            contactPersonLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            contactPersonLabel.autoSetDimension(.width, toSize: 100)
            contactPersonLabel.autoSetDimension(.height, toSize: 30)
            
            contactPersonBtn.autoPinEdge(.top, to: .bottom, of: contactUsLabel, withOffset: 10)
            contactPersonBtn.autoPinEdge(.left, to: .right, of: contactPersonLabel, withOffset: 10)
            contactPersonBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            contactPersonBtn.autoSetDimension(.height, toSize: 30)
            
            phoneNumberLabel.autoPinEdge(.top, to: .bottom, of: contactPersonLabel, withOffset: 10)
            phoneNumberLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            phoneNumberLabel.autoSetDimension(.width, toSize: 100)
            phoneNumberLabel.autoSetDimension(.height, toSize: 30)
            
            phoneNumberBtn.autoPinEdge(.top, to: .bottom, of: contactPersonBtn, withOffset: 10)
            phoneNumberBtn.autoPinEdge(.left, to: .right, of: phoneNumberLabel, withOffset: 10)
            phoneNumberBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            phoneNumberBtn.autoSetDimension(.height, toSize: 30)
            
            emailLabel.autoPinEdge(.top, to: .bottom, of: phoneNumberLabel, withOffset: 10)
            emailLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            emailLabel.autoSetDimension(.width, toSize: 100)
            emailLabel.autoSetDimension(.height, toSize: 30)
            
            emailBtn.autoPinEdge(.top, to: .bottom, of: phoneNumberBtn, withOffset: 10)
            emailBtn.autoPinEdge(.left, to: .right, of: emailLabel, withOffset: 10)
            emailBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            emailBtn.autoSetDimension(.height, toSize: 30)
            
            websiteLabel.autoPinEdge(.top, to: .bottom, of: emailLabel, withOffset: 10)
            websiteLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            websiteLabel.autoSetDimension(.width, toSize: 100)
            websiteLabel.autoSetDimension(.height, toSize: 30)
            
            websiteBtn.autoPinEdge(.top, to: .bottom, of: emailBtn, withOffset: 10)
            websiteBtn.autoPinEdge(.left, to: .right, of: websiteLabel, withOffset: 10)
            websiteBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            websiteBtn.autoSetDimension(.height, toSize: 30)
            
            mapLabel.autoPinEdge(.top, to: .bottom, of: websiteBtn, withOffset: 10)
            mapLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            mapLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            mapView.autoPinEdge(.top, to: .bottom, of: mapLabel, withOffset: 10)
            mapView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            mapView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            mapView.autoSetDimension(.height, toSize: 300)

            bottomView.autoPinEdge(.top, to: .bottom, of: mapView, withOffset: 10)
            bottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            bottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            bottomView.autoSetDimension(.height, toSize: 10)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        if school != nil {
            let rectOverview = NSString(string: "overview".localized()).boundingRect(with: CGSize(width: view.frame.width - 20, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 24)!], context: nil)
            
            let rectService = NSString(string: "services".localized()).boundingRect(with: CGSize(width: view.frame.width - 20, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 24)!], context: nil)
            
            let rectContactUs = NSString(string: "contact_us".localized()).boundingRect(with: CGSize(width: view.frame.width - 20, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 24)!], context: nil)

            
            let rectMap = NSString(string: "map".localized()).boundingRect(with: CGSize(width: view.frame.width - 20, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 24)!], context: nil)

            
            let descriptionHeight = (self.descriptionLabel.attributedText?.height(withConstrainedWidth: view.frame.width - 20))!
            
            let serviceContentHeight = (self.serviceContentLabel.attributedText?.height(withConstrainedWidth: view.frame.width - 20))!

            let height : CGFloat = 250 + rectOverview.height + descriptionHeight + rectService.height + serviceContentHeight + 90 + rectContactUs.height + rectMap.height + 40 + 30 * 4 + 20 + 300 + 10
            
            containerView.autoSetDimension(.height, toSize: height)
            scrollView.contentSize = CGSize(width: view.frame.width, height: height)
        }
    }
    
    var customLocation = true
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !customLocation {
            var mapRegion = MKCoordinateRegion()
            let coordinate = CLLocationCoordinate2D(latitude: school.locationData.Latitude, longitude: school.locationData.Longtitude)
            anotation.coordinate = coordinate
            mapRegion.center = coordinate
            mapRegion.span.latitudeDelta = 0.002
            mapRegion.span.longitudeDelta = 0.002
            mapView.setRegion(mapRegion, animated: true)
            customLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func contactPerson() {
        
    }
    
    func phoneNumber() {
        callNumber(phone: self.phoneNumberBtn.titleLabel?.text ?? "")
    }
    
    func email() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.emailBtn.titleLabel?.text ?? ""])
            mail.setSubject("")
            mail.setMessageBody("", isHTML: false)
            mail.navigationBar.isTranslucent = false
            mail.navigationBar.barTintColor = UIColor.red
            mail.navigationBar.tintColor = Global.colorMain
            self.present(mail, animated: true, completion: nil)
        } else {
            Utils.showAlert(title: "Error", message: "You are not logged in e-mail. Please check e-mail configuration and try again", viewController: self)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    func website() {
        let url = URL(string: "http://" + (self.websiteBtn.titleLabel?.text)!)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func callNumber(phone: String) {
        let components = phone.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "")
        
        let phone = "tel://" + decimalString
        let url:NSURL = NSURL(string:phone)!
        UIApplication.shared.openURL(url as URL)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
