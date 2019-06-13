//
//  HospitalsViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 26/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class customPin: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubtitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubtitle
        self.coordinate = location
    }
    
}

class HospitalsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CMME"
        self.view.setGradientBackground()
        checkLocationServices()
        
        let destination1Location = CLLocationCoordinate2D(latitude: 40.570708, longitude: -3.925928)
        let destination2Location = CLLocationCoordinate2D(latitude: 40.450197, longitude: -3.873716)
        
        let destination1Pin = customPin(pinTitle: "HM TORRELODONES", pinSubtitle: "Hospital Universitario", location: destination1Location)
        let destination2Pin = customPin(pinTitle: "Puerta De Hierro", pinSubtitle: "Hospital Universitario", location: destination2Location)
        
        self.mapView.addAnnotations([destination1Pin,destination2Pin])
        
        let sourcePlaneMark = MKPlacemark(coordinate: (locationManager.location?.coordinate)!)
        let destination1PlaneMark = MKPlacemark(coordinate: destination1Location)
        let destination2PlaneMark = MKPlacemark(coordinate: destination2Location)
        
        let directionRequest1 = MKDirections.Request()
        directionRequest1.source = MKMapItem(placemark: sourcePlaneMark)
        directionRequest1.destination = MKMapItem(placemark: destination1PlaneMark)
        directionRequest1.transportType = .automobile
        
        let directionRequest2 = MKDirections.Request()
        directionRequest2.source = MKMapItem(placemark: sourcePlaneMark)
        directionRequest2.destination = MKMapItem(placemark: destination2PlaneMark)
        directionRequest2.transportType = .automobile
        
        let direction1 = MKDirections(request: directionRequest1)
        direction1.calculate { (response, error) in
            guard let directionResponse1 = response else {
                if error != nil {
                    let alert = UIAlertController(title: "ERROR", message: "We have error getting directions", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            let route = directionResponse1.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            //Set region of the route
            /*let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)*/
        }
        let direction2 = MKDirections(request: directionRequest2)
        direction2.calculate { (response, error) in
            guard let directionResponse2 = response else {
                if error != nil {
                    let alert = UIAlertController(title: "ERROR", message: "We have error getting directions", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            let route = directionResponse2.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            //Set region of the route
            /*let rect = route.polyline.boundingMapRect
             self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)*/
        }
        self.mapView.delegate = self
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            self.mapView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
}

extension HospitalsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.mapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
