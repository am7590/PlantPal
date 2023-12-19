//
//  AppDelegate.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/15/23.
//

import UIKit
import UserNotifications
import BRYXBanner
import os

// I could not get push notification handling working correctly with SwiftUI :(
class AppDelegate: NSObject, UIApplicationDelegate {
    
    public var payloadURL: [String: Any]? {
        didSet {
            if let url = oldValue, payloadURL == nil {
                // Bug fix: Need to delay by 1 second to avoid SucculentListView from being pushed first
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    NotificationCenter.default.post(name: NSNotification.deepLink, object: url)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Handle APNs permissions
        registerForRemoteNotification()
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Logger.plantPal.debug("\(#function) retrieved user's device token: \(token)")
        GRPCManager.shared.userDeviceToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.plantPal.error("\(#function) with error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .newData
    }
}

// MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

// MARK: Helpers
extension AppDelegate {
    func registerForRemoteNotification() {
        let center  = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error == nil{
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["url"] as! [String : Any]
        payloadURL = aps
    
    }
}
