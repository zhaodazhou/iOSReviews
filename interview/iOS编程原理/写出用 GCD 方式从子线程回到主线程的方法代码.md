# 写出用 GCD 方式从子线程回到主线程的方法代码

在 iOS 开发中，多线程任务通常需要回到主线程来更新UI，因为UI更新必须在主线程上进行。Grand Central Dispatch (GCD) 提供了非常简洁和高效的方式来实现这一需求。

下面是一个使用 GCD 从子线程回到主线程的示例代码：

### 使用 GCD 在子线程执行任务并回到主线程更新UI

```objective-c
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 子线程中执行耗时任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 模拟一个网络请求或其他耗时操作
        [self performTimeConsumingTask];
        
        // 回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
    });
}

- (void)performTimeConsumingTask {
    // 模拟耗时操作
    [NSThread sleepForTimeInterval:2.0]; // 模拟耗时2秒
    NSLog(@"耗时任务完成");
}

- (void)updateUI {
    // 更新UI
    NSLog(@"更新 UI");
    self.view.backgroundColor = [UIColor blueColor];
}

@end
```

### 解释

1. **`dispatch_get_global_queue`**：
   - 用于获取全局并发队列。在这里，`DISPATCH_QUEUE_PRIORITY_DEFAULT` 表示任务的优先级是默认的，最后的参数通常为0。

2. **`dispatch_async`**：
   - 异步执行代码块。第一次调用 `dispatch_async` 用于将耗时任务放在后台线程中执行。
   - 第二次调用 `dispatch_async` 用于将更新UI的任务放在主线程的队列中执行。

3. **耗时的任务**：
   - `performTimeConsumingTask` 模拟了一个耗时任务，例如网络请求或文件处理。这里使用 `NSThread` 的 `sleepForTimeInterval:` 方法来模拟耗时操作。

4. **更新UI**：
   - `updateUI` 方法用于在主线程上更新UI。在主线程上调用 `dispatch_async(dispatch_get_main_queue(), ^{ ... })` 确保了UI操作在主线程上执行，避免了线程安全问题。

### 核心的 GCD 代码

以下是核心部分的 GCD 代码，用于在子线程执行任务并回到主线程更新UI：

```objective-c
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 子线程中的任务
    [self performTimeConsumingTask];
    
    // 回到主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI];
    });
});
```

### 总结

使用 GCD 在子线程执行任务并回到主线程更新UI是 iOS 开发中常见的需求。通过 `dispatch_async` 函数，将耗时任务放在后台全局队列中执行，而在任务完成后，将UI更新操作放在主线程的队列中执行，确保UI操作的线程安全性和应用的流畅性。这种方法不仅简洁高效，还能很好地管理并发任务和UI更新。
