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
    
    convenience init(name: String = "", concurrent: Bool = false, target: Queue = Background) {
        assert( !concurrent || target.isConcurrent, "Cannot create concurrent queue targetted to serial queue.")
        
        //TODO: Prefix name with application identifier?
        let underlaying = dispatch_queue_create("", (concurrent ? DISPATCH_QUEUE_CONCURRENT : DISPATCH_QUEUE_SERIAL))
        dispatch_set_target_queue(underlaying, target._underlaying)
        
        self.init(_name: name, _concurrent: concurrent, _underlaying: underlaying)
        self.target = target
        self._rootTarget = (target._rootTarget ? target._rootTarget : target)
    }
    
    func isTargettedTo(queue target: Queue) -> Bool {
        var queue: Queue? = self
        while queue? {
            if queue === target { return true }
            queue = queue?.target
        }
        return false
    }
    
    var isRoot: Bool { return self._rootTarget == nil }
    
    
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
    
    
    func wouldDeadlockWhileWaiting() -> Bool {
        return false
    }
    
    
    func perform(wait: Bool? = nil, barrier: Bool = false, closure: () -> ()) {
        assert( !barrier || !self.isRoot, "Cannot perform barrier block on root queue.")
        
        let wouldDeadlock = self.wouldDeadlockWhileWaiting()
        assert( !barrier || !wouldDeadlock, "Cannot perform barrier on deadlocking queue.")
        
        let invokeDirectly = (barrier == false && wouldDeadlock)
        // Missing `wait` argument means, we are allowed to invoke directly if that's better.
        let synchronous = (wait ? wait! : invokeDirectly)
        
        
        switch (synchronous, barrier) {
        case (false, false): dispatch_async(self._underlaying, closure)
        case (true, false): (invokeDirectly ? closure() : dispatch_sync(self._underlaying, closure))
        case (false, true): dispatch_barrier_async(self._underlaying, closure)
        case (true, true): dispatch_barrier_sync(self._underlaying, closure)
        default: break;
        }
    }
    
    func perform(after delay: NSTimeInterval, closure: () -> ()) {
        assert(delay >= 0)
        
        let nanoseconds = Int64(delay * NSTimeInterval(NSEC_PER_SEC))
        let time = dispatch_time(DISPATCH_TIME_NOW, nanoseconds)
        dispatch_after(time, self._underlaying, closure)
    }
    
    func perform(times count: UInt, closure: (UInt) -> ()) {
        dispatch_apply(count, self._underlaying, closure)
    }
    
    func perform(times count: UInt, closure: () -> ()) {
        dispatch_apply(count, self._underlaying, { i in closure() })
    }
    
}

