# 简述 iOS runloop 的 mode 作用

在 iOS 中，`Run Loop` 是一种循环机制，用于处理输入事件（如触摸事件、定时器、网络事件等），并在没有事件时进入休眠状态以节省资源。`Run Loop` 的一个重要特性是其运行模式（mode），它决定了 `Run Loop` 应该处理哪些事件源。使用模式可以使得 `Run Loop` 在不同场合下只处理特定类型的事件，从而避免不必要的开销和混乱。

### Run Loop Mode 的基本概念

每个 `Run Loop` 都可以运行在不同的模式下，不同的模式控制着 `Run Loop` 只能处理特定类型的事件。例如，当 `Run Loop` 处于某个特定模式时，只会响应该模式下注册的事件源，而忽略其他模式下注册的事件源。

### 常见的 Run Loop Mode

iOS 中常见的 `Run Loop Mode` 包括：

1. **`NSDefaultRunLoopMode`**：默认模式，处理一般的输入源，包括触摸事件和其他常见事件。
2. **`UITrackingRunLoopMode`**：用于处理 UI 跟踪事件，比如滚动视图的滚动事件。在此模式下，其他非跟踪事件将不会被处理。
3. **`NSRunLoopCommonModes`**：这是一个伪模式，表示多个运行模式的集合。如默认模式和跟踪模式的结合。将事件源添加到 `NSRunLoopCommonModes` 中，可以确保在多个模式下其事件能够被处理。

### Run Loop Mode 的作用和使用场景

使用 `Run Loop Mode` 可以帮助我们更好地控制事件处理的优先级和顺序，避免事件处理中的相互干扰。以下是几个常见的使用场景：

#### 1. 执行耗时操作时避免阻塞 UI

在一个耗时操作的过程中，我们可能希望 `Run Loop` 只处理特定的事件，而不处理其他事件，以保持操作的顺畅性。

```objective-c
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 在一个后台线程执行耗时操作
    while (condition) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
});
```

#### 2. 保持滚动性能

在处理滚动视图事件时，我们希望 `Run Loop` 只处理与滚动相关的事件，以确保滚动的平滑性和流畅性。

```objective-c
UIScrollView *scrollView = ...; // 假设我们有一个滚动视图

[scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}
```

#### 3. 将输入源添加到 Common 模式

当我们希望某个输入源在多种模式下都能被处理时，可以将其添加到 `NSRunLoopCommonModes`。

```objective-c
NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
```

### 实践示例

假设我们有一个场景，需要在滚动视图滚动时运行某个重复任务（例如更新UI），但希望在滚动停止后继续执行该任务而不受滚动影响：

```objective-c
@interface ViewController : UIViewController
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 2);
    [self.view addSubview:scrollView];
    
    // 定时器每秒触发一次，用于更新UI或处理其他任务
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    
    // 将定时器添加到 Common 模式，这样它在默认和跟踪模式下都能够运行
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateUI {
    NSLog(@"Updating UI...");
}

@end
```

在这个示例中：

1. 创建了一个 `NSTimer`，每隔一秒触发一次 `updateUI` 方法。
2. 将定时器添加到 `NSRunLoopCommonModes` 下，使其在默认模式和UI跟踪模式（滚动视图滚动时）下都能够正常运行。

### 总结

`Run Loop Mode` 在 iOS 中主要用于控制 `Run Loop` 在特定的模式下只处理特定类型的事件，以便优化应用的性能和响应速度。通过合理配置和使用 `Run Loop Mode`，可以确保应用在处理复杂任务时仍然保持良好的用户体验和高效的事件处理。了解和掌握 `Run Loop Mode` 的使用，对于开发高性能的 iOS 应用程序具有重要意义。
