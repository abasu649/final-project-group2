//
//  TrailMapViewController.swift
//  439FinalProject
//
//  Created by Andrew Wu on 2/20/21.
//


import Mapbox
 
class TrailMapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
    }
}
