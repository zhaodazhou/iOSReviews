# KVC 和 KVO 的 keyPath 一定是属性么

在 iOS 和 macOS 开发中，Key-Value Coding (KVC) 和 Key-Value Observing (KVO) 是两个强大的技术，常用于简化对象属性访问和观察属性变化。理解 KVC 和 KVO 的 keyPath 是否一定是属性，能够帮助开发者更好地应用这些技术进行高效的开发。

### Key-Value Coding (KVC)

KVC 是一种机制，允许使用字符串键（key）来访问对象的属性。当使用 KVC 时，属性不一定是声明在接口中的属性，也可以是实例变量（ivar）或通过动态方法实现的值。

以下是一些关键点：

1. **属性**：KVC 允许直接访问属性，这些属性可以是通过 `@property` 声明的属性。
2. **实例变量**：即使没有公开的 `@property` 声明，只要实例变量名称符合键值，KVC 也可以访问它们。
3. **方法**：KVC 可以调用相应的 getter 方法（如 `-key`、`-isKey` 等），只要方法符合 KVC 规范。

#### 代码示例

```objective-c
@interface Person : NSObject {
    NSString *_internalName;
}
@property (nonatomic, strong) NSString *name;
- (NSString *)customName;
@end

@implementation Person
- (NSString *)customName {
    return @"Custom Name";
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *person = [[Person alloc] init];
        
        // 访问属性
        [person setValue:@"Alice" forKey:@"name"];
        NSLog(@"Name: %@", [person valueForKey:@"name"]); // 输出: Alice
        
        // 访问实例变量
        [person setValue:@"Internal Alice" forKey:@"_internalName"];
        NSLog(@"Internal Name: %@", [person valueForKey:@"_internalName"]); // 输出: Internal Alice
        
        // 访问方法
        NSLog(@"Custom Name: %@", [person valueForKey:@"customName"]); // 输出: Custom Name
    }
    return 0;
}
```

在这个示例中：

1. 访问 `name` 属性，是通过 `@property` 声明的。
2. 访问 `_internalName` 实例变量，即使它没有显式的公开声明。
3. 访问 `customName` 方法，取得方法返回值。

### Key-Value Observing (KVO)

KVO 是用来观察对象属性的变化。对于 keyPath，主要观察的是属性的变化，而这些属性通常是通过 `@property` 声明的。为了让某个属性具备 KVO 功能，属性应符合
KVC 兼容。

值得注意的是，KVO 观察的是属性的变化，它需要属性根据 KVC 的方式访问。如果观察的键只是一个实例变量而没有对应的 getter/setter，KVO 将无法正常工作。

#### 代码示例

```objective-c
@interface Person : NSObject
@property (nonatomic, strong) NSString *name;
@end

@implementation Person
@end

@interface Observer : NSObject
@end

@implementation Observer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"Name changed to: %@", change[NSKeyValueChangeNewKey]);
    }
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *person = [[Person alloc] init];
        Observer *observer = [[Observer alloc] init];

        // 添加 KVO 监听器
        [person addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];

        // 触发 KVO
        person.name = @"Bob";

        // 移除 KVO 监听器
        [person removeObserver:observer forKeyPath:@"name"];
    }
    return 0;
}
```

在这个示例中，`name` 属性被观察。当 `name` 属性改变时，观察者会收到通知。

### 总结

- **KVC**：不要求 `keyPath` 一定是通过 `@property` 声明的属性，KVC 可以访问属性、实例变量和方法返回值。
- **KVO**：通常针对通过 `@property` 声明的属性进行观察，因为 KVO 依赖于属性的 getter 和 setter 方法。尽管 KVO 本质上是基于 KVC 的，但为了确保 KVO 的正确工作，通常推荐使用属性而不是直接依赖实例变量。

通过理解这些差异，开发者可以更灵活地应用 KVC 和 KVO 技术，编写更高效和健壮的代码。
