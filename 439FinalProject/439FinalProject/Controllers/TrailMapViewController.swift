//
//  TrailMapViewController.swift
//  439FinalProject
//
//  Created by Andrew Wu on 2/20/21.
//

//import SwiftOverpass
import Mapbox
import FirebaseDatabase

class TrailMapViewController: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    var locationManager = CLLocationManager()
    var lon = 0.0
    var lat = 0.0
    var practice: [MGLPointAnnotation] = []
    var id = 0
    let button = LoadingButtonView()
    
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
        addRefreshButton()
    }
    
    
    @objc func refreshMap() {
        button.loadIndicator(true)
        button.isEnabled=false
        if let source = mapView.style?.source(withIdentifier: "trail\(id)") as? MGLShapeSource {
            source.shape = nil
        }
        id += 1;
        if let annotations = mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
        lat = self.mapView.centerCoordinate.latitude
       lon = self.mapView.centerCoordinate.longitude
        var around = 0
        if self.mapView.zoomLevel <= 12 {
            around = 10000
        } else {
            around = 1000
        }
        DispatchQueue.global().async {
            let apiUrl = "https://trails-geojson.herokuapp.com/data?lat=\(self.lat)&lon=\(self.lon)&around=\(around)"
            let url = URL(string: apiUrl)!
            self.parseGeojson(url: url)
            DispatchQueue.main.async() {
                let newSource = MGLShapeSource(identifier: "trail\(self.id)", url: url, options: nil)
                self.mapView.style?.addSource(newSource)
                self.mapView.style?.addLines(trailID: "trail\(self.id)", from: newSource)
                self.button.loadIndicator(false)
                self.button.isEnabled=true

            }
        }
        
        
    }
    
    func addRefreshButton() {
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = UIColor.systemBlue
        //button.sizeToFit()
        button.center.x = self.view.center.x
        button.frame = CGRect(origin: CGPoint(x: button.frame.origin.x, y: self.view.frame.size.height - button.frame.size.height - 5), size: button.frame.size)
        button.addTarget(self, action: #selector(refreshMap), for: .touchUpInside)
        button.layer.cornerRadius = 10.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.view.addSubview(button)
        
        if #available(iOS 11.0, *) {
            let safeArea = view.safeAreaLayoutGuide
            button.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                button.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5),
                button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
            ]

            NSLayoutConstraint.activate(constraints)
        } else {
            button.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        }
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
                if name.contains("Trail")  || name.contains("Path") || name.contains("(") {
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
                             subtitle = subtitle + "\nBikes are allowed on the trail."
                        }
                    }
                    if horse != nil {
                        if (horse == "yes") {
                             subtitle = subtitle + "\nHorses are allowed on the trail."
                        }
                    }
                    annotation.title = "\(name)\n\(subtitle)"
                    annotations.append(annotation)
                }
                
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
        let apiUrl = "https://trails-geojson.herokuapp.com/data?lat=\(lat)&lon=\(lon)&around=1000"
        let url = URL(string: apiUrl)!
        parseGeojson(url: url)
        let source = MGLShapeSource(identifier: "trail\(id)", url: url, options: nil)
        style.addSource(source)
        style.addLines(trailID: "trail\(id)", from: source)
        
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
    
//    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
//        print(mapView.zoomLevel, "")
//    }
    
    
//    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
//        let apiUrl = "https://trails-data.herokuapp.com/data?lat=\(newCamera.centerCoordinate.latitude)&lon=\(newCamera.centerCoordinate.longitude)"
//        let url = URL(string: apiUrl)!
//        parseGeojson(url: url)
//
//        return true
//    }

}
                                
extension MGLStyle {
    func addLines(trailID : String, from source: MGLShapeSource) {
        let lineLayer = MGLLineStyleLayer(identifier: trailID, source: source)
        lineLayer.predicate = NSPredicate(format: "name CONTAINS 'Trail' OR name CONTAINS 'Path' OR name CONTAINS '('")
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
        lineLayer.lineWidth = NSExpression(forConstantValue: 2)
        self.addLayer(lineLayer)
    }
}
