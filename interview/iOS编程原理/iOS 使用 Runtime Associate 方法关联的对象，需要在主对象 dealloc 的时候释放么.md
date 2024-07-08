# iOS 使用 Runtime Associate 方法关联的对象，需要在主对象 dealloc 的时候释放么

在基于Objective-C的iOS开发中，使用Runtime Associate方法关联对象（associated object）是一种常用的技术，可以动态地为现有类添加属性。然而，当你使用运行时关联对象时，需要注意内存管理以防止内存泄漏。关联对象的内存管理方式取决于你使用的关联策略（association policy）。

### 1. 关联对象方法概述

Objective-C通过运行时函数`objc_setAssociatedObject`和`objc_getAssociatedObject`来对对象进行关联和获取关联的对象。

- **关联对象**：

  ```objective-c
  void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
  ```

- **获取关联的对象**：

  ```objective-c
  id objc_getAssociatedObject(id object, const void *key);
  ```

- **移除所有关联对象**：

  ```objective-c
  void objc_removeAssociatedObjects(id object);
  ```

### 2. 关联策略（Association Policy）

`objc_setAssociatedObject` 函数中的 `policy` 参数决定了如何管理关联对象的内存。策略包括：

- `OBJC_ASSOCIATION_ASSIGN`: 相当于弱引用，不会增加引用计数。
- `OBJC_ASSOCIATION_RETAIN_NONATOMIC`: 相当于强引用，非原子操作，不会保证线程安全。
- `OBJC_ASSOCIATION_COPY_NONATOMIC`: 相当于是 `copy`，非原子操作，不会保证线程安全。
- `OBJC_ASSOCIATION_RETAIN`: 相当于强引用，原子操作，线程安全。
- `OBJC_ASSOCIATION_COPY`: 相当于是 `copy`，原子操作，线程安全。

### 3. 是否需要在 `dealloc` 中释放关联对象？

具体取决于关联策略：

- **强引用策略（RETAIN/COPY）**：当使用`OBJC_ASSOCIATION_RETAIN`、`OBJC_ASSOCIATION_RETAIN_NONATOMIC`、`OBJC_ASSOCIATION_COPY`或`OBJC_ASSOCIATION_COPY_NONATOMIC`策略时，关联对象会被自动管理（增加引用计数）。当主对象（被关联的对象）销毁时，关联对象也会自动被释放。

- **弱引用策略（ASSIGN）**：当使用`OBJC_ASSOCIATION_ASSIGN`策略时，关联对象不会增加引用计数，因此你需要确保在主对象销毁前手动将其引用置为 `nil` 以避免悬挂指针。

为确保内存安全，强引用策略的对象不需要手动在 `dealloc` 中释放，而弱引用策略的对象则需要注意手动置 `nil`。

### 实际示例代码

以下是一个示例，显示如何使用关联对象并维护其内存管理：

```objective-c
#import <objc/runtime.h>

@interface MyClass : NSObject
@end

@implementation MyClass

- (void)dealloc {
    // 如果使用了 OBJC_ASSOCIATION_ASSIGN，需要手动清理
    // objc_setAssociatedObject(self, @"associatedKey", nil, OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface AssociatedObject : NSObject
@property (nonatomic, strong) NSString *name;
@end

@implementation AssociatedObject
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyClass *mainObject = [[MyClass alloc] init];
        AssociatedObject *associatedObject = [[AssociatedObject alloc] init];
        associatedObject.name = @"Associated Object";
        
        // 使用强引用策略进行关联
        objc_setAssociatedObject(mainObject, @"associatedKey", associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // 获取关联对象
        AssociatedObject *retrievedObject = objc_getAssociatedObject(mainObject, @"associatedKey");
        NSLog(@"Associated Object Name: %@", retrievedObject.name);

        // 当 mainObject 被销毁时，associatedObject 会被自动释放
    }
    return 0;
}
```

在这个示例中：

1. 一个 `MainObject` 和一个 `AssociatedObject` 创建出来。
2. 使用 `objc_setAssociatedObject` 将 `associatedObject` 与 `mainObject` 关联，且使用 `OBJC_ASSOCIATION_RETAIN_NONATOMIC` 强引用策略。
3. 当 `mainObject` 被销毁时，`AssociatedObject` 也会被自动释放，不需要在 `dealloc` 方法中手动处理。

### 关键点总结

1. **强引用（RETAIN/COPY）策略**：关联对象的生命周期会由运行时自动管理，不需要手动释放。
2. **弱引用（ASSIGN）策略**：可能需要手动在 `dealloc` 方法中处理以防止悬挂指针。

### 额外小技巧

如果你想确保对象销毁时清理所有关联对象，可以在 `dealloc` 方法中使用 `objc_removeAssociatedObjects`：

```objective-c
- (void)dealloc {
    objc_removeAssociatedObjects(self);
}
```

### 总结

通过合理的使用 `objc_setAssociatedObject` 和 `objc_getAssociatedObject` 以及选择合适的关联策略，可以确保内存管理的正确性。强引用策略不需要在 `dealloc` 中手动释放，而弱引用策略则需要小心地处理悬挂指针问题。理解这些细节有助于编写高效且无内存泄漏的 Objective-C 代码。
