# Objective-C 开发中，对象什么情况下在堆上，什么情况下在栈上

在 Objective-C 中，对象通常在堆上分配内存，而基本数据类型（如 `int`、`float`、`char` 等）和结构体在栈上分配内存。

**对象在堆上分配的情况：**

1. 使用 `alloc`、`new`、`copy`、`mutableCopy` 方法创建的对象：
   - 例如 `NSObject *obj = [[NSObject alloc] init];`，这里 `obj` 指向的对象在堆上分配内存。

2. 通过方法返回的对象（如果不是自动释放池管理且没有明确在栈上创建）：
   - 例如很多 Cocoa 框架中的方法返回的对象都是在堆上分配的。

**对象不在堆上而可能在栈上（自动释放池场景）的情况：**

1. 使用字面量语法创建某些对象时，会在自动释放池中短暂存在，从某种意义上也可以认为在“类似栈”的自动释放池管理区域：
   - 例如 `NSArray *array = @[@"a", @"b"];`，这个数组对象在自动释放池中，在当前运行循环结束或自动释放池被释放时，如果没有被其他强引用持有，就会被释放。

需要注意的是，Objective-C 中的自动释放池是一种延迟释放对象的机制，它并不是严格意义上的栈，但在对象生命周期管理方面有类似栈的作用（后进先出的释放顺序）。

一般来说，开发者需要关注对象的内存管理，确保正确地使用 `retain`、`release`、`autorelease` 和现代的自动引用计数（ARC）机制来管理对象的生命周期，以避免内存泄漏和过度释放等问题。
