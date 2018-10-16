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
    
    var coordinate: CoordinateStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMap()
    }
}

extension LocationViewController {
    fileprivate func loadMap() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: coordinate?.lat ?? 0, longitude: coordinate?.lon ?? 0)
        let viewRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000);
        let adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        mapView.addAnnotation(pin)
    }
}

