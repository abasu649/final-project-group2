//
//  TrailMapViewController.swift
//  439FinalProject
//
//  Created by Andrew Wu on 2/20/21.
//

//import SwiftOverpass
import Mapbox

class TrailMapViewController: UIViewController, MGLMapViewDelegate {
    
    var trails:[[String:Any]] = []
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
    
    //Zoom into marker when tapped
//    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
//        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, acrossDistance: 4500, pitch: 15, heading: 180)
//        mapView.fly(to: camera, withDuration: 4,
//        peakAltitude: 3000, completionHandler: nil)
//    }
    
    //Allow annotations to be tapped
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    //Load data when map is finished loading
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
                                if !self.trailNames.contains(trailName) && (trailName.contains("Trail")||trailName.contains("trail"))  {
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
            //print(self.trailNames)
            for trail in self.trails {
                guard let trailLocations = trail["geometry"] as? [[String:Any]] else {return}
                guard let trailTags = trail["tags"] as? [String:Any] else {return}
                //guard let trailNameDirty = trailTags["name"] as? String else {return}
                //let trailName = trailNameDirty.replacingOccurrences( of:"[^A-Za-z0-9]+", with: " ", options: .regularExpression)
                guard let trailName = trailTags["name"] as? String else {return}
                guard let trailLat = trailLocations[0]["lat"] as? Double else {return}
                guard let trailLon = trailLocations[0]["lon"] as? Double else {return}
                //print(trailLat, trailLon, trailName)
                let point = MGLPointAnnotation()
                let trailCoord = CLLocationCoordinate2D(latitude: trailLat, longitude: trailLon)
                point.coordinate = trailCoord
                point.title = trailName
                mapView.addAnnotation(point)
            }
        }
        task.resume()
    }
}
