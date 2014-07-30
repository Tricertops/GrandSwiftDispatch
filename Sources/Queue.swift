
import Foundation


public typealias Queue = NSOperationQueue
public extension Queue {
    //MARK: Static instances
    public class var Main: Queue { return Queue.Global.Main }
    public class var Interactive: Queue { return Queue.Global.Interactive }
    public class var User: Queue { return Queue.Global.User }
    public class var Utility: Queue { return Queue.Global.Utility }
    public class var Background: Queue { return Queue.Global.Background }
    //TODO: Class variables once they are supported
    private struct Global {
        static let Main = NSOperationQueue.mainQueue()
        static let Interactive = Queue(quality: .UserInteractive, concurrent: Yes, adjective: "Global")
        static let User = Queue(quality: .UserInitiated, concurrent: Yes, adjective: "Global")
        static let Utility = Queue(quality: .Utility, concurrent: Yes, adjective: "Global")
        static let Background = Queue(quality: .Background, concurrent: Yes, adjective: "Global")
        static let all = [ Main, Interactive, User, Utility, Background ]
    }
    
    //MARK: Dynamic Instances
    public class var Current: Queue { return Queue.currentQueue() }
    
    //MARK: Creating
    public convenience init(quality: NSQualityOfService, concurrent: Bool, adjective: String) {
        self.init()
        self.qualityOfService = quality
        self.maxConcurrentOperationCount = concurrent ? NSOperationQueueDefaultMaxConcurrentOperationCount : 1
        self.name = adjective
    }
    
    
    //MARK: Description
    private class func nameOfQuality(quality: NSQualityOfService) -> String {
        switch quality {
        case .UserInteractive: return "Interactive"
        case .UserInitiated: return "User"
        case .Utility: return "Utility"
        case .Background: return "Background"
        default: return "Default"
        }
    }
    
    public override var description: String {
    var name = ""
        
        if self.name? && !self.name.hasPrefix("NSOperationQueue") {
            name += self.name + " "
        }
        else if Queue.Main == self {
            name += "Main "
        }
        name += Queue.nameOfQuality(self.qualityOfService)
        name += self.maxConcurrentOperationCount != 1 ? " Concurrent" : " Serial"
        name += " Queue"
        
        if Queue.Current == self {
            name += " (Current)"
        }
        //TODO: Inlude suspended state
        
        return name
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


