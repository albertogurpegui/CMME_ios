//
//  UIViewControllerExtension.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 20/03/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    func addNotificationMeeting(nameOfCreator: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = nameOfCreator + " ha creado una nueva cita"
        content.body = "Entra en la aplicacion, hay una nueva cita creada en tu cuenta"
        content.badge = 1
        content.sound = UNNotificationSound.default
                
        let date = Date(timeIntervalSinceNow: 5)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "CMME", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print(error as Any)
            }
        }
    }
    
    func addNotificationContact(nameOfCreator: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = nameOfCreator + " ha creado un nuev contacto"
        content.body = "Entra en la aplicacion, hay un nuevo contacto creado ya puedes hablar con el por el chat"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let date = Date(timeIntervalSinceNow: 5)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "CMME", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print(error as Any)
            }
        }
    }
}
