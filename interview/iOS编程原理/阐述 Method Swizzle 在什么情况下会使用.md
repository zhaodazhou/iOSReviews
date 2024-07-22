# 阐述 Method Swizzle 在什么情况下会使用

Method Swizzling（方法交换）是一种强大的 Objective-C 技术，可以在运行时替换类的方法实现。这个技术可以让开发者在不修改原始代码的情况下改变或扩展类的行为，因此在许多场景中使用。尽管强大，但 Method Swizzling 也应谨慎使用，以避免意外的问题。

### 1. **使用场景**

#### (1) 扩展框架功能

Method Swizzling 常用于扩展系统框架或第三方框架的功能。在不修改框架源代码的情况下，通过替换现有方法，可以增加或修改其功能。例如，为一个系统类的方法添加日志记录或统计功能。

```objective-c
#import <objc/runtime.h>

@implementation UIViewController (Logging)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        // Swizzle viewDidAppear:
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(xxx_viewDidAppear:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
            class_addMethod(class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)xxx_viewDidAppear:(BOOL)animated {
    [self xxx_viewDidAppear:animated]; // 由于方法实现已经互换，这里实际上调用的是原来的 viewDidAppear:
    NSLog(@"viewDidAppear: %@", self);
}

@end
```

在这个示例中，`viewDidAppear:` 方法被交换为 `xxx_viewDidAppear:`，这样每当一个视图控制器的 `viewDidAppear:` 方法被调用时，都会记录日志。

#### (2) 解决系统或第三方库的 Bug

有时候，系统框架或第三方库中可能会有一些 Bug，需要开发者进行临时修复。Method Swizzling 允许开发者在不等待官方修复的情况下，自行替换有问题的方法实现。

```objective-c
@implementation UILabel (FixBug)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(setText:);
        SEL swizzledSelector = @selector(fixed_setText:);

        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);

        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)fixed_setText:(NSString *)text {
    // 添加修复代码
    if (!text) {
        text = @"";
    }
    [self fixed_setText:text]; // 由于方法实现已经互换，这里实际上调用的是原来的 setText:
}

@end
```

#### (3) AOP（面向切面编程）

Method Swizzling 也可以用于 AOP，允许开发者在某些方法调用前后执行额外的代码，例如性能监测、日志记录、数据统计等。

```objective-c
@implementation UIViewController (Aspect)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(aspect_viewWillAppear:);

        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);

        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)aspect_viewWillAppear:(BOOL)animated {
    NSLog(@"%@ will appear", NSStringFromClass([self class]));
    [self aspect_viewWillAppear:animated]; // 由于方法实现已经互换，这里实际上调用的是原来的 viewWillAppear:
}

@end
```

### 2. **注意事项和最佳实践**

尽管 Method Swizzling 功能强大，但使用时需要谨慎。以下是一些需要注意的事项和最佳实践：

#### (1) 避免冲突

由于 Method Swizzling 改变了方法的实现，如果多个地方进行方法交换，可能导致冲突和意外行为。因此，确保方法交换的唯一性和互不干扰非常重要。

#### (2) 使用 dispatch_once 保证线程安全

在 `+load` 方法中进行 Method Swizzling 操作，并使用 `dispatch_once` 确保只交换一次，以避免多次交换带来的不确定性。

```objective-c
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Method Swizzling 操作
    });
}
```

#### (3) 调用原始实现

在新的方法实现中，确保调用原始方法的实现，以维护原有功能。在方法互换后，调用原始实现的方式有所不同，这是需要特别注意的地方。

#### (4) 注重代码可读性和维护性

由于 Method Swizzling 修改了类的行为，可能会增加代码的复杂性和维护难度。因此，需要详细的注释和文档说明，以帮助其他开发人员理解方法交换的目的和使用情况。

### 总结

Method Swizzling 是 Objective-C 提供的强大特性，允许在不修改原始代码的情况下动态替换方法实现。这在扩展框架功能、临时修复 Bug 和实现 AOP 方面非常有用。然而，使用 Method Swizzling 需要谨慎，避免冲突、保证线程安全并确保代码的可读性和可维护性。通过正确和谨慎地使用 Method Swizzling，开发者可以在不改变原始代码的情况下，增强和修复应用程序的功能。
