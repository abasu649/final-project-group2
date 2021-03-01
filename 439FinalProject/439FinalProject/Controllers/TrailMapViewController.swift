//
//  TrailMapViewController.swift
//  439FinalProject
//
//  Created by Andrew Wu on 2/20/21.
//

//import SwiftOverpass
import Mapbox

class TrailMapViewController: UIViewController, MGLMapViewDelegate {
    
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
        //print("latitude: \(mapView.latitude), longitude: \(mapView.longitude)")
        let lat = mapView.latitude
        let lon = mapView.longitude
        let box = [lon - 0.2526855444, lat - 0.4210251975, lon + 0.2526855444, lat + 0.4210251975]
        let url = URL(string: "http://overpass-api.de/api/interpreter?data=[bbox];way[sac_scale=hiking];out;&bbox=\(box[0]),\(box[1]),\(box[2]),\(box[3])")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print("test")
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
}
