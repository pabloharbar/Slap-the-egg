//
//  AppDelegate.swift
//  Slap the egg
//
//  Created by Pablo Penas on 24/02/22.
//

import UIKit
import OneSignal
import Firebase

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
        return true
    }
    
    // Remaining contents of your AppDelegate Class...
}


//import SwiftUI
//import Firebase
//import UserNotifications
//
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    let gcmMessageIDKey = "gcm.message_id"
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//
//        Messaging.messaging().delegate = self
//
//        if #available(iOS 10.0, *) {
//          // For iOS 10 display notification (sent via APNS)
//          UNUserNotificationCenter.current().delegate = self
//
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//          UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {_, _ in })
//        } else {
//          let settings: UIUserNotificationSettings =
//          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//        return true
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//      }
//
//      print(userInfo)
//
//      completionHandler(UIBackgroundFetchResult.newData)
//    }
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//
//      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
//        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
//    }
//    
//    // Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//      let userInfo = notification.request.content.userInfo
//
//      if let messageID = userInfo[gcmMessageIDKey] {
//          print("Message ID: \(messageID)")
//      }
//
//      print(userInfo)
//
//      // Change this to your preferred presentation option
//      completionHandler([[.banner, .badge, .sound]])
//    }
//
//      func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//      }
//
//      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//
//      }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//      let userInfo = response.notification.request.content.userInfo
//
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID from userNotificationCenter didReceive: \(messageID)")
//      }
//
//      print(userInfo)
//
//      completionHandler()
//    }
//}
