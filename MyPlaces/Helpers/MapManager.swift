//
//  MapManager.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/27/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit
import MapKit

class MapManager {
    
    var locationManager = CLLocationManager()
    private let regionInMeters = 500.0
    private var placeCoordinate : CLLocationCoordinate2D?
    func setupPlaceMark(place: Place, mapView: MKMapView) {
        guard let location = place.location else {
            return
        }
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            let anotation = MKPointAnnotation()
            anotation.title = place.name
            anotation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else {return}
            
            anotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            mapView.showAnnotations([anotation], animated: true)
            mapView.selectAnnotation(anotation, animated: true)
        }
    }
    func checkLocationServices(mapView: MKMapView, segueIdentifire: String, closure: () -> ()){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            closure()
            checkLocationAuthorization(mapView: mapView, segueIdentifire: segueIdentifire)
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location services are Disabled", message: "To enable it go : Settings -> Privacy -> Location Services and turn on")
            }
            
            //show alert controller
        }
    }
    
    func checkLocationAuthorization(mapView: MKMapView, segueIdentifire: String){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if segueIdentifire == "getAddress"{
                showUserLocation(mapView: mapView)
            }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location services are Disabled", message: "To enable it go : Settings -> Privacy -> Location Services and turn on")
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location services are Disabled", message: "To enable it go : Settings -> Privacy -> Location Services and turn on")
            }
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is avilable")
        }
    }
    
    func showUserLocation(mapView: MKMapView){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getDirection(for mapView: MKMapView, previousLocation: (CLLocation) -> ()) {
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createRequestDirection(from: location) else {
            showAlert(title: "Error", message: "Destination not found")
            return
        }
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {
                self.showAlert(title: "Error", message: "Direction is not available")
                return
            }
            for route in response.routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                let distance = String(format: "%.1f" , route.distance / 1000)
                let timeInterval = String(format: "%.1f" , route.expectedTravelTime / 60)
                print("Расстояние до места \(distance) КМ")
                print("Время до места \(timeInterval)Ч")
            }
        }
        
    }

    
    func createRequestDirection(from coordinate : CLLocationCoordinate2D) -> MKDirections.Request? {
        guard  let destinationCoordinate = placeCoordinate else {
            return nil
        }
        let startLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        
        request.requestsAlternateRoutes = false
        return request
        
    }
    
    func startTrackingUserLocation(for mapView: MKMapView, and location: CLLocation?, closure: (_ currentLocation: CLLocation) -> ()) {
        guard let location = location else {
            return
        }
        
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: location) > 50 else {
            return
        }
        closure(center)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let lat = mapView.centerCoordinate.latitude
        let long = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: lat, longitude: long)
    }
    
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert,animated: true)
    }
    
    deinit {
        print("deinit", MapManager.self)
    }
}
