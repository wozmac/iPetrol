//
//  ViewController.swift
//  iPetrol
//
//  Created by Tero Jankko on 1/15/17.
//  Copyright © 2017 Tero Jankko. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI


class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    static let mapRectangleHeightWidth = 2000.0
    static let driverLocationUpdateFrequencySec = 10.0
    private var currentAddress: String?
    
    fileprivate var locationManager: CLLocationManager?
    fileprivate var geocoder: CLGeocoder?
    fileprivate var placemark: CLPlacemark?
        
    
    private lazy var __once: () = {
        
        let adjustedRegion = self.mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, mapRectangleHeightWidth, mapRectangleHeightWidth))
        
        self.mapView.setRegion(adjustedRegion, animated: true)
        //var updateTimer = Timer.scheduledTimer(timeInterval: driverLocationUpdateFrequencySec, target: self, selector: #selector(MapViewController.showDrivers), userInfo: nil, repeats: true)
        //self.showDrivers()
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self as? CLLocationManagerDelegate
        self.mapView.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.geocoder = CLGeocoder()

        
    }

    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "userLocation"
        
        if annotation is MKUserLocation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            view.frame = CGRect(x: 0.0, y: 0.0, width:250.0, height: 88.0)
            view.layer.cornerRadius = 14.0
            view.backgroundColor = UIColor.clear
            
            let subview = UIView(frame: (CGRect(x: 0.0, y: 0.0, width:250.0, height: 44.0)))
            subview.layer.cornerRadius = 10.0
            subview.layer.borderColor = UIColor.black.cgColor
            subview.layer.borderWidth = 1.0
            subview.alpha = 0.8
            subview.backgroundColor = UIColor.blue
            subview.isHidden = true

            view.addSubview(subview)
            return view
        }
        else if let annotation = annotation as? StationAnnotation {
            var view: MKAnnotationView
            
            if let dequeuedView = self.mapView.dequeueReusableAnnotationView(withIdentifier: annotation.title!) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.title)
                view.backgroundColor = UIColor.clear
                view.image = UIImage(named: "lightning")
                
                let markerWidth = 40.0
                let markerHeight = 40.0
                let labelWidth = 150.0
                let labelHeight = 21.0
                
                let label = UILabel(frame: CGRect(x: -((labelWidth/2.0) - (markerWidth/2.0)), y: -labelHeight, width:labelWidth, height: labelHeight))  //y: (markerHeight/2.0) - (labelHeight/2.0)
                label.backgroundColor = UIColor.clear
                label.alpha = 0.9;
                label.adjustsFontSizeToFitWidth = true
                label.layer.borderColor = UIColor.black.cgColor
                label.layer.borderWidth = 1.0
                label.layer.cornerRadius = 4.0
                label.text = annotation.title
                label.textAlignment = NSTextAlignment.center
                view.addSubview(label)
                
                view.alpha = 0.8
                view.canShowCallout = true;
                view.frame = CGRect(x: -markerWidth/2.0, y: -markerHeight/2.0, width:markerWidth, height: markerHeight)
            }
            return view
        }
        return nil
    }
    
    func gotStations(_ stations: [NRELGasStation]?) {
        if let locations = stations {
            print("gotStations \(locations.count)")
                for station in locations {
                    self.mapView.addAnnotation(StationAnnotation(title: station.station_name!,
                                                                locationName: "",
                                                                discipline: "",
                                                                coordinate: CLLocationCoordinate2D(latitude: station.latitude as! CLLocationDegrees, longitude: station.longitude as! CLLocationDegrees)))
                    print("Showing driver \(station.id), \(station.latitude) \(station.longitude)")
                }
            }
    }




    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if userLocation.coordinate.latitude != 0.0 && userLocation.coordinate.longitude != 0.0 {
            _ = self.__once
        }
        
        let api = MyGasFeedAPI()
        api.getGasStations(userLocation.coordinate.latitude, userLocation.coordinate.longitude, 5.0, completionHandler: gotStations)
/*
        self.geocoder!.reverseGeocodeLocation(self.mapView.userLocation.location!,
                                              completionHandler: {(placemarks:[CLPlacemark]?, error:Error?) -> Void in
                                                if let placemarks = placemarks {
                                                    self.placemark = placemarks[0]
                                                    self.currentAddress = ABCreateStringWithAddressDictionary((self.placemark?.addressDictionary)!, false)
                                                    //self.setDestinationButton.isEnabled = true
                                                    //self.currentLocationButton.isEnabled = true
                                                    
                                                }
                                                
        } )
 */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

