Grand Swift Dispatch
==================

Provides simple way to **create and use** NSOperationQueues in Swift.


## Types
  - **NSOperationQueue** is simply typealiased to **Queue** to save keystrokes.


## Accessing Queues
  - **Main Queue** is accessible via `Queue.Main`
  - **Current** queue is accessible via `Queue.Current`
  - There is shared queue for each *Quality of Service*:
    - User **Interactive** operations via `Queue.Interactive`
    - **User** Initiated operations via `Queue.User`
    - **Utility** operations via `Queue.Utility`
    - **Background** operations via `Queue.Background`


## Simple Perform
  - There is a single method name **`perform`**:
    
    ```swift
    Queue.Utility.perform {
        // Work
        Queue.Main.perform {
            // Callback
        }
    }
    ```

  - Optional argument for **waiting**:
    
    ```swift
    Queue.Utility.perform(wait: Yes) {
        // Synchronous
    }
    ```
    
  - Optional **delay** argument:
    
    ```swift
    Queue.Utility.perform(delay: 1.5) {
        // Delayed
    }
    ```


## No Direct Deadlock
Waiting for operation on current queue **doesn't** create deadlock. The operation is invoked directly and is not even scheduled:
    
```swift
Queue.Current.perform(wait: Yes) {
    // Directly invoked
}
```

  - Will not prevent **all** deadlocks, only **direct** ones.


## Smart Waiting
When no `wait:` argument is given and you are targetting current queue, the operation is also invoked **directly**:

```swift
// On Main Queue

Queue.Main.perform {
    // Directly invoked
}
```

  - The operation is invoked by the **desired** queue.
  - Doesn't **break** your call stack.
  - Provide explicit `wait: No` to **opt-out**.
    

## Initializer
Convenience initializer that specifies Quality of Service and concurrency:

```swift
let queue = Queue(quality: .Utility, concurrent: No, adjective: "Processing")
```


## Description
Generated description for each Queue instance:

```swift
println(Queue.Main) // Main Interactive Serial Queue (Current)
println(Queue.Background) // Global Background Concurrent Queue
println(queue) // Processing Utility Serial Queue
```

