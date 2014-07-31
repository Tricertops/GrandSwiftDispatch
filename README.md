Grand Swift Dispatch
==================


Provides simple way to create and use NSOperationQueues in Swift.

Features
--------

### Types
  - **NSOperationQueue** is simply typealiased to **Queue** to save keystrokes.

### Accessing Queues
  - **Main Queue** is accessible via `Queue.Main`
  - **Current** queue is accessible via `Queue.Current`
  - There is shared queue for each *Quality of Service*:
    - User **Interactive** operations via `Queue.Interactive`
    - **User** Initiated operations via `Queue.User`
    - **Utility** operations via `Queue.Utility`
    - **Background** operations via `Queue.Background`

### Simple Perform
  - There is a single method name `perform`:
  
    ```swift
    Queue.Utility.perform {
        // Work
        Queue.Main.perform {
            // Callback
        }
    }
    ```

  - Optional argument for waiting:
  
    ```swift
    Queue.Utility.perform(wait: Yes) {
        // Synchronous
    }
    ```

  - Optional delay argument:
  
    ```swift
    Queue.Utility.perform(delay: 1.5) {
        // Delayed
    }
    ```

### Initializer
Convenience initializer that specifies Quality of Service and concurrency:

```swift
let queue = Queue(quality: .Utility, concurrent: No, adjective: "Processing")
```

### Description
Generated description for each Queue instance:

```swift
println(Queue.Main) // Main Interactive Serial Queue (Current)
println(Queue.Background) // Global Background Concurrent Queue
println(queue) // Processing Utility Serial Queue
```
