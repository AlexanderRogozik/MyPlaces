//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Александр Рогозик on 5/25/19.
//  Copyright © 2019 Александр Рогозик. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var markerImgeView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    let mapManager = MapManager()
    var place = Place()
    var mapViewControllerDelegate : MapViewControllerDelegate?
    var previousLocation : CLLocation? {
        didSet{
            mapManager.startTrackingUserLocation(for: mapView, and: previousLocation) { (currentLocation) in
                self.previousLocation = currentLocation
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.mapManager.showUserLocation(mapView: self.mapView)
                })
            }
        }
    }
    
    var incomeSegueIndentifire = ""
    let anotationIndetifire = "anotationIndetifire"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = ""
        mapView.delegate = self
        setupMapView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func directionButtonPressed(_ sender: UIButton) {
        mapManager.getDirection(for: mapView) { (location) in
            self.previousLocation = location
        }
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func myLocationButtonPressed(_ sender: UIButton) {
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupMapView(){
        directionButton.isHidden = true
        mapManager.checkLocationServices(mapView: mapView, segueIdentifire: incomeSegueIndentifire) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeSegueIndentifire == "showPlace"{
            mapManager.setupPlaceMark(place: place, mapView: mapView)
            markerImgeView.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            directionButton.isHidden = false
            
        }
    }
    
    deinit {
        print("deinit", MapViewController.self)
    }
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard  !(annotation is MKUserLocation) else {
            return nil
        }
        var anotationView = mapView.dequeueReusableAnnotationView(withIdentifier: anotationIndetifire) as? MKPinAnnotationView
        
        if anotationView == nil {
            anotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: anotationIndetifire)
            anotationView?.canShowCallout = true
            anotationView?.pinTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            //anotationView?.image = #imageLiteral(resourceName: "camcel")
        }
        if let imageData = place.imageDataq {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            anotationView?.rightCalloutAccessoryView = imageView
        }
        
        return anotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapManager.getCenterLocation(for: mapView)
        
        let geocoder = CLGeocoder()
        
        if incomeSegueIndentifire == "showPlace" && previousLocation != nil{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: mapView)
            }
        }
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(center) { (placemark, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemark = placemark else {return}
            let placemarks = placemark.first
            let streetName = placemarks?.thoroughfare
            let buildNumber = placemarks?.subThoroughfare
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil {
                    self.addressLabel.text = "\(streetName!), \(buildNumber!)"
                }else if streetName != nil{
                    self.addressLabel.text = "\(streetName!)"
                }else{
                    self.addressLabel.text = ""
                }
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        render.lineWidth = 3
        return render
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapManager.checkLocationAuthorization(mapView: mapView, segueIdentifire: incomeSegueIndentifire)
        
    }
}
