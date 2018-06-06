//
//  MapViewController.swift
//  LocApp
//
//  Created by Musa Lheureux on 23/05/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var positionsFriends: [FriendsLocation] = []

    struct Location: Codable {
        var latitude: String
        var longitude: String
    }
    
    // Mark: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFriendsLocation()

        // Do any additional setup after loading the view.
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        
        
    }
    
    private func loadFriendsLocation(){
        Network.get(path: "/user/\(Network.getUserId())/positions/friends") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonData):
                    let data = jsonData
                    if String(data: data, encoding: .utf8) != nil {
                        let decoder = JSONDecoder()
                        self.positionsFriends = try! decoder.decode([FriendsLocation].self, from: jsonData)
                        var pins: [Pin] = []
                        for friendLocation in self.positionsFriends {
                            let pin = Pin(CLLocationCoordinate2D(latitude: Double(friendLocation.latitude)!, longitude: Double(friendLocation.longitude)!), title: friendLocation.username)
                            pins.append(pin)
                        }
                        print(try! decoder.decode([FriendsLocation].self, from: jsonData))
                        //let annotation1: Pin = Pin.init(CLLocationCoordinate2D(latitude: 48.859231, longitude: 2.294782), title: "Bob MARLEY")
                        //let annotation2: Pin = Pin.init(CLLocationCoordinate2D(latitude: 48.873566, longitude: 2.294686), title: "Bob DYLAN")
                        //let annotation3: Pin = Pin.init(CLLocationCoordinate2D(latitude: 48.865866, longitude: 2.321214), title: "Carl JONSON")
                        //let annotations: [Pin] = [annotation1, annotation2, annotation3]
                        self.mapView.addAnnotations(pins)

                    } else {
                        print("no readable data received in response")
                    }
                    
                case .failure(let error):
                    fatalError("error: \(error.localizedDescription)")
                }
            }

        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup before appearing the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appearing the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup before disappearing the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Do any additional setup after disappearing the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Mark: -
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
        let width = 1000.0 // meters
        let height = 1000.0
        let region = MKCoordinateRegionMakeWithDistance(center, width, height)
        // let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.005), longitudeDelta: CLLocationDegrees(0.005)))
        self.mapView.setRegion(region , animated: true)
        
        let location = Location(latitude: String(userLocation.coordinate.latitude), longitude: String(userLocation.coordinate.longitude))
        // Put request
        guard let jsonData = try? JSONEncoder().encode(location) else {
            return
        }
        Network.put(path: "/user/\(Network.getUserId())/position", jsonData: jsonData) { (error, jsonData) in
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Pin else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Pin
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}
