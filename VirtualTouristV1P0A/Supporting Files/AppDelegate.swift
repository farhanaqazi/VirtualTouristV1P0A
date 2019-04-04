//
//  AppDelegate.swift
//  VirtualTouristV1P0A
//
//  Created by Farhan Qazi on 3/27/19.
//  Copyright © 2019 Farhan Qazi. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let dataController = DataController(modelName: "VirtualTourist")
    struct UserDefaultKeys {
        static let HasLaunchedBefore = "hasLaunchedBefore"
        static let MapViewRegion = "mapViewRegion"
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        checkIfFirstLaunch()
        
        // load data from coreData
        dataController.load()
        
        let navigatonController = window?.rootViewController as! UINavigationController
        let travelLocationVC = navigatonController.topViewController as! TravelLocationsViewController
        travelLocationVC.dataController = dataController
        
        return true
    }
    
    
    // MARK: Helper Method
    
    func checkIfFirstLaunch() {
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.HasLaunchedBefore) {
            print("App has launched before")
        } else {
            print("This is the first launch ever!")
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.HasLaunchedBefore)
            
            let lat = 40.1764619
            let lon = -100.2668550
            let radius = 5000000.0
            
            let coordinate = CLLocationCoordinate2DMake(lat, lon)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
            
            // Set default to show entire US
            UserDefaults.standard.set([
                "latitude": region.center.latitude,
                "longitude": region.center.longitude,
                "latitudeDelta": region.span.latitudeDelta,
                "longitudeDelta": region.span.longitudeDelta
                ], forKey: UserDefaultKeys.MapViewRegion)
            UserDefaults.standard.synchronize()
        }
    }
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }
    
    
}

