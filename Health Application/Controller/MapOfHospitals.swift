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

var HealthPlaces2 : [HealthPlace] = []

//Struct for the Health places returned by Google Map API.
struct HealthPlace {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let icon: String
    let rating : Double
}

class MapOfHospitals: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var location = CLLocationManager()
    var mapView: GMSMapView!
    
    var radius = 0
    var type = ""
    var key = "AIzaSyDV69zY7VYkfaaxRwyvP3YFwvWJ6gC8DM8"
    var potentialProblem = ""
    
    @IBOutlet weak var viewToDisplayMap: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Determines users location.
        
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestAlwaysAuthorization()
        location.startUpdatingLocation()
        location.delegate = self
        
        DeterminePlaceType()
        
        //Uses users location to and previous inputted variables to create API url.
        
        let latitude = (location.location?.coordinate.latitude)!
        let longitude = (location.location?.coordinate.longitude)!
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&types=\(type)&key=\(key)"
        
        let url = URL(string : urlString)
        
        //Updates map with current position and places location button so users can find their location
        
        let camera = GMSCameraPosition.camera(withLatitude: (location.location?.coordinate.latitude)!, longitude: (location.location?.coordinate.longitude)!, zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.isMyLocationEnabled = true;
        mapView.settings.compassButton = true;
        mapView.settings.myLocationButton = true;
        mapView.delegate = self;
        
        Json(myurl: url!, mymapView2: mapView)
        
        view = mapView
        
        
    }
    
    //Updates location when the users uses the application
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last!
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        
        mapView.camera = camera
        mapView.animate(to: camera)
        
        location.stopUpdatingLocation()
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Determine which potential type of place the user may wish to visit
    func DeterminePlaceType() {
        if potentialProblem.lowercased().range(of:"tooth") != nil ||
            potentialProblem.lowercased().range(of:"teeth") != nil ||
            potentialProblem.lowercased().range(of:"mouth") != nil ||
            potentialProblem.lowercased().range(of:"gum") != nil {
            type = "dentist"
        } else if potentialProblem.lowercased().range(of:"head") != nil {
            type = "pharmacy"
        } else if potentialProblem.lowercased().range(of:"arm") != nil ||
            potentialProblem.lowercased().range(of:"leg") != nil {
            type = "physiotherapist"
        } else {
            type = "hospital"
        }
    }
    
    // Send the request to the URL, uses a completionHandler to ensure we obtain
    // data, and handle cases where the URL does not respond
    func getHealthPlaces (request: URL, completion:@escaping (Data?) -> Void) {
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return completion(nil)
            }
            return completion(data)
            }.resume()
    }
    
    //Updates the map asynchronously with the markers associated with the health facilities.
    func updateMap(mymapView : GMSMapView)
    {
        DispatchQueue.main.async() {
                        
            for state in HealthPlaces2 {
                let state_marker = GMSMarker()
                state_marker.position = CLLocationCoordinate2D(latitude: state.latitude, longitude: state.longitude)
                state_marker.title = state.name
                state_marker.snippet = "Name: \(state.name) \nRating: \(state.rating)"
                state_marker.map = mymapView
                
                if let url = URL(string: state.icon) { self.downloadasync(url: url, state_marker: state_marker) }
            }
            self.focusMapToShowAllMarkers(mymapView: mymapView, HealthPlaces: HealthPlaces2)
        }
        
    }
    
    // Function for setting up GET request for diagnosis from Google Maps

    func Json(myurl: URL, mymapView2 : GMSMapView){
        
    
        getHealthPlaces(request: myurl) {data in
            do {
                
                
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any],
                    let results = json["results"] as? NSArray {
                    
                    for i in 0..<results.count {
                        
                        if let geometry = results[i] as? NSDictionary{
                            place = geometry.value(forKey: "name") as! String
                            icon = geometry.value(forKey: "icon") as! String
                            
                            if let rating = geometry["rating"] as? Double{
                                rating2 = rating
                            }
                            
                            if let location = geometry["geometry"] as? NSDictionary{
                                
                                if let coords = location["location"] as? NSDictionary{
                                    
                                    if let lat = coords["lat"] as? Double{
                                        lat2 = lat
                                    }
                                    if let lng = coords["lng"] as? Double{
                                        lon2 = lng
                                    }
                                    
                                    HealthPlaces2.append(HealthPlace.init(name: (place as NSString) as String,
                                                                          latitude: (lat2) as Double,
                                                                          longitude: (lon2)as Double,
                                                                          icon: (icon as NSString) as String,
                                                                          rating: (rating2) as Double))
                                }
                            }
                        }
                    }
                    
                        self.updateMap(mymapView: mymapView2)

                }
            }
            catch let error as NSError
            { print(error)}
            
        }

    }
    
    //Focuses google maps on area where most markers are placed.
    func focusMapToShowAllMarkers(mymapView: GMSMapView, HealthPlaces : [HealthPlace]) {
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: HealthPlaces.first!.latitude,longitude: HealthPlaces.first!.longitude)
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
        
        let state_marker = GMSMarker()
        bounds = bounds.includingCoordinate(state_marker.position)
        mymapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
        mymapView.animate(toZoom: 15)
    }
    
    override func loadView() {
        
    }
    
    //Recieves data from URL.
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in completion(data, response, error) }.resume()
    }
    
    //Downloads the images associated with a particular health place from the JSON data recieved during API call.
    func downloadasync(url: URL, state_marker : GMSMarker){
        getDataFromUrl(url: url) { data, response, error in guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { state_marker.icon = self.imageWithImage(image: UIImage(data: data)!, scaledToSize: CGSize(width: 33.0, height: 33.0)) } }
    }
    
    //Converts downloaded image into a marker
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
}
