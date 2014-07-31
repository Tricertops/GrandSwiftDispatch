Grand Swift Dispatch
==================


Provides simple way to create and use NSOperationQueues in Swift.

```swift
let queue = Queue(quality: .Utility, concurrent: No)

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
    // Work
    Queue.Main.perform {
        // Callback
    }
}
```

