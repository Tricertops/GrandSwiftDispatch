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
            NSLog("Default")
        }
        
        queue.perform(wait: Yes) {
            NSLog("Synchronous")
        }
        
        queue.perform(wait: No) {
            NSLog("Asynchronous")
        }
        
        queue.perform(after: 1) {
            NSLog("Delayed")
        }
        
        
        queue.perform {
            // Task
            Queue.Main.perform {
                // Callback
            }
        }
        
        
        
        Queue.Main.perform(wait: Yes) {
            NSLog("No deadlock")
            // If target and current queues are the same, invoked block directly.
        }
        
        Queue.Main.perform {
            NSLog("Instant")
            // Invoked synchronously in place.
            // When no `wait` argument is given and you are targetting the current queue.
            // This prevents scheduling asynchronous blocks on the current thread and losing stack trace.
        }
        
        
        return true
    }
}

