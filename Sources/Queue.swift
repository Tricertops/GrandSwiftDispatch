//
//  Queue.swift
//  Grand Swift Dispatch
//
//  Created by Martin Kiss on 7.7.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

import Foundation


let Yes = true
let No = false



public class Queue : Printable, DebugPrintable {
    //MARK: Static instances
    public class var Main: Queue { return Queue.Singletons.Main }
    public class var Interactive: Queue { return Queue.Singletons.Interactive }
    public class var User: Queue { return Queue.Singletons.User }
    public class var Utility: Queue { return Queue.Singletons.Utility }
    public class var Background: Queue { return Queue.Singletons.Background }
    //TODO: Class variables once they are supported
    private struct Singletons {
        static let Main = Queue(underlying: NSOperationQueue.mainQueue())
        static let Interactive = Queue(quality: .UserInteractive, concurrent: Yes)
        static let User = Queue(quality: .UserInitiated, concurrent: Yes)
        static let Utility = Queue(quality: .Utility, concurrent: Yes)
        static let Background = Queue(quality: .Background, concurrent: Yes)
    }
    
    //MARK: Dynamic Instances
    public class var Current: Queue { return Queue(underlying: NSOperationQueue.currentQueue()) }
    
    //MARK: Properties
    public let name: String
    public var quality: NSQualityOfService { return underlying.qualityOfService }
    public var isConcurrent: Bool { return underlying.maxConcurrentOperationCount != 1 }
    
    
    //MARK: Underlying Queue
    private let underlying: NSOperationQueue
    
    private init(underlying: NSOperationQueue, var name: String = "") {
        self.underlying = underlying
        
        if name.isEmpty {
            name += Queue.nameOfQuality(quality)
            name += isConcurrent ? " Concurrent" : " Serial"
            name += " Queue"
        }
        self.name = name
    }
    
    public convenience init(quality: NSQualityOfService, concurrent: Bool = No, name: String = "") {
        let underlying = NSOperationQueue()
        underlying.qualityOfService = quality
        let max = NSOperationQueueDefaultMaxConcurrentOperationCount
        underlying.maxConcurrentOperationCount = concurrent ? max : 1
        self.init(underlying: underlying, name: name)
    }
    
    class func nameOfQuality(quality: NSQualityOfService) -> String {
        switch quality {
        case .UserInteractive: return "Interactive"
        case .UserInitiated: return "User"
        case .Utility: return "Utility"
        case .Background: return "Background"
        default: return "Unspecified"
        }
    }
    
    public var description: String {
    var description = self.name
        if Queue.Current == self {
            description = "Current " + description
        }
    return description
    }
    
    public var debugDescription: String {
    return description + " \(self.underlying)"
    }
    
//    func perform(wait: Bool? = nil, barrier: Bool = false, closure: () -> ()) {
//        
//        let wouldDeadlock = (self == Queue.current)
//        assert( !barrier || !wouldDeadlock, "Cannot perform barrier on deadlocking queue.")
//
//        let invokeDirectly = (barrier == false && wouldDeadlock)
//        // Missing `wait` argument means, we are allowed to invoke directly if that's better.
//        let synchronous = (wait ? wait! : invokeDirectly)
//        
//        switch (synchronous, barrier) {
//        case (false, false): dispatch_async(self.underlyingQueue, closure)
//        case (true, false): (invokeDirectly ? closure() : dispatch_sync(self.underlyingQueue, closure))
//        case (false, true): dispatch_barrier_async(self.underlyingQueue, closure)
//        case (true, true): dispatch_barrier_sync(self.underlyingQueue, closure)
//        default: break;
//        }
//    }
//    
//    func perform(after delay: NSTimeInterval, closure: () -> ()) {
//        assert(delay >= 0)
//        
//        let nanoseconds = Int64(delay * NSTimeInterval(NSEC_PER_SEC))
//        let time = dispatch_time(DISPATCH_TIME_NOW, nanoseconds)
//        dispatch_after(time, self.underlyingQueue, closure)
//    }
//    
//    func perform(times count: UInt, indexedClosure: (UInt) -> ()) {
//        assert(self != Queue.current)
//        dispatch_apply(count, self.underlyingQueue, indexedClosure)
//    }
//    
//    func perform(times count: UInt, closure: () -> ()) {
//        assert(self != Queue.current)
//        dispatch_apply(count, self.underlyingQueue, { i in closure() })
//    }
    
}


func == (left: Queue, right: Queue) -> Bool {
    return left.underlying === right.underlying
}

