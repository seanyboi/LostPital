//
//  MapOfHospitals.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit
import GoogleMaps

class MapOfHospitals: UIViewController {
    
    var potentialProblem = [Diagnosis]()
    
    @IBOutlet weak var viewToDisplayMap: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        viewToDisplayMap = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
}
