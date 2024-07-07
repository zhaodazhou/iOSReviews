# iOS runtime 如何实现 weak 属性

在 iOS 的 Objective-C 中，`weak` 属性用于引用一个对象，但不会增加其引用计数，从而避免了对象间的循环引用。实现这一机制的关键是 Objective-C 运行时（runtime）。要理解 `weak` 属性的实现，首先需要了解一些运行时的基本概念和工作方式。

### 基本概念

- **弱引用**：指向对象但不持有它，这意味着对象的生命周期不会因为有弱引用指向它而被延长。当对象被销毁时，所有指向它的弱引用都会被自动设置为 `nil`。
- **弱引用表（Weak Reference Table）**：存储所有弱引用。其主要目的是在对象销毁时，可以方便地找到所有指向该对象的弱引用，并将其设置为 `nil`。

### 运行时实现

#### 1. **weak 属性的生命周期管理**

当声明一个 `weak` 属性时，Objective-C 运行时会在相应对象的引用计数系统中进行一些特殊处理。这个过程包括创建和销毁 `weak` 引用时的操作。

#### 2. **初始化 weak 引用**

当 `weak` 属性第一次被赋值时，Objective-C 运行时会调用 `objc_storeWeak` 函数。

```objective-c
__weak MyClass *weakObject = strongObject;
```

`objc_storeWeak` 会执行以下步骤：

1. 如果传入的 `value` 为非 `nil`
   - 查找（或者插入）弱引用表中是否已有与 `value` 对应的条目。
   - 创建一个新的 `WeakEntry` 结构体，其中包含指向 `value` 的所有弱引用的数组。
   - 将当前的 `weak` 指针（如 `&weakObject`）添加到这个结构体中。
2. 如果传入的 `value` 为 `nil`：
   - 将当前的 `weak` 指针设为 `nil`。

#### 3. **弱引用表管理**

弱引用表是一个全局哈希表，其键为对象的地址，值为指向该对象的所有弱引用的数组。其目的是，当某个对象被销毁时，能够快速找到并更新所有指向该对象的弱引用。

#### 4. **对象销毁时更新弱引用**

当强引用计数达到 0 时，对象将被销毁。在销毁对象的过程中，运行时会执行以下步骤：

1. 查找弱引用表，找到所有指向该对象的弱引用。
2. 遍历这些弱引用，并将它们设置为 `nil`。
3. 从弱引用表中移除该对象的条目。

具体流程：

- 当执行 `-[NSObject dealloc]` 的时候，会调用 `objc_release` 函数。
- 在 `objc_release` 中，当对象的引用计数为 0 时，系统会调用 `dealloc` 方法，然后 `dealloc` 方法会调用 `object_dispose` 进行实际的资源清理。
- `object_dispose` 方法内部会调用 `objc_destructInstance`，这个方法会处理弱引用：

```c
void objc_destructInstance(id obj) {
    // 清理弱引用
    strongRefWork(obj);
    weak_cleanup_no_lock(obj);
    // ...
}
```

- `weak_cleanup_no_lock` 是核心部分，它会通过查找弱引用表，找到指向当前对象的所有弱引用地址，然后将它们设置为 `nil`。

### 实际示例

假设我们有如下的 `MyClass` 实现和使用：

```objective-c
@interface MyClass : NSObject
@property (nonatomic, weak) id delegate;
@end

@implementation MyClass
@end

int main() {
    @autoreleasepool {
        MyClass *obj1 = [[MyClass alloc] init];
        MyClass *obj2 = [[MyClass alloc] init];

        obj1.delegate = obj2;
        obj2.delegate = obj1;
    }
    return 0;
}
```

在这个例子中，当 `obj1` 和 `obj2` 超出作用域时，它们的引用计数会降为 0 并被销毁。在销毁过程中，`objc_release` 调用会触发对 `weak` 引用的清理，**运行时会在弱引用表中找到所有指向`obj2` 的 `weak` 引用（在本例中是 `obj1.delegate`），并将其设置为 `nil`。**

### 总结

`weak` 属性的内部实现依赖于 Objective-C 运行时的弱引用表机制。此机制主要通过以下步骤实现：

1. **记录**：在 `weak` 引用赋值时，通过 `objc_storeWeak` 函数将弱引用指针记录在全局弱引用表中，并与被引用对象关联。
2. **清理**：在对象销毁时，通过 `objc_release` 和 `weak_cleanup_no_lock` 函数，从弱引用表找到所有指向该对象的弱引用，并将其设置为 `nil`。

这样做可以有效地防止悬挂指针（dangling pointers），确保内存安全。这也是 `weak` 引用在 Objective-C 中成为避免循环引用和内存泄漏的重要工具的原因。Understanding the internals of how weak properties are implemented helps developers write more efficient, memory-safe Objective-C code.