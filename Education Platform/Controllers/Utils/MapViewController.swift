//
//  MapViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 3/3/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var anotation = MKPointAnnotation()
    var jobListResult: JobListResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "map".localized().uppercased()
        
        var portraitSize: CGSize!
        var landscapeSize: CGSize!

        if DeviceType.IS_IPAD {
            portraitSize = CGSize(width: Global.SCREEN_WIDTH - 200, height: Global.SCREEN_HEIGHT - 300)
            landscapeSize = CGSize(width: Global.SCREEN_HEIGHT - 300, height: Global.SCREEN_WIDTH - 200)
        }
        else {
            portraitSize = CGSize(width: Global.SCREEN_WIDTH - 50, height: Global.SCREEN_HEIGHT - 200)
            landscapeSize = CGSize(width: Global.SCREEN_HEIGHT - 200, height: Global.SCREEN_WIDTH - 100)
        }
        
        self.contentSizeInPopup = portraitSize
        self.landscapeContentSizeInPopup = landscapeSize
        
        self.view.addSubview(mapView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.addAnnotation(anotation)
        mapView.backgroundColor = Global.colorBg
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    var customLocation = false
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !customLocation {
            var mapRegion = MKCoordinateRegion()
            let coordinate = CLLocationCoordinate2D(latitude: jobListResult.LocationData.Latitude, longitude: jobListResult.LocationData.Longtitude)
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
}
