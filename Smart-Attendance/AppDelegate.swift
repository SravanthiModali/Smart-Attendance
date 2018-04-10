//
//  AppDelegate.swift
//  Smart-Attendance
//
//  Created by Modali,Naga Sravanthi on 2/16/18.
//  Copyright © 2018 Modali,Naga Sravanthi. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{
    
//sid for sending across the activities to generate QR code
    var sid : String = ""
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    @objc var bgtimer = Timer()
    
 
    var location1 : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var current_time = NSDate().timeIntervalSince1970
    
    var timer = Timer()
    
    var f = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
   
        
        // Override point for customization after application launch.
          // Initialize Parse.
        let configuration = ParseClientConfiguration {
            $0.applicationId = "lLp83BZWDT6RnkyrJ3mMcb1Q2rdxaa4AwGUCnjEd"
            $0.clientKey = "V9khFJXJkrUrRlWvpeJwNuNPyQOtyj7Is54jRM3S"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
     //   self.doBackgroundTask()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.doBackgroundTask()
        print("Entering Background")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
         print("Entering fore Background")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
  func doBackgroundTask() {
        DispatchQueue.main.async {
            
          self.beginBackgroundUpdateTheTask()
            
           self.StartUpdateTheLocation()
            
            
            self.bgtimer = Timer.scheduledTimer(timeInterval:2.0, target: self, selector: #selector(getter: AppDelegate.bgtimer), userInfo: nil, repeats: true)
            RunLoop.current.add(self.bgtimer, forMode: RunLoopMode.defaultRunLoopMode)
            RunLoop.current.run()
            
           self.endBackGroundUpdateTheTask()
            
        }
    }
   func beginBackgroundUpdateTheTask() {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackGroundUpdateTheTask()
        })
    }
    
    
    func endBackGroundUpdateTheTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    func StartUpdateTheLocation() {
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        self.locationManager.activityType = .automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while requesting new coordinates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.02)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
      //  map.setRegion(region, animated: true)
      //  self.map.showsUserLocation = true
        location1.latitude = location.coordinate.latitude
        location1.longitude = location.coordinate.longitude
        print(location1.latitude)
        print(location1.longitude)
        
       /*let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        f+=1
        print("New Coordinates: \(f) ")
        print(self.latitude)
        print(self.longitude)*/
    }
    
   func bgtimer(_ timer:Timer!){
        sleep(1)
        /*  if UIApplication.shared.applicationState == .active {
         timer.invalidate()
         }*/
        self.updateLocation()
    }
    
    func updateLocation() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.stopUpdatingLocation()
    }
    
    
   

}

