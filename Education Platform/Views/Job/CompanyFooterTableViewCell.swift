//
//  CompanyFooterTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 6/7/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit

class CompanyFooterTableViewCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let companyWhyWorkHereTitleLabel = UILabel()
    let companyWhyWorkHereContentLabel = UILabel()
    let companyWhyWorkHereBottomView = UIView()
    
    let companyLocationTitleLabel = UILabel()
    let companyLocationLabel = UILabel()
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var anotation = MKPointAnnotation()
    let companyMapBottomView = UIView()
    
    var constraintAdded = false
    
    var jobListResult: JobListResult!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        companyWhyWorkHereBottomView.backgroundColor = Global.colorPage
        companyMapBottomView.backgroundColor = Global.colorPage
        
        companyWhyWorkHereTitleLabel.font = UIFont(name: "OpenSans-semibold", size: 24)
        companyWhyWorkHereTitleLabel.textColor = UIColor.darkGray
        companyWhyWorkHereTitleLabel.numberOfLines = 0
        companyWhyWorkHereTitleLabel.lineBreakMode = .byWordWrapping
        companyWhyWorkHereTitleLabel.textAlignment = .left
        
        companyWhyWorkHereContentLabel.font = UIFont(name: "OpenSans", size: 15)
        companyWhyWorkHereContentLabel.textColor = UIColor.darkGray
        companyWhyWorkHereContentLabel.numberOfLines = 0
        companyWhyWorkHereContentLabel.lineBreakMode = .byWordWrapping
        companyWhyWorkHereContentLabel.textAlignment = .left
        
        
        companyLocationTitleLabel.font = UIFont(name: "OpenSans-semibold", size: 24)
        companyLocationTitleLabel.textColor = UIColor.darkGray
        companyLocationTitleLabel.numberOfLines = 0
        companyLocationTitleLabel.lineBreakMode = .byWordWrapping
        companyLocationTitleLabel.textAlignment = .left
        
        companyLocationLabel.font = UIFont(name: "OpenSans", size: 15)
        companyLocationLabel.textColor = UIColor.darkGray
        companyLocationLabel.numberOfLines = 0
        companyLocationLabel.lineBreakMode = .byWordWrapping
        companyLocationLabel.textAlignment = .left
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.addAnnotation(anotation)
        mapView.backgroundColor = Global.colorBg
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        contentView.addSubview(companyWhyWorkHereTitleLabel)
        contentView.addSubview(companyWhyWorkHereContentLabel)
        contentView.addSubview(companyWhyWorkHereBottomView)
        
        contentView.addSubview(companyLocationTitleLabel)
        contentView.addSubview(companyLocationLabel)
        contentView.addSubview(mapView)
        contentView.addSubview(companyMapBottomView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if !constraintAdded {
            constraintAdded = true
            
            companyWhyWorkHereTitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            companyWhyWorkHereTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyWhyWorkHereTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            companyWhyWorkHereContentLabel.autoPinEdge(.top, to: .bottom, of: companyWhyWorkHereTitleLabel, withOffset: 10)
            companyWhyWorkHereContentLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyWhyWorkHereContentLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            companyWhyWorkHereBottomView.autoPinEdge(.top, to: .bottom, of: companyWhyWorkHereContentLabel, withOffset: 10)
            companyWhyWorkHereBottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            companyWhyWorkHereBottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            companyWhyWorkHereBottomView.autoSetDimension(.height, toSize: 10)
            
            //--------------------
            
            companyLocationTitleLabel.autoPinEdge(.top, to: .bottom, of: companyWhyWorkHereBottomView, withOffset: 10)
            companyLocationTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyLocationTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            companyLocationLabel.autoPinEdge(.top, to: .bottom, of: companyLocationTitleLabel, withOffset: 10)
            companyLocationLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            companyLocationLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            
            mapView.autoPinEdge(.top, to: .bottom, of: companyLocationLabel, withOffset: 10)
            mapView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            mapView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            mapView.autoSetDimension(.height, toSize: 300)
            
            companyMapBottomView.autoPinEdge(.top, to: .bottom, of: mapView, withOffset: 10)
            companyMapBottomView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            companyMapBottomView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            companyMapBottomView.autoSetDimension(.height, toSize: 10)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        DispatchQueue.main.async {
            var mapRegion = MKCoordinateRegion()
            let coordinate = CLLocationCoordinate2D(latitude: self.jobListResult.LocationData.Latitude, longitude: self.jobListResult.LocationData.Longtitude)
            self.anotation.coordinate = coordinate
            mapRegion.center = coordinate
            mapRegion.span.latitudeDelta = 0.002
            mapRegion.span.longitudeDelta = 0.002
            mapView.setRegion(mapRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func bindingData(jobListResult: JobListResult) {
        self.jobListResult = jobListResult
        DispatchQueue.main.async {
            self.companyWhyWorkHereTitleLabel.text = "why_you_love_working_here".localized()
            self.companyWhyWorkHereContentLabel.text = "若くて活発な社員\n社員が顧客に良い商品を想像の為に、広く快適な働く環境を作ります。\n\n快適な環境\n当社は新商品を作りための考究又は若くて活発な社員がいます。"
            
            self.companyLocationTitleLabel.text = "location".localized()
            self.companyLocationLabel.text = jobListResult.LocationData.FullAddress
        }
    }
}
