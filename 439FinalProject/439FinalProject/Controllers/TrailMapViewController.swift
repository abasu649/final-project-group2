//
//  TrailMapViewController.swift
//  439FinalProject
//
//  Created by Andrew Wu on 2/20/21.
//

//import SwiftOverpass
import Mapbox

class TrailMapViewController: UIViewController, MGLMapViewDelegate {
    
    var trails:[Any] = []
    var trailNames:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let urlStyle = URL(string: "mapbox://styles/mapbox/streets-v11")
        let mapView = MGLMapView(frame: view.bounds, styleURL: urlStyle)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.33233, longitude: -122.03122), zoomLevel: 9, animated: false)
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
//    func mapView(_ mapView: MGLMapView, didUpdateUserLocation userLocation: Any!){
//        mapView.userTrackingMode = .follow
//    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.setCenter((mapView.userLocation?.coordinate)!, animated: false)
        let lat = mapView.latitude
        let lon = mapView.longitude
        let box = [lat - 0.4210251975, lon - 0.2526855444, lat + 0.4210251975, lon + 0.2526855444]
        let url = URL(string: "https://www.overpass-api.de/api/interpreter?data=[out:json];way[highway=path](\(box[0]),\(box[1]),\(box[2]),\(box[3]));out%20geom;")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    if let elements = json["elements"] as? [[String:Any]]{
                        for trail in elements{
                            guard let trailTags = trail["tags"] as? [String:Any] else {return}
                            let surfaceExists = trailTags["surface"] != nil
                            let nameExists = trailTags["name"] != nil
                            if nameExists && surfaceExists {
                                guard let trailName = trailTags["name"] as? String else {return}
                                if !self.trailNames.contains(trailName){
                                    self.trails.append(trail)
                                    self.trailNames.append(trailName)
                                }
                            }
                        }
                    }
                    else{
                        print("failed to read JSON")
                    }

                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            print(self.trails)
            print(self.trailNames)
        }
        task.resume()
    }
}
