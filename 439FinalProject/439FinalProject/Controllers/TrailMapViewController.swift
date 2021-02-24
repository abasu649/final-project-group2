//
//  TrailMapViewController.swift
//  439FinalProject
//
//  Created by Andrew Wu on 2/20/21.
//

import SwiftOverpass
import Mapbox
 
class TrailMapViewController: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), zoomLevel: 9, animated: false)
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
//    func mapView(_ mapView: MGLMapView, didUpdateUserLocation userLocation: Any!){
//        mapView.userTrackingMode = .follow
//    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.setCenter((mapView.userLocation?.coordinate)!, animated: false)
    }
}
