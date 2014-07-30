//
//  AppDelegate.swift
//  GSD Try App
//
//  Created by Martin Kiss on 7.7.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

import UIKit
import GrandSwiftDispatch

let Yes = true
let No = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.rootViewController = UIViewController()
        self.window!.makeKeyAndVisible()
        
        
        let queue = Queue(quality: .Utility)

        queue.perform {
            NSLog("Simple")
        }
        
        queue.perform(wait: true) {
            NSLog("Waiting")
        }
        
//        queue.perform(after: 2) {
//            NSLog("Delay")
//        }
//        
//        queue.perform(times: 5) {
//            NSLog("Multiple")
//        }
//        
//        queue.perform {
//            // Task
//            Queue.main.perform {
//                // Callback
//            }
//        }
        
        
        return true
    }
}

