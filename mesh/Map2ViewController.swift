//
//  Map2ViewController.swift
//  mesh
//
//  Created by Victor Chien on 7/31/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit
import GoogleMaps

class Map2ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    //must initialize in viewDidLoad or API key will not be called first
    internal var mapView : GMSMapView!
    internal var locationManager = CLLocationManager()
    
    var navigationBar: NavigationBar = {
        let view = NavigationBar()
        view.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        return view
    }()
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //map initiation code
        mapView = GMSMapView()
        mapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mapView.isMyLocationEnabled = true
        
        view.addSubview(mapView)
        view.addSubview(navigationBar)
        setupView()

        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

