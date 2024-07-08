# iOS 为什么要废弃 dispatch_get_current_queue

`dispatch_get_current_queue` 是 Grand Central Dispatch (GCD) 中的一个旧接口，用于获取当前正在执行的队列。在 iOS 6 及以后版本，这个接口被废弃了，苹果建议开发者不要再使用它。这是为了避免一些潜在的问题和复杂性。下面是废弃该接口的原因和建议的替代方法。

### 为什么废弃 `dispatch_get_current_queue`

1. **死锁问题**：使用 `dispatch_get_current_queue` 增加了引发死锁的风险。特别是在使用同步（`dispatch_sync`）或类似操作时，偶尔会导致应用程序挂起或崩溃。例如，如果开发者不小心将一个同步任务派发给当前的串行队列，这会导致阻塞，进而导致死锁情况。

   ```objective-c
   dispatch_queue_t currentQueue = dispatch_get_current_queue();
   dispatch_sync(currentQueue, ^{
       // 死锁：队列等待自身完成
   });
   ```

2. **语义不明确**：`dispatch_get_current_queue` 可以在继承队列上下文时产生两层以上的嵌套，导致理解和调试变得困难。在复杂的并发操作中，获取当前队列的实际含义可能变得模糊，开发者容易误用，导致不可预料的行为。

3. **性能与兼容性**：引入这种接口的成本也超出了预期，在某些体系架构和实现上，需要额外的开销或引入不一致性。

### 替代方法

苹果建议开发者使用更加明确和安全的方法来实现同样的目标，而不是依赖 `dispatch_get_current_queue`。

#### 1. **使用适当的同步工具**

苹果推荐使用其他方式来确保代码的执行顺序和同步。如果需要确保任务在队列中顺序执行，可以使用 `dispatch_barrier_async`、`dispatch_sync` 和 GCD 的其他同步工具。

```objective-c
dispatch_queue_t queue = dispatch_queue_create("com.example.myqueue", DISPATCH_QUEUE_CONCURRENT);
dispatch_async(queue, ^{
    // 执行某个任务
});

dispatch_sync(queue, ^{
    // 同步执行任务，确保顺序
});
```

#### 2. **使用上下文对象**

对于较复杂的并发场景，可以使用上下文对象或标识来明确队列的作用和执行环境。

```objective-c
@interface MyClass : NSObject
@property (nonatomic, strong) dispatch_queue_t myQueue;
@end

@implementation MyClass
- (instancetype)init {
    self = [super init];
    if (self) {
        _myQueue = dispatch_queue_create("com.example.myqueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)doSomething {
    dispatch_async(self.myQueue, ^{
        // 执行某个任务
    });
}

- (void)doSomethingSync {
    dispatch_sync(self.myQueue, ^{
        // 同步执行任务
    });
}
@end
```

#### 3. **同一队列内同步操作**

在某些情况下，可以通过直接存储和引用队列，避免过多依赖“当前队列”的概念。在设计时界定队列的使用范围，确保唯一性和明确性。

### 总结

废弃 `dispatch_get_current_queue` 是苹果为了避免开发中的死锁问题与复杂性引入的决策。开发者应该使用更安全、明确的方法和同步工具来管理并发操作。例如，使用 `dispatch_sync`、`dispatch_async`、`dispatch_barrier_async` 等，确保代码更加健壮和可维护性。

替代方法使得并发编程的范围和行为更加明确，减少了潜在的风险，并提升了代码的稳定性和理解性。通过良好的设计和适当的工具选择，可以实现安全高效的并发操作，充分利用 GCD 带来的性能优势。
