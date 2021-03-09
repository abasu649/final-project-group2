//
//  TrailMapViewController2.swift
//  439FinalProject
//
//  Created by Anamika Basu on 3/1/21.
//

import Foundation
import UIKit
import Mapbox
import CoreLocation
import MapKit

class ViewController: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    var locationManager = CLLocationManager()
    var lon = 0.0
    var lat = 0.0
    var practice: [MGLPointAnnotation] = []

    struct FeatureCollection : Codable {
        let type : String
        var features : [Feature]
    }

    struct Feature : Codable {
        let type : String
        let properties : Properties
        let geometry : Geometry
    }

    struct Properties : Codable {
        let name : String
        let horse : String?
        let bicycle : String?
        let surface : String?
    }

    struct Geometry : Codable {
        let type : String
        let coordinates : [[Double]]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
           lat = currentLoc.coordinate.latitude
           lon = currentLoc.coordinate.longitude
        }

        // Configure a map view centered on user location
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), zoomLevel: 12, animated: false)
        mapView.delegate = self
        mapView.showsUserLocation = true

        view.addSubview(mapView)

    }
    func addMarkers(geojson: String)  {
        var annotations: [MGLAnnotation] = []
        let geojsonData = Data(geojson.utf8)
        do {
            let result = try JSONDecoder().decode(FeatureCollection.self, from: geojsonData)
            let featureList = result.features
            for feature in featureList {
                let geometry = feature.geometry
                let coordinates = geometry.coordinates
                let firstCoordinate = coordinates[0]
                let latitude: Double = firstCoordinate[1]
                let longitude: Double = firstCoordinate[0]
                let properties = feature.properties
                let name = properties.name
                let horse = properties.horse
                let bicycle = properties.bicycle
                let surface = properties.surface
                let annotation = MGLPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                //annotation.title = name
                var subtitle : String = ""
                if let surfaceDescription = surface {
                    subtitle = "\nThe surface of the trail is \(surfaceDescription)."
                }
                if bicycle != nil {
                    if (bicycle == "yes") {
                         subtitle = subtitle + " \nBikes are allowed on the trail."
                    }
                }
                if horse != nil {
                    if (horse == "yes") {
                         subtitle = subtitle + " \nHorses are allowed on the trail."
                    }
                }
                annotation.title = "\(name)\n\(subtitle)"
                annotations.append(annotation)
            }
            mapView.addAnnotations(annotations)
        } catch {
                print("Unexpected error: \(error).")
        }

    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {

//        let west = lat - 0.1
//        let east = lat + 0.1
//        let north = lon + 0.1
//        let south = lon - 0.1

//        let apiUrl = "https://trails-data.herokuapp.com/data?west=\(west)&south=\(south)&east=\(east)&north=\(north)"
        let apiUrl = "https://trails-data.herokuapp.com/data?lat=\(lat)&lon=\(lon)"
        let url = URL(string: apiUrl)!
        parseGeojson(url: url)
        let source = MGLShapeSource(identifier: "trails", url: url, options: nil)
        style.addSource(source)
        style.addLines(from: source)
        
    }
    
    func parseGeojson(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let geojsonString = String(data: data, encoding: String.Encoding.utf8) else {
                print("Error while parsing the response data.")
                return
            }
            self.addMarkers(geojson: geojsonString)

        }.resume()
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
    // Always allow callouts to popup when annotations are tapped.
        return true
    }

    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
    // Instantiate and return our custom callout view.
        return CustomCalloutView(representedObject: annotation)
    }
    
    ///TODO: use the changing zoom level to change "around" query parameter in API call
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        //print(mapView.zoomLevel, "")
    }
    
    ///TODO: as maap camera changes, new trails and markers should populate map and old markers should disappear
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
//        let apiUrl = "https://trails-data.herokuapp.com/data?lat=\(newCamera.centerCoordinate.latitude)&lon=\(newCamera.centerCoordinate.longitude)"
//        let url = URL(string: apiUrl)!
//        parseGeojson(url: url)
//
//
//        return true
    }

}
///TODO: fix highway=path in app.py
extension MGLStyle {
    func addLines(from source: MGLShapeSource) {
        let lineLayer = MGLLineStyleLayer(identifier: "trails", source: source)
        lineLayer.predicate = NSPredicate(format: "highway = 'footway'")
        //lineLayer.predicate = NSPredicate(format: "highway = 'path'")
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
        lineLayer.lineWidth = NSExpression(forConstantValue: 2)
        self.addLayer(lineLayer)
    }
}
