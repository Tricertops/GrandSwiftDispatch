Grand Swift Dispatch
==================
---

**Important:** Due to a bug in iOS 8, nothing you see here really works! **Yet.**

---

Provides simple way to create and use GCD queues in Swift.

```swift
let queue = Queue(concurrent: true)

queue.perform {
    NSLog("Simple")
}

queue.perform(wait: true) {
    NSLog("Waiting")
}

queue.perform(barrier: true) {
    NSLog("Barrier")
}

queue.perform(after: 2) {
    NSLog("Delay")
}

queue.perform(times: 5) {
    NSLog("Multiple")
}

queue.perform {
    // Task
    Queue.main.perform {
        // Callback
    }
}

```


