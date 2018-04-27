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

var HealthPlaces2:[HealthPlace] = []

struct HealthPlace {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let icon: String
    let rating : Double
}

class MapOfHospitals: UIViewController, GMSMapViewDelegate {
    
    var radius = 0
    var type = ""
    var key = "AIzaSyDV69zY7VYkfaaxRwyvP3YFwvWJ6gC8DM8"
    var potentialProblem = ""
    

    
    @IBOutlet weak var viewToDisplayMap: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DeterminePlaceType()
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=53.809472,-1.554973&radius=\(radius)&types=\(type)&key=\(key)"
        
        let url = URL(string : urlString)
        
        let camera = GMSCameraPosition.camera(withLatitude: 53.809472, longitude: -1.554973, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.isMyLocationEnabled = true;
        mapView.settings.compassButton = true;
        mapView.settings.myLocationButton = true;
        mapView.delegate = self;
        
        Json(myurl: url!, mymapView2: mapView)
        
        view = mapView
        

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
    
    func getHealthPlaces (request: URL, completion:@escaping (Data?) -> Void) {
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return completion(nil)
            }
            return completion(data)
            }.resume()
    }
    
    func updateMap(mymapView : GMSMapView)
    {
        DispatchQueue.main.async() {
            
            print("Async Task ended!")
            
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
                                    
                                    if let lat = coords["lat"] as? Double{ print(lat)
                                        lat2 = lat
                                    }
                                    if let lng = coords["lng"] as? Double{ print(lng)
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
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in completion(data, response, error) }.resume()
    }
    
    func downloadasync(url: URL, state_marker : GMSMarker){
        getDataFromUrl(url: url) { data, response, error in guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { state_marker.icon = self.imageWithImage(image: UIImage(data: data)!, scaledToSize: CGSize(width: 33.0, height: 33.0)) } }
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
}
