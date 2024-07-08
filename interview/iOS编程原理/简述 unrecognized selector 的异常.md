# 简述 unrecognized selector 的异常

在 Objective-C 中，`unrecognized selector` 异常是运行时的一种常见错误，通常发生在向某个对象发送了它不识别或没有实现的方法（selector）。这会导致程序崩溃，从而产生 `unrecognized selector sent to instance` 异常。理解和处理这种异常对于开发健壮和可靠的应用至关重要。

### 什么是 Selector

在 Objective-C 中，selector（选择器）是用来表示方法名的。它是一个运行时概念，用于动态调用方法。一个 selector 本质上是一个方法的名称符号，可以在代码运行时动态解析和调用。

### 触发 `unrecognized selector` 异常的原因

`unrecognized selector` 异常通常出现在以下情景：

1. **发送了错误的 selector**：向对象发送了一个它不识别或没有实现的方法。
2. **对象被释放后发送消息**：向一个已经释放的对象发送消息（导致悬挂指针问题）。
3. **类型不匹配**：类型强转错误，向不正确的对象类型发送了方法。

### 常见示例

#### 1. 发送了错误的 selector

```objective-c
NSObject *obj = [[NSObject alloc] init];
[obj performSelector:@selector(nonexistentMethod)];
```

在这个示例中，`NSObject` 类不存在 `nonexistentMethod` 方法，调用这个方法会导致 `unrecognized selector` 异常。

#### 2. 对象被释放后发送消息

```objective-c
Person *person = [[Person alloc] init];
[person release]; // 释放对象
[person name]; // 错误：向已释放的对象发送消息
```

在这种情况下，`person` 对象被释放后再次发送消息，会导致程序崩溃，并产生 `unrecognized selector` 异常。

### 捕获和处理 `unrecognized selector` 异常

Objective-C 提供了一些方法来捕获和处理这种异常，避免程序崩溃。常见的方法包括：

#### 1. Method Swizzling

可以通过动态方法替换（Method Swizzling）来捕获异常，并提供一个默认实现或进行特殊处理。

```objective-c
#import <objc/runtime.h>

@implementation NSObject (Swizzle)

+ (void)load {
    Method original = class_getInstanceMethod([self class], @selector(forwardInvocation:));
    Method swizzled = class_getInstanceMethod([self class], @selector(swizzled_forwardInvocation:));
    method_exchangeImplementations(original, swizzled);
}

- (void)swizzled_forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"Unrecognized selector - %@", NSStringFromSelector([anInvocation selector]));
    // 处理异常
    // [self swizzled_forwardInvocation:anInvocation]; // 调用原始实现
}

@end
```

#### 2. 消息转发机制

Objective-C 的运行时提供了消息转发机制，可以在 `unrecognized selector` 异常发生之前，提供一个机会给对象进行处理。

步骤包括：

1. **方法解析**：实现 `+resolveInstanceMethod:` 或 `+resolveClassMethod:` 来动态添加方法实现。
2. **备用接受者**：实现 `-forwardingTargetForSelector:`，将消息转发给另一个对象。
3. **完整转发**：实现 `-methodSignatureForSelector:` 和 `-forwardInvocation:`，进行自定义的消息转发。

```objective-c
@interface MyClass : NSObject
@end

@implementation MyClass

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // 动态添加方法实现
    if (sel == @selector(nonexistentMethod)) {
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

id dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@"Dynamic method implementation");
    return nil;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    // 指定备选接受者
    if (aSelector == @selector(nonexistentMethod)) {
        return alternativeReceiver;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    // 返回方法签名
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    // 完整的消息转发
    if ([alternativeReceiver respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:alternativeReceiver];
    } else {
        [self doesNotRecognizeSelector:[anInvocation selector]];
    }
}

@end
```

### 如何防止 `unrecognized selector` 异常

1. **正确性检查**：在发送消息之前，确保对象确实实现了该方法。
2. **类型检查**：在类型转换时，验证对象的实际类型。
3. **使用弱引用**：避免悬挂指针问题。

```objective-c
if ([obj respondsToSelector:@selector(myMethod)]) {
    [obj myMethod];
}
```

### 总结

`unrecognized selector` 异常是由于向对象发送了它不识别或者没有实现的方法引起的。理解和处理这种异常对于编写可靠和健壮的代码至关重要。开发者可以通过方法动态替换、消息转发机制、类型和正确性检查等方法来捕获、处理和防止这种异常，确保应用程序的稳定性和可靠性。
