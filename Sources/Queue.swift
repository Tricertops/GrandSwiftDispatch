//
//  Queue.swift
//  Grand Swift Dispatch
//
//  Created by Martin Kiss on 7.7.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

import Foundation



//TODO: QOS classes from iOS 8 and OS X 10.10

typealias Queue = NSOperationQueue
extension Queue {
    
    convenience init(name: String, concurrent: Bool) {
        self.init()
    }
    
    class var main: Queue { return Queue.mainQueue()! }
    class var current: Queue { return Queue.currentQueue()! }
    
    
    func perform(wait: Bool? = nil, barrier: Bool = false, closure: () -> ()) {
        
        let wouldDeadlock = (self == Queue.current)
        assert( !barrier || !wouldDeadlock, "Cannot perform barrier on deadlocking queue.")

        let invokeDirectly = (barrier == false && wouldDeadlock)
        // Missing `wait` argument means, we are allowed to invoke directly if that's better.
        let synchronous = (wait ? wait! : invokeDirectly)
        
        switch (synchronous, barrier) {
        case (false, false): dispatch_async(self.underlyingQueue, closure)
        case (true, false): (invokeDirectly ? closure() : dispatch_sync(self.underlyingQueue, closure))
        case (false, true): dispatch_barrier_async(self.underlyingQueue, closure)
        case (true, true): dispatch_barrier_sync(self.underlyingQueue, closure)
        default: break;
        }
    }
    
    func perform(after delay: NSTimeInterval, closure: () -> ()) {
        assert(delay >= 0)
        
        let nanoseconds = Int64(delay * NSTimeInterval(NSEC_PER_SEC))
        let time = dispatch_time(DISPATCH_TIME_NOW, nanoseconds)
        dispatch_after(time, self.underlyingQueue, closure)
    }
    
    func perform(times count: UInt, indexedClosure: (UInt) -> ()) {
        assert(self != Queue.current)
        dispatch_apply(count, self.underlyingQueue, indexedClosure)
    }
    
    func perform(times count: UInt, closure: () -> ()) {
        assert(self != Queue.current)
        dispatch_apply(count, self.underlyingQueue, { i in closure() })
    }
    
}

