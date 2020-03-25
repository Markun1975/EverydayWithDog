//
//  AppDelegate.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import FirebaseFirestore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //Google Maps API KEY
//    AIzaSyCS7kLJtFqXRvd_KpY16-_tfcXMmmv0Z3k
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let db = Firestore.firestore()
               // [END default_firestore]
        print(db) // silence warning
        //下記GoogleMap認証
        GMSServices.provideAPIKey("AIzaSyCS7kLJtFqXRvd_KpY16-_tfcXMmmv0Z3k")
        GMSPlacesClient.provideAPIKey("AIzaSyCS7kLJtFqXRvd_KpY16-_tfcXMmmv0Z3k")
        return true
    }
    
    //FBログインに使うことっぽいので保留
//    func application(_ application: UIApplication,open url: URL, sourceApplication: String?,annotation: Any) -> Bool {
//        return
//            UIApplicationDelegate.shar.shard.application(application, open: url, sourceApplication: sourceApplication,annotation: annotation)
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        AppEvent
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    


}

