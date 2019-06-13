//
//  AppDelegate.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 21/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var mainNavigationController : UINavigationController!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Firebase.sharedInstance.initFireBase()
        
        /*let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (success, error) in
            if error == nil {
                print("Success")
                self.Notifications()
            }
        }*/
        let center = UNUserNotificationCenter.current()
        
        let options: UNAuthorizationOptions = [.sound, .alert]
        
        center.requestAuthorization(options: options) { (granted, error) in
            if error != nil {
                print(error as Any)
            }
        }
        
        center.delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            Firebase.sharedInstance.user = Auth.auth().currentUser
            if Auth.auth().currentUser == nil{
                let mainVC = MainViewController(type: false)
                mainNavigationController = UINavigationController(rootViewController: mainVC)
                mainNavigationController.setNavigationBarHidden(true, animated: false)
                window.rootViewController = mainNavigationController
                window.makeKeyAndVisible()
            }else {
                Firebase.sharedInstance.knowTypeOfUserAutoLogging { (typeUser) in
                    let storyboard = UIStoryboard(name: "MainNavigation", bundle: nil)
                    let controller: ContainerNavigationController = storyboard.instantiateViewController(withIdentifier: "ContainerNavigationController") as! ContainerNavigationController
                    ContainerNavigationController.userType = typeUser
                    window.rootViewController = controller
                    window.makeKeyAndVisible()
                }
            }
        }
        return true
    }
    
    /*func Notifications() {
        let content = UNMutableNotificationContent()
        content.title = "Nueva notificacion en tu apllicacion CMME"
        content.body = "Entra en la aplicacion, hay una novedad en tu cuenta"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "CMME", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }*/
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

