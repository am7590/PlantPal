//
//  AppDelegate.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/15/23.
//

import UIKit
import UserNotifications
import BRYXBanner

extension NSNotification {
    static let deepLink = Notification.Name.init("DeepLink")
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForRemoteNotification()
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        print("\(launchOptions)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            let banner = Banner(title: "launchOptions", subtitle: "\(launchOptions)", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 48.00/255.0, green: 174.0/255.0, blue: 51.5/255.0, alpha: 1.000))
            banner.dismissesOnTap = true
            banner.show(duration: 5.0)
            
            if let userActDic = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [String: Any] {
                print("%%% \(userActDic)")
                let banner = Banner(title: "userActDic", subtitle: "\(userActDic)", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 48.00/255.0, green: 174.0/255.0, blue: 51.5/255.0, alpha: 1.000))
                banner.dismissesOnTap = true
                banner.show(duration: 5.0)
                
                if let userActivity  = userActDic["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity {
                    print("%%% \(userActivity)")
                    
                    let banner = Banner(title: "userActivity", subtitle: "\(userActivity)", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 48.00/255.0, green: 174.0/255.0, blue: 51.5/255.0, alpha: 1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 5.0)
                }
                
                if let url = launchOptions?[.url] as? URL {
                    // TODO: handle URL from here
                    
                    let banner = Banner(title: "url", subtitle: "\(url)", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 48.00/255.0, green: 174.0/255.0, blue: 51.5/255.0, alpha: 1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 5.0)
                }
            }
        }
       
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let banner = Banner(title: "open url", subtitle: "\(url)", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 48.00/255.0, green: 174.0/255.0, blue: 51.5/255.0, alpha: 1.000))
        banner.dismissesOnTap = true
        banner.show(duration: 5.0)
        return true
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined()))")
        //self.sendDeviceTokenToServer(data: deviceToken)
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Womp womp")
    }
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        let banner = Banner(title: "userInfo", subtitle: "\(userInfo)", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 48.00/255.0, green: 174.0/255.0, blue: 51.5/255.0, alpha: 1.000))
        banner.dismissesOnTap = true
        banner.show(duration: 5.0)
        
        return .newData
    }
    

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["url"] as! [String : Any]
        print("%%% userInfo: \(userInfo)")
        print("%%% aps: \(aps)")
        
        NotificationCenter.default.post(name: NSNotification.deepLink, object: aps)
        
    }
    

    
    
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
//            let userInfo = notification.request.content.userInfo
//            let aps = userInfo["url"] as! [String : Any]
//
//            NotificationCenter.default.post(name: NSNotification.deepLink, object: aps)
//           // This line is NEEDED, otherwise push will not be fired
//           completionHandler([.alert, .badge, .sound]) // Display notification depending on your needed
//       }
    
}
