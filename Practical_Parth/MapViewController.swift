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
import UserNotifications

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet var mapView: MKMapView!
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0.0
    var geocoder: CLGeocoder = CLGeocoder()
    var address: String = ""
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        self.setUserLocation()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var anno = mapView.dequeueReusableAnnotationView(withIdentifier: "Anno")
        if anno == nil
        {
            anno = CustomAnnotationView.init(annotation: annotation, reuseIdentifier: "Anno") as CustomAnnotationView
            
            anno?.setSelected(true, animated: true)
            
        }
        (anno as! CustomAnnotationView).selectedLabel.text = address
        return anno;
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
                
                if #available(iOS 10.0, *) {
                    //iOS 10 or above version
                    let center = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent()
                    content.title = "You have travelled 50 meters"
                    content.body = "You have travelled 50 meters."
                    content.categoryIdentifier = "travell"
                    content.sound = UNNotificationSound.default()
                    
                    let request = UNNotificationRequest(identifier: String(describing: Date()), content: content, trigger: nil)
                    center.add(request)
                    
                    
                }
            }
            if traveledDistance < 1609 {
                let tdMeter = traveledDistance
                appDelegate.travelledDistance = tdMeter
                print(tdMeter)
            }
        }
        lastLocation = locations.last
        
        geocoder.reverseGeocodeLocation(lastLocation) { (placemarksArray, erroe) in
            
            if (placemarksArray?.count)! > 0 {
                
                let placemark = placemarksArray?.first
                let number = placemark!.subThoroughfare
                let bairro = placemark!.subLocality
                let street = placemark!.thoroughfare
                
                self.address = "\(street ?? ""), \(number ?? "") - \(bairro ?? "")"
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: self.lastLocation.coordinate.latitude, longitude: self.lastLocation.coordinate.longitude)
                self.mapView.addAnnotation(annotation)
            }

        }
        
    }
}
