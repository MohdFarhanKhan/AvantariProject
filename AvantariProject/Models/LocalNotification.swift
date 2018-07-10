//
//  LocalNotification.swift
//  AvantariProject
//
//  Created by Mohd Farhan Khan on 5/14/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//

import UIKit
import UserNotifications
class LocalNotification:NSObject, UNUserNotificationCenterDelegate{
    
    
    static let sharedInstance = LocalNotification()
    
    override init(){
        super.init()
        UNUserNotificationCenter.current().requestAuthorization(options:
            [[.alert, .sound, .badge]],
                                                                completionHandler: { (granted, error) in
                                                                    // Handle Error
        })
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    func setNotification(number: Int){
        let content = UNMutableNotificationContent()
        content.title = "Repeated Number: \(number)"
        content.badge = 1
        content.sound = UNNotificationSound.init(named: "lion2.wav")
        content.categoryIdentifier = "actionCategory"
        let imageName = "lion@3"
        let imageURL = Bundle.main.url(forResource: imageName, withExtension: "jpeg")
        if let imgURL = imageURL{
            let attachment = try! UNNotificationAttachment(identifier: imageName, url: imgURL, options: .none)
            
            content.attachments = [attachment]
        }
       
        
       
        //UNUserNotificationCenter.current().setNotificationCategories([category])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        
        let requestIdentifier = "demoNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
                                              
                                                // Handle error
        })
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        center.getPendingNotificationRequests { (notifications) in
            
            for item in notifications {
                center.removePendingNotificationRequests(withIdentifiers: [item.identifier])
                
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
    
    
}
