//
//  MapViewController.swift
//  mesh
//
//  Created by Victor Chien on 2/4/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var tabButton: UISegmentedControl!
    
    var locManager = CLLocationManager()
    var currentLocation = CLLocation()
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.requestAlwaysAuthorization()
        mapView.delegate = self
        locManager.delegate = self
        
        //to detect long press on map view
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.mapView.addGestureRecognizer(longPressRecognizer)

        mapView.showsUserLocation = true
        mapView.showsScale = true
        addAllAnnotations()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        self.addAllAnnotations()
    }
    
    //frees up map memory
    override func viewWillDisappear(_ animated: Bool) {
        mapView.showsUserLocation = false
        mapView.delegate = nil
        mapView.removeFromSuperview()
        mapView = nil
    }
    
    //sets the long and lat after location access is enabled
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    currentLocation = locManager.location!
                    currentLatitude = currentLocation.coordinate.latitude
                    currentLongitude = currentLocation.coordinate.longitude
                    zoomToRegion()
                }
            }
        }
    }
    
    func addAllAnnotations() {
        let coordinateList = SharingManager.sharedInstance.tagList
        for i in coordinateList {
            mapView.addAnnotation(i)
        }
    }
    
    func removeAllAnnotations() {
        let coordinateList = SharingManager.sharedInstance.tagList
        for i in coordinateList {
            mapView.removeAnnotation(i)
        }
    }
    
    func zoomToRegion() {
        if locManager.location != nil {
            let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let region = MKCoordinateRegionMakeWithDistance(location, 500.0, 700.0)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func recenter() {
        zoomToRegion()
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if tabButton.selectedSegmentIndex == 0{
        }
    }
    
    private func addTag(latitude: Double, longitude: Double) {
        //creates an popup - make into separate method later
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
            
            var resultTitle = ""
            var resultDescription = ""
            
            if let tempTitle = titleField.text {
                resultTitle = tempTitle
            }
            
            if let tempDescription = descriptionField.text {
                resultDescription = tempDescription
            }

            //makes sure title are not empty before adding tag
            if resultTitle != "" {
                //send the coordinate to other devices.
                SharingManager.sharedInstance.addTag(title: resultTitle, description: resultDescription, latitude: latitude, longitude: longitude)
                
                let tempResultTag = Tag(id: 0, title: resultTitle, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), info: resultDescription)
                self.mapView.addAnnotation(tempResultTag)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clear() {
        SharingManager.sharedInstance.meshDatabase.delete(toDelete: "tag")
        SharingManager.sharedInstance.tagList.removeAll()
    }
    
    //adds a pin where user long presses the map
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
            if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
                let location = longPressGestureRecognizer.location(in: mapView)
                let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
                addTag(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
    }
    
//    //updates user location when phone is moved
//    func mapView(_ mapView: MKMapView, didUpdate
//        userLocation: MKUserLocation) {
//        mapView.centerCoordinate = userLocation.location!.coordinate
//    }
    
    
    //used to customize annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Tag {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pin.pinTintColor = UIColor.red //store color and other properties in the tag object
            pin.animatesDrop = true
            pin.canShowCallout = true
            
            return pin
        }
        return nil
    }
    
    //functionality of button on annotation
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if let annotation = view.annotation as? Tag {
//            mapView.removeAnnotation(annotation)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
