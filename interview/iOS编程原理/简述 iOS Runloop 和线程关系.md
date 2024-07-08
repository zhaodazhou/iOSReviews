# 简述 iOS Runloop 和线程关系

在 iOS 开发中，Run Loop 和线程是两个紧密相关的概念。Run Loop 是一种循环机制，用于处理事件和消息，保持线程的活跃状态。它在每次循环中检查事件源，并调用适当的处理函数来响应这些事件。线程是操作系统管理任务调度的基本单位，而 Run Loop 则是线程内部用于管理事件和消息处理的工具。

下面是对 iOS 中 Run Loop 和线程关系的详细解释：

### Run Loop 的基本概念

Run Loop 是一个事件处理循环，它在后台不断运行，接收输入事件（如触摸、定时器、网络事件）并将其分派给目标对象进行处理。一个线程（特别是主线程）通过 Run Loop 来保持活跃状态并处理各种事件。

### 线程和 Run Loop 的关系

#### 1. 主线程和 Run Loop

主线程是应用程序的入口点，负责所有 UI 和用户交互。在主线程中，系统会自动为我们配置并启动一个 Run Loop，这个 Run Loop 在整个应用程序的生命周期中都保持运行状态。

主线程 Run Loop 的主要任务是响应用户的触摸事件、定时器、输入源以及其他作为事件源的输入。

#### 2. 子线程和 Run Loop

所有的子线程默认情况下是没有运行 Run Loop 的。如果需要在子线程中使用 Run Loop（例如，处理定时器或端口事件），则需要手动启动 Run Loop。

在子线程中启动 Run Loop 的代码如下：

```objective-c
- (void)startRunLoopOnThread {
    // 获取当前线程的 Run Loop
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

    // 添加输入源或定时器
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];

    // 启动 Run Loop
    [runLoop run];
}
```

### Run Loop 的模式

Run Loop 有多种运行模式，每种模式用于特定类型的事件处理。常见的模式包括：

- **NSDefaultRunLoopMode**：标准事件处理模式。
- **UITrackingRunLoopMode**：用于处理 UI 跟踪事件（如滚动视图的跟踪触摸）。
- **NSRunLoopCommonModes**：为常见的运行模式设置的占位符，可同时处理几个不同模式下的事件。

### Run Loop 的工作机制

每个 Run Loop 都有一个输入源和定时源集合。输入源主要用于处理异步事件，如用户输入、网络请求等。定时源用于处理基于时间的任务（NSTimer）。

Run Loop 的大致工作流程如下：

1. 通知观察者 Run Loop 即将进入循环。
2. 通知观察者 Run Loop 即将处理定时器事件。
3. 通知观察者 Run Loop 将要处理输入源事件。
4. 处理实际输入源事件。
5. 通知观察者 Run Loop 将要休眠。
6. 进入休眠状态，等待事件触发。
7. 事件触发时唤醒，处理事件。
8. 通知观察者 Run Loop 即将退出循环。

### 示例：创建和管理子线程 Run Loop

下面是一个完整的示例，展示了如何创建一个在子线程上运行的 Run Loop，并使用一个定时器：

```objective-c
@interface MyClass : NSObject
@property (strong, nonatomic) NSThread *workerThread;
- (void)startWorkerThread;
@end

@implementation MyClass

- (void)startWorkerThread {
    self.workerThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMain) object:nil];
    [self.workerThread start];
}

- (void)threadMain {
    @autoreleasepool {
        // 添加一个输入源来阻止 Run Loop 退出
        NSPort *port = [NSPort port];
        [[NSRunLoop currentRunLoop] addPort:port forMode:NSDefaultRunLoopMode];

        // 创建一个定时器，并在 Run Loop 中循环
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(timerFired)
                                               userInfo:nil
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        // 启动 Run Loop
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)timerFired {
    NSLog(@"Timer fired on worker thread");
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        MyClass *myObject = [[MyClass alloc] init];
        [myObject startWorkerThread];
        
        [[NSRunLoop currentRunLoop] run];
    }
}
```

在这个示例中：

1. 创建了一个新的 `NSThread` 对象，并启动线程。
2. 在子线程的主函数中，添加了一个输入源（端口）和一个定时器到 Run Loop 中，以保持 Run Loop 活跃。
3. 通过 `[[NSRunLoop currentRunLoop] run]` 启动 Run Loop。

### 总结

- **主线程**：系统自动为主线程配置并启动一个 Run Loop，负责处理所有 UI 和用户交互事件。
- **子线程**：默认没有 Run Loop，需要手动启动。通过启动 Run Loop，子线程可以处理定时器、端口和其他事件。

Run Loop 和线程的有效结合，可以确保应用程序在多线程环境下高效、稳定地处理各种事件和任务。理解二者的关系，有助于开发出高性能、响应迅速的 iOS 应用。
