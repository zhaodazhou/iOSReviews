# GCD 的队列（dispatch_queue_t）分哪两种类型

在 iOS 和 macOS 开发中，GCD（Grand Central Dispatch）是一个强大的并发编程框架，用于管理多线程操作。GCD 的核心概念之一是队列（`dispatch_queue_t`），它负责调度任务并在适当的线程上执行这些任务。队列主要分为两种类型：**串行队列（Serial Queue）** 和 **并发队列（Concurrent Queue）**。

### 1. 串行队列（Serial Queue）

串行队列中的任务按照添加顺序一个接一个地执行。同一时间，串行队列只会执行一个任务，这意味着下一个任务必须等待前一个任务完成。

**特性**：

- 同一时间只能执行一个任务。
- 保证任务按添加顺序依次执行。
- 使用场景：确保任务按特定顺序执行，避免数据竞争。

**创建并使用串行队列**：
你可以通过 `dispatch_queue_create` 来创建一个串行队列。

```objective-c
dispatch_queue_t serialQueue = dispatch_queue_create("com.example.serialQueue", DISPATCH_QUEUE_SERIAL);

// 添加任务到串行队列
dispatch_async(serialQueue, ^{
    NSLog(@"Task 1");
});

dispatch_async(serialQueue, ^{
    NSLog(@"Task 2");
});
```

### 2. 并发队列（Concurrent Queue）

并发队列中的任务可以并发执行，这意味着队列可以同时调度多个任务，并让它们分别在不同的线程中并行处理，而不必等待之前的任务完成。

**特性**：

- 可以同时执行多个任务。
- 任务的开始时间和完成时间是不可预测的，基于系统的调度和资源的可用性。
- 使用场景：高性能计算，多个不依赖任务的并行执行。

**全局并发队列**：
GCD 提供了一些全局并发队列，可以通过 `dispatch_get_global_queue` 获取。而不需要显式地创建。如果需要创建自定义的并发队列，也可以使用 `dispatch_queue_create`。

**使用全局并发队列**：

```objective-c
dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

// 添加任务到并发队列
dispatch_async(globalQueue, ^{
    NSLog(@"Concurrent Task 1");
});

dispatch_async(globalQueue, ^{
    NSLog(@"Concurrent Task 2");
});
```

**创建自定义并发队列**：

```objective-c
dispatch_queue_t concurrentQueue = dispatch_queue_create("com.example.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);

// 添加任务到并发队列
dispatch_async(concurrentQueue, ^{
    NSLog(@"Concurrent Task 1");
});

dispatch_async(concurrentQueue, ^{
    NSLog(@"Concurrent Task 2");
});
```

### 串行队列与并发队列的比较

1. **运行顺序**：
    - **串行队列**：任务按添加顺序顺序执行。
    - **并发队列**：任务可以并发执行，顺序不一定按添加顺序。

2. **执行的任务数**：
    - **串行队列**：同一时刻最多执行一个任务。
    - **并发队列**：同一时刻可以执行多个任务，具体数量由系统调度决定。

3. **使用场景**：
    - **串行队列**：适用于需要保证顺序执行的场景，如文件写入操作、数据库操作等。
    - **并发队列**：适用于需要并发执行、无序依赖的任务，如并行计算、网络请求并发处理等。

### 主队列（Main Queue）

除了自定义的串行队列和并发队列，GCD还提供了一个特殊的串行队列——主队列。主队列是与主线程关联的队列，用于执行需要更新UI的任务。所有添加到主队列上的任务都会在主线程上执行，因此可以保证线程安全地更新UI。

```objective-c
dispatch_queue_t mainQueue = dispatch_get_main_queue();

// 添加任务到主队列
dispatch_async(mainQueue, ^{
    // 在主线程上执行任务
    NSLog(@"Task on main queue");
});
```

### 总结

GCD 提供了两种主要类型的队列：

1. **串行队列（Serial Queue）**：任务按顺序一个接一个地执行，适用于需要顺序执行的任务。
2. **并发队列（Concurrent Queue）**：任务可以并发执行，适用于需要并行处理的任务。

通过合理使用串行队列和并发队列，可以利用多线程带来的性能优势，同时避免并发编程中的数据竞争和资源共享问题。这使得 GCD 成为 iOS 和 macOS 开发中管理并发任务的强大工具。
