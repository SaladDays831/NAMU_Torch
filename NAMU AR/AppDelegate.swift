//
//  AppDelegate.swift
//  NAMU_Torch
//
//  Created by Danil Kurilo on 9/9/19.
//  Copyright © 2019 Danil Kurilo. All rights reserved.
//

import UIKit
import TorchKit
import os

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        do {
            try TorchKit.shared.initSDK(apiKey: "djIucHVibGljLmV5SndjbTkwYnlJNklrTkJSVk5JUjNCTlVURnJlRmRZYkVaT2JXUlRVVlJrUlZGV2FFMVNSM1JRVlZSSmVtUnJWa3ROVkVsaFJFRnFjaTlrY25KQ1VrTkJNRzlITlVGVFNWTkRhRUpDUm1wTWQyMXVlVVZ5U1Vwa1F6WkdZbEpQVjIwaWZjVHVrTXV5cmZHY2VBS21QQVFEajdmdVlYUVhQaFgtTUlpbzR4OWRwV1gtYTlKdHVjaVRJRUZFLW5ORlhnb2JhYzdPVm1vV2Zra0Eyc2d3MlVvTVBBQQ==")
        } catch {
            os_log(OSLogType.default, "Init failed!")
        }
        
        

        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        TorchKit.shared.shutdownSDK()
        
    }


}

