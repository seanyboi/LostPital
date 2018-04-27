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

var HealthPlaces2:[HealthPlace] = []

struct HealthPlace {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let icon: String
    let rating : Double
    //    let type: String
}

class ViewController: UIViewController, GMSMapViewDelegate {
    
    var potentialProblem : String!
    var radius : Int!
    var type : String!
    
    @IBOutlet weak var viewToDisplayMap: UIView!
    
    // Determine which potential type of place the user may wish to visit
    /*func DeterminePlaceType() {
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
     }*/
    
    func getHealthPlaces (request: URL, completion:@escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return completion(nil)
            }
            return completion(data)
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(potentialProblem)
        //print(radius)
        
        //DeterminePlaceType()
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
        
        
        //Simulated Coordinates:
        //School of Electronic and Electrical Engineering
        //188 Woodhouse Ln, Leeds LS2, UK
        //Latitude: 53.809472 | Longitude: -1.554973
        
        
        //let url = URL(string : "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyC-IopjQwmhTpgJCV6aDYHhYiV6RG0H5G8&&location=53.8020860,-1.5644430&radius=\(radius)&types=\(type)")
        
        let url = URL(string : "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=53.809472,-1.554973&radius=5000&types=dentist&key=AIzaSyDV69zY7VYkfaaxRwyvP3YFwvWJ6gC8DM8&sensor=true")
        
        navigationItem.title = "Health App Map"
        
        let camera = GMSCameraPosition.camera(withLatitude: 53.8004533, longitude: -1.5542509, zoom: 15)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
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
    
    func updateMap(mymapView : GMSMapView)
    {
        DispatchQueue.main.async() {
            
            //Manual Testing
            /*HealthPlaces.append(HealthPlace.init(name: "place 1", latitude: 53.801224, longitude: -1.5569374, icon: "https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png", rating: 5.5))
             HealthPlaces.append(HealthPlace.init(name: "place 2", latitude: 53.80323610000001, longitude: -1.5557941, icon: "https://maps.gstatic.com/mapfiles/place_api/icons/school-71.png", rating: 7.5))
             HealthPlaces.append(HealthPlace.init(name: "place 3", latitude: 53.8070725, longitude: -1.5573777, icon: "https://maps.gstatic.com/mapfiles/place_api/icons/doctor-71.png", rating: 7.5))
             */
            
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
    
    func Json(myurl: URL, mymapView2 : GMSMapView) /*-> [HealthPlace] */{
        
        //var HealthPlaces:[HealthPlace] = []
        
        /*let task = URLSession.shared.dataTask(with: myurl){ (data, response, error) in
         if error != nil { print ("Error") }
         else {
         do
         {
         if let data = data,*/
        
        getHealthPlaces(request: myurl) {data in
            do {
                self.updateMap(mymapView: mymapView2)
                
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
                                    
                                    HealthPlaces2.append(HealthPlace.init(name: (place as NSString) as String,
                                                                          latitude: (lat2) as Double,
                                                                          longitude: (lon2)as Double,
                                                                          icon: (icon as NSString) as String,
                                                                          rating: (rating2) as Double
                                        /*type: (type2) as String*/))
                                }
                            }
                        }
                        print(HealthPlaces2[i])
                    }
                }
            }
            catch let error as NSError
            { print(error)}
            
        }
        //task.resume()
        //return HealthPlaces
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
