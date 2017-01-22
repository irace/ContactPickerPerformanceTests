//
//  AppDelegate.swift
//  ContactPerformance
//
//  Created by Bryan Irace on 8/30/16.
//  Copyright © 2016 Bryan Irace. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().translucent = false

        return true
    }
}

