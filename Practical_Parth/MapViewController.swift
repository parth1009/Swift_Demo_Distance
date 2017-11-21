//
//  MapViewController.swift
//  Practical_Parth
//
//  Created by Parth Thakker on 21/11/17.
//  Copyright © 2017 Parth Thakker. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet var mapView: MKMapView!
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUserLocation()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    func setUserLocation()
    {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = 0
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways){
            
            if (locationManager.location != nil) {
                self.centerMapOnLocation(location: locationManager.location!)
            }
        }
       
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case .restricted:
            print("Restricted Access to location")
        case .denied:
            print("User denied access to location")
        case .notDetermined:
            print("Status not determined")
        default:
            shouldIAllow = true
        }
        
        if (shouldIAllow) {
            self.centerMapOnLocation(location: locationManager.location!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (startLocation == nil)
        {
            startLocation = locations.last
        }
        
        if lastLocation != nil {
            traveledDistance += lastLocation.distance(from: startLocation!)
            
            if (traveledDistance > 50) {
                
                startLocation = locations.last
                let dateFormatter = DateFormatter.init()
                dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
                
                appDelegate.managedObjectContext = appDelegate.getManagedObjectContext()
                let data: TblData = NSEntityDescription.insertNewObject(forEntityName: "TblData", into: appDelegate.managedObjectContext!) as! TblData
                data.recordDate = dateFormatter.string(from: Date())
                appDelegate.saveContext()
            }
            if traveledDistance < 1609 {
                let tdMeter = traveledDistance
                appDelegate.travelledDistance = tdMeter
                print(tdMeter)
            }
        }
        lastLocation = locations.last
        
    }
}
