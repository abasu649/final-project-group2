//
//  TrailMapViewController2.swift
//  439FinalProject
//
//  Created by Anamika Basu on 3/1/21.
//

import Foundation
import UIKit
import Mapbox


 
class ViewController: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Configure a map view centered on Washington, D.C.
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 33.607561, longitude: -111.8456131), zoomLevel: 12, animated: false)
        mapView.delegate = self
         
        view.addSubview(mapView)
    }
 
// Wait until the map is loaded before adding to the map.
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "busstop2", ofType: "geojson")!)
        let source = MGLShapeSource(identifier: "circles", url: url, options: nil)
        style.addSource(source)
       style.addPoints(from: source)
        //style.addPolygons(from: source)
        //style.addLines(from: source)
    }
}

extension MGLStyle {
    func addPoints(from source: MGLShapeSource) {
        // Configure a circle style layer to represent rail stations, filtering out all data from
        // the source that is not of `metro-station` type.
        let circleLayer = MGLCircleStyleLayer(identifier: "stations", source: source)
        circleLayer.predicate = NSPredicate(format: "network = 'VRR'")
        circleLayer.circleColor = NSExpression(forConstantValue: UIColor.red)
        circleLayer.circleRadius = NSExpression(forConstantValue: 6)
        circleLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
        circleLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.black)
         
        self.addLayer(circleLayer)
    }
    func addLines(from source: MGLShapeSource) {
        /**
        Configure a line style layer to represent a rail line, filtering out all data from the
        source that is not of `Rail line` type. The `TYPE` is an attribute of the source data
        that can be seen by inspecting the GeoJSON source file, for example:
         
        {
        "type": "Feature",
        "properties": {
        "NAME": "Dupont Circle",
        "TYPE": "metro-station"
        },
        "geometry": {
        "type": "Point",
        "coordinates": [
        -77.043416,
        38.909605
        ]
        },
        "id": "994446c244acadeb15d3f9fc18278c73"
        }
        */
        let lineLayer = MGLLineStyleLayer(identifier: "LineString", source: source)
//        lineLayer.predicate = NSPredicate(format: "foot = 'yes'")
//        lineLayer.predicate = NSPredicate(format: "horse = 'yes'")
//        lineLayer.predicate = NSPredicate(format: "bicycle = 'yes'")
        lineLayer.predicate = NSPredicate(format: "name IN { 'Lost Dog (Moderate)', 'Quartz (Moderate)', 'Old Jeep (Moderate)', 'Ringtail (Moderate)', 'Sunrise (Moderate)'}")
//        lineLayer.predicate = NSPredicate(format: "name = ")
//        lineLayer.predicate = NSPredicate(format: "name = ")
//        lineLayer.predicate = NSPredicate(format: "name = ")
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
        lineLayer.lineWidth = NSExpression(forConstantValue: 2)
         
        self.addLayer(lineLayer)
    }
    func addPolygons(from source: MGLShapeSource) {
        // Configure a fill style layer to represent polygon regions in Washington, D.C.
        // Source data that is not of `neighborhood-region` type will be excluded.
        let polygonLayer = MGLFillStyleLayer(identifier: "DC-regions", source: source)
        polygonLayer.predicate = NSPredicate(format: "TYPE = 'neighborhood-region'")
        polygonLayer.fillColor = NSExpression(forConstantValue: UIColor(red: 0.27, green: 0.41, blue: 0.97, alpha: 0.3))
        polygonLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor(red: 0.27, green: 0.41, blue: 0.97, alpha: 1.0))
         
        self.addLayer(polygonLayer)
    }
}
