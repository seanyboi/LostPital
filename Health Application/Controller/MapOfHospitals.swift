//
//  MapOfHospitals.swift
//  Health Application
//
//  Created by Abraham Lopez on 20/04/2018.
//  Copyright © 2018 Team Impala. All rights reserved.
//

import UIKit
import GoogleMaps

var place : String = ""
var lat2 : Double = 0.0
var lon2 : Double = 0.0
var icon : String = ""
var rating2 : Double = 0.0

//var type2 : String = ""

var HealthPlaces:[HealthPlace] = []

struct HealthPlace {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let icon: String
    let rating : Double
    //    let type: String
}

class MapOfHospitals: UIViewController {
    
    var potentialProblem = [Diagnosis]()
    
    @IBOutlet weak var viewToDisplayMap: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Original
        /*
         let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
         let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
         viewToDisplayMap = mapView
         
         // Creates a marker in the center of the map.
         let marker = GMSMarker()
         marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
         marker.title = "Sydney"
         marker.snippet = "Australia"
         marker.map = mapView*/
        
        let url = URL(string : "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyC-IopjQwmhTpgJCV6aDYHhYiV6RG0H5G8&&location=53.8020860,-1.5644430&radius=1000&types=dentist")
        
        navigationItem.title = "Health App Map"
        
        let camera = GMSCameraPosition.camera(withLatitude: 53.8004533, longitude: -1.5542509, zoom: 15)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        //Json(myurl: url!)
        
        //Manual Testing (Testing downloadasync method)
        HealthPlaces.append(HealthPlace.init(name: "place 1", latitude: 53.801224, longitude: -1.5569374, icon: "https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png", rating: 5.5))
        HealthPlaces.append(HealthPlace.init(name: "place 2", latitude: 53.80323610000001, longitude: -1.5557941, icon: "https://maps.gstatic.com/mapfiles/place_api/icons/school-71.png", rating: 7.5))
        HealthPlaces.append(HealthPlace.init(name: "place 3", latitude: 53.8070725, longitude: -1.5573777, icon: "https://maps.gstatic.com/mapfiles/place_api/icons/doctor-71.png", rating: 7.5))
        
        for state in HealthPlaces {
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: state.latitude, longitude: state.longitude)
            state_marker.title = state.name
            state_marker.snippet = "Name: \(state.name) \nRating: \(state.rating)"
            state_marker.map = mapView
            
            if let url = URL(string: state.icon) { downloadasync(url: url, state_marker: state_marker) }
        }
        
        view = mapView
        
        DispatchQueue.main.async() {
            self.focusMapToShowAllMarkers(mymapView: mapView, HealthPlaces: HealthPlaces)
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func Json(myurl: URL) {
        
        let task = URLSession.shared.dataTask(with: myurl){ (data, response, error) in
            if error != nil { print ("Error") }
            else {
                do
                {
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any],
                        let results = json["results"] as? NSArray {
                        
                        for i in 0..<results.count {
                            
                            if let geometry = results[i] as? NSDictionary{ //print(geometry)
                                place = geometry.value(forKey: "name") as! String
                                icon = geometry.value(forKey: "icon") as! String
                                
                                if let rating = geometry["rating"] as? Double{ //print(rating)
                                    rating2 = rating
                                }
                                
                                /*if let types = geometry["types"] as? NSArray{
                                 for j in 0..<types.count {
                                 if let type = types[j] as? NSMutableString{ //print(type)
                                 type2 = type as String
                                 }
                                 }
                                 }*/
                                
                                if let location = geometry["geometry"] as? NSDictionary{ //print(location)
                                    
                                    if let coords = location["location"] as? NSDictionary{ //print(latlon)
                                        
                                        if let lat = coords["lat"] as? Double{ print(lat)
                                            lat2 = lat
                                        }
                                        if let lng = coords["lng"] as? Double{ print(lng)
                                            lon2 = lng
                                        }
                                        
                                        HealthPlaces.append(HealthPlace.init(name: (place as NSString) as String,
                                                                             latitude: (lat2) as Double,
                                                                             longitude: (lon2)as Double,
                                                                             icon: (icon as NSString) as String,
                                                                             rating: (rating2) as Double
                                            /*type: (type2) as String*/))
                                    }
                                }
                            }
                            print(HealthPlaces[i])
                        }
                    }
                }
                catch
                {}
            }
        }
        task.resume()
    }
    
    func focusMapToShowAllMarkers(mymapView: GMSMapView, HealthPlaces:[HealthPlace]) {
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: HealthPlaces.first!.latitude,longitude: HealthPlaces.first!.longitude)
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
        
        let state_marker = GMSMarker()
        bounds = bounds.includingCoordinate(state_marker.position)
        mymapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
        mymapView.animate(toZoom: 15)
    }
    
    override func loadView() {
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in completion(data, response, error) }.resume()
    }
    
    func downloadasync(url: URL, state_marker : GMSMarker){
        getDataFromUrl(url: url) { data, response, error in guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { state_marker.icon = UIImage(data: data) } }
    }
}
