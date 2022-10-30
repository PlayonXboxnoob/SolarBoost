//
//  MapViewModel.swift
//  Solar Boost
//
//  Created by Pallavi Naravane on 10/29/22.
//

import SwiftUI
import MapKit
import CoreLocation

//All map data goes here

class MapViewModel: NSObject,ObservableObject,CLLocationManagerDelegate{
    
    @Published var mapView = MKMapView()
    
    //Region...
    @Published var region : MKCoordinateRegion!
    // It will setup based on location...
    
    
    //Alert user
    @Published var permissionDenied = false
    
    // Map Type
    @Published var mapType: MKMapType = .standard
    
    // search text..
    @Published var searchText = ""
    
    
    // Searched places are stored here
    @Published var searchedPlaces: [Place] = []
    
    @Published var selectedMonth = 0
    @Published var showMonth = false
    
    
    func toggleMonth(){
        showMonth.toggle()
    }
    
    // Updating Map Type ...
    func updateMapType(){
        if mapType == .standard{
            mapType = .hybrid
            mapView.mapType = mapType
        } else{
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    // Focus location on the map
    func focusLocation(){
        
        guard let _ = region else {return}
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        
        //remove all annotations
        mapView.removeAnnotations(mapView.annotations)
        
    }
    
    //search places on the map
    func searchPlacesQuery(){
        
        searchedPlaces.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        // Fetch the results
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else {return}
            
            self.searchedPlaces = result.mapItems.compactMap({ (item) -> Place? in
                return Place(place: item.placemark)
            })
            
        }
        
    }
    
    //select search result
    func selectPlace(place : Place){
        
        // Showing pin on the map
        searchText = ""
        
        guard let coordinate = place.place.location?.coordinate else {return}
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "No name"
        
        //remove all old annotations first
        mapView.removeAnnotations(mapView.annotations)
        
        //showing on the map
        mapView.addAnnotation(pointAnnotation)
        
        // Focusing map to the annotation location
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        
        //print(mapView.region.center.latitude)
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        //Checking permissions....
        switch manager.authorizationStatus {
        case .denied:
            //Alert the user...
            permissionDenied.toggle()
        case .notDetermined:
            //Requesting location....
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            //If permissions given by user
            manager.requestLocation()
            
        case .authorizedAlways:
            manager.requestLocation()
            
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // in case of Error....
        print(error.localizedDescription)
    }
    
    // Getting user region...
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        
        //Updating Map ...
        self.mapView.setRegion(self.region, animated: true)
        
        //Smooth animations
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
    //Get year round optimal angle
    func getYearRoundAngle() -> String {
        
        guard let _ = region else { return "" }
        let latitude = self.mapView.region.center.latitude
        
        var angle: Double = 0.0
        if latitude >= 0.0 {
            angle = 1.3793 + latitude * (1.2011 + latitude * (-0.014404 + latitude * 0.000080509))
        } else {
            angle = -0.41657 + latitude * (1.4216 + latitude * (0.024051 + latitude * 0.00021828))
        }
        
        return String(format: "%.2f", angle)
    }
    
    func getMonthAngle(monthAdd: Double) -> String {
        
        guard let _ = region else { return "" }
        let latitude = self.mapView.region.center.latitude
        
        var angle: Double = 0.0
        if latitude >= 0.0 {
            angle = 1.3793 + latitude * (1.2011 + latitude * (-0.014404 + latitude * 0.000080509))
            angle += monthAdd
        } else {
            angle = -0.41657 + latitude * (1.4216 + latitude * (0.024051 + latitude * 0.00021828))
            angle -= monthAdd
        }
        
        return String(format: "%.2f", angle)
        
    }
    
}
