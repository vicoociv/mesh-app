//
//  Map2ViewController.swift
//  mesh
//
//  Created by Victor Chien on 7/31/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit
import GoogleMaps

class Map2ViewController: UIViewController {
    
    //must initialize in viewDidLoad or API key will not be called first
    internal var mapView: GMSMapView!
    internal var locationManager = CLLocationManager()
    internal var markerList: [GMSMarker] = []
    
    var navigationBar: NavigationBar = {
        let view = NavigationBar()
        view.barTitle.text = "Maps"
        view.backButton.isHidden = true
        view.refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return view
    }()
    
    @objc private func refresh() {
        clearAll()
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
        mapView = GMSMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        //moves myLocationButton above tab bar on bottom
        mapView.padding = UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0)
        
        view.addSubview(mapView)
        view.addSubview(navigationBar)
        setupView()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        updateMarkers()
    }
    
    internal func addTag(latitude: Double, longitude: Double) {
        let alert = UIAlertController(title: "New Tag", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        var titleField = UITextField()
        var descriptionField = UITextField()
        
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Title"
            titleField = titleTextField
        }
        
        alert.addTextField { (descriptionTextField) in
            descriptionTextField.placeholder = "Please insert description"
            descriptionField = descriptionTextField
        }
        
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
        }))
        
        alert.addAction(UIAlertAction(title: "add", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
            
            let resultTitle = titleField.text ?? "No Title"
            let resultDescription = descriptionField.text ?? "No Description"
            
            //makes sure title are not empty before adding tag
            if resultTitle != "" {
                //send the coordinate to other devices.
                SharingManager.sharedInstance.addTag(title: resultTitle, description: resultDescription, latitude: latitude, longitude: longitude)
                let tempResultTag = Tag(id: 0, title: resultTitle, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), info: resultDescription)
                self.createMarker(tempResultTag)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Creates a marker in the center of the map.
    internal func createMarker(_ tag: Tag) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: tag.getLatitude(), longitude: tag.getLongitude())
        marker.layer.cornerRadius = 12
        marker.opacity = 0.9
        marker.title = tag.getTitle()
        marker.snippet = tag.getDescription()
        marker.map = mapView
        markerList.append(marker)
    }
    
    internal func updateMarkers() {
        let coordinateList = SharingManager.sharedInstance.tagList
        for tag in coordinateList {
            createMarker(tag)
        }
    }
    
    internal func deleteMarker(marker: GMSMarker) {
        if let indexToDelete = markerList.index(of: marker) {
            let tagToDelete = SharingManager.sharedInstance.tagList[indexToDelete]
            SharingManager.sharedInstance.meshDatabase.deleteTag(tagToDelete: tagToDelete)
            SharingManager.sharedInstance.tagList.remove(at: indexToDelete)
            marker.map = nil
            markerList.remove(at: indexToDelete)
        }
    }
    
    internal func clearAll() {
        SharingManager.sharedInstance.meshDatabase.delete(toDelete: "tag")
        SharingManager.sharedInstance.tagList.removeAll()
        mapView.clear()
    }
}

extension Map2ViewController: GMSMapViewDelegate, CLLocationManagerDelegate {

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        addTag(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    //sets the long and lat after location access is enabled
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    locationManager.startUpdatingLocation()
                }
            }
        }
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

