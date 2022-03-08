//
//  AppDelegate.swift
//  Slap the egg
//
//  Created by Pablo Penas on 24/02/22.
//

import UIKit
import OneSignal
import Firebase
import AppTrackingTransparency
import AdSupport
import FBSDKCoreKit


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        // OneSignal initialization
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("024699ce-e727-4a7c-b351-6f0190043e37")
        
        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Set your customer userId
        // OneSignal.setExternalUserId("userId")
        
        // Firebase
        FirebaseApp.configure()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.requestDataPermission()
            print("oh yeah")
        }
        
        ApplicationDelegate.shared.application(
                            application,
                            didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        requestDataPermission()
        print("oh yeah")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        requestDataPermission()
        print("ativou")
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
//
    // Remaining contents of your AppDelegate Class...
    func requestDataPermission() {
        print("\n\nRequestDataPermission\n\n\n")
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
//                    Settings.setAdvertiserTrackingEnabled(true)
                    Settings.shared.isAdvertiserTrackingEnabled = true
                    Settings.shared.isAutoLogAppEventsEnabled = true
                    Settings.shared.isAdvertiserIDCollectionEnabled = true
                    Analytics.setUserProperty("true",
                                              forName: AnalyticsUserPropertyAllowAdPersonalizationSignals)
                    Analytics.setAnalyticsCollectionEnabled(true)
                    print("Authorized")
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    
//                    Settings.setAdvertiserTrackingEnabled(false)
                    Settings.shared.isAdvertiserTrackingEnabled = false
                    Settings.shared.isAutoLogAppEventsEnabled = false
                    Settings.shared.isAdvertiserIDCollectionEnabled = false
                    Analytics.setUserProperty("false",
                                              forName: AnalyticsUserPropertyAllowAdPersonalizationSignals)
                    Analytics.setAnalyticsCollectionEnabled(false)
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            })
        } else {
            //you got permission to track, iOS 14 is not yet installed
        }
    }
}
