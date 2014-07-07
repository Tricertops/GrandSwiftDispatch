//
//  Queue.swift
//  Grand Swift Dispatch
//
//  Created by Martin Kiss on 7.7.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

import Foundation


//TODO: Move inside class once it is supported by compiler
let Main = Queue(
    _name: "Main",
    _concurrent: false,
    _underlaying: dispatch_get_main_queue())

let Background = Queue(
    _name: "Background",
    _concurrent: true,
    _underlaying: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))

//TODO: QOS classes from iOS 8 and OS X 10.10

class Queue {
    let name: String
    let isConcurrent: Bool
    let target: Queue?
    
    convenience init(name: String = "", concurrent: Bool = true, target: Queue = Background) {
        assert(concurrent && !target.isConcurrent, "Cannot create concurrent queue targetted to serial queue.")
        
        //TODO: Prefix name with application identifier?
        let underlaying = dispatch_queue_create("", (concurrent ? DISPATCH_QUEUE_CONCURRENT : DISPATCH_QUEUE_SERIAL))
        dispatch_set_target_queue(underlaying, target._underlaying)
        
        self.init(_name: name, _concurrent: concurrent, _underlaying: underlaying)
        self.target = target
        self._rootTarget = target._rootTarget
    }
    
    func isTargettedTo(queue target: Queue) -> Bool {
        var queue: Queue? = self
        while queue? {
            if queue === target { return true }
            queue = queue?.target
        }
        return false
    }
    
    
    let _underlaying: dispatch_queue_t
    let _rootTarget: Queue?
    
    init(_name: String, _concurrent: Bool, _underlaying: dispatch_queue_t) {
        self.name = _name
        self.isConcurrent = _concurrent
        self._underlaying = _underlaying
        //TODO: Set specific key
    }
    
    class var current: Queue? {
        //TODO: Get specific key
    return nil
    }
    
    
}

