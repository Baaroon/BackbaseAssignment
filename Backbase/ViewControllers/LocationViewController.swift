//
//  LocationViewController.swift
//  Backbase
//
//  Created by Zahra Aghajani on 10/16/18.
//  Copyright © 2018 Zahra Aghajani. All rights reserved.
//

import MapKit

class LocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var city: CityStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = city?.name ?? "Location"
        loadMap()
    }
}

extension LocationViewController {
    fileprivate func loadMap() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: city?.coord.lat ?? 0, longitude: city?.coord.lon ?? 0)
        let viewRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000);
        let adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        mapView.addAnnotation(pin)
    }
}

