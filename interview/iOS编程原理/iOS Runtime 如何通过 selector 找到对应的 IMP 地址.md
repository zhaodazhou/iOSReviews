# iOS Runtime 如何通过 selector 找到对应的 IMP 地址

在 Objective-C 中，`selector` 是一个用于表示方法名的运行时机制。每个方法对应唯一的 `selector`，而这个 `selector` 进一步与方法实现（IMP）关联。`IMP` 是一个指向方法实现的函数指针。iOS Runtime 通过一系列步骤将 `selector` 与相应的 `IMP` 关联起来，从而找到对应的方法实现。下面是这个过程的详细说明。

### 基本概念

- **Selector**：表示一个方法的名字，运行时用 `SEL` 类型表示。
- **IMP**：指向方法实现的指针，实际上是一个函数指针，类型为 `IMP`（指向返回 `id` 类型并接受两个参数 `id` 和 `SEL` 的函数）。
- **方法表（Method Table）**：每个类都有一个方法表，用于存储方法名（Selector）与方法实现（IMP）的映射。

### 查找过程

#### 1. **Class 对象**

每个 `Objective-C` 对象都有一个 `isa` 指针，指向它的类对象。类对象存储了指向类定义的所有数据，包括方法列表、属性等。

#### 2. **方法列表（Method List）**

每个类对象都有一个与之关联的方法列表，存储了该类的所有方法。这些方法列表是一个结构体数组，每个结构体包括：

- **名称（SEL）**：方法的选择器。
- **实现（IMP）**：方法的实现。
- **类型编码（Type Encoding）**：方法的参数和返回值类型信息。

#### 3. **方法查找步骤**

**（1）获取类对象**：通过 `isa` 指针找到对象的类对象。

**（2）查找方法列表**：在类对象的方法列表中查找与 `selector` 对应的 `IMP`。

**（3）方法缓存**：Objective-C 运行时使用方法缓存来加快方法查找。缓存中包含最近使用的方法和其实现，查找方法时会先检查缓存。

**（4）父类查找**：如果在当前类中找不到对应的方法，则沿继承链向上查找父类，直到 `NSObject` 为止。

### 实际代码示例

以下是一个通过 `selector` 找到 `IMP` 的示例代码：

```objective-c
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface MyClass : NSObject
- (void)exampleMethod;
@end

@implementation MyClass
- (void)exampleMethod {
    NSLog(@"exampleMethod called");
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyClass *obj = [[MyClass alloc] init];
        
        SEL selector = @selector(exampleMethod);
        IMP imp = [obj methodForSelector:selector];
        
        // 可以将 IMP 转为相应的函数指针类型并调用
        void (*func)(id, SEL) = (void *)imp;
        func(obj, selector);
        
        // 直接调用给定的 selector 方法
        [obj performSelector:selector];
    }
    return 0;
}
```

在这个示例中：

1. **获取 selector**：使用 `@selector(exampleMethod)` 获取 `exampleMethod` 的选择器。
2. **获取 IMP**：通过 `methodForSelector:` 获取 `selector` 对应的方法实现（IMP）。
3. **调用方法**：将 `IMP` 转为对应的函数指针并调用，或者直接使用 `performSelector` 调用。

### Runtime 查找过程概述

当你发送一个消息 `[object method]` 时，Objective-C Runtime 会经过以下步骤来查找和调用方法：

#### 1. **快速查找缓存**

首先，Runtime 在类的方法缓存中查找方法实现。缓存中保存了常用方法的 `selector` 到 `IMP` 的映射。如果在缓存中找到方法实现，直接调用 `IMP`。

#### 2. **查找 Class 对象**

如果在缓存中没有找到对应方法实现，通过 `isa` 指针获取对象的类对象（`Class`）。

#### 3. **方法列表查找**

在类对象的 `method_list` 中查找匹配的 `selector`。如果找到对应的 `SEL`，则获取其 `IMP` 并更新方法缓存，加快下次查找速度。

#### 4. **沿继承链向上查找**

如果在当前类中找不到 `selector` 对应的方法，沿着继承链向上查找父类的 `method_list`，直到 `NSObject` 类。如果找到方法实现，则获取 `IMP` 并更新方法缓存。

#### 5. **消息转发**

如果在继承链上所有类中都找不到对应的方法实现，Runtime 会启动消息转发机制。可以通过实现 `forwardingTargetForSelector:` 或 `forwardInvocation:` 方法将消息转发给其他对象处理。

### 内部实现细节的探讨

以下是 Objective-C Runtime 中的部分伪代码，简要展示了上述查找过程：

```c
IMP _objc_msgForward(id receiver, SEL sel) {
    Class cls = object_getClass(receiver); // 获取类对象
    IMP imp = getMethodFromCache(cls, sel); // 从缓存中获取 IMP
    if (imp) return imp;

    while (cls) {
        MethodList *mlist = getMethodList(cls);
        for (Method *m = mlist->methods; m != mlist->end; ++m) {
            if (m->sel == sel) {
                cacheAddMethod(cls, sel, m->imp); // 添加到缓存
                return m->imp;
            }
        }
        cls = cls->superClass; // 查找父类
    }

    // 消息转发机制
    return _objc_msgForward(receiver, sel);
}
```

### 总结

通过 `selector` 找到对应的 `IMP` 是 Objective-C 运行时消息发送机制的核心。这个过程包括在方法缓存中快速查找、遍历类的方法列表、沿继承链向上查找，以及最终使用消息转发机制。理解这个过程可以帮助开发者更好地调试代码和优化性能。
