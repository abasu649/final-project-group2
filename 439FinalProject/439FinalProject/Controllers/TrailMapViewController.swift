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
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), zoomLevel: 9, animated: false)
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
        
        let url = URL(string: "http://overpass-api.de/api/interpreter?data=[bbox];way[sac_scale=hiking];out;&bbox=-122.62939453125,36.836767364219,-121.27670288086,37.855338589498")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print("test")
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
    
//    func mapView(_ mapView: MGLMapView, didUpdateUserLocation userLocation: Any!){
//        mapView.userTrackingMode = .follow
//    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.setCenter((mapView.userLocation?.coordinate)!, animated: false)
    }
}
