# iOS 如何手动触发一个 value 的 KVO

在 iOS 和 macOS 开发中，KVO（Key-Value Observing）是一种强大的机制，允许某个对象观察另一个对象的属性变化。通常，KVO 会在属性值发生变化时自动触发。但是，有时候你可能需要手动触发KVO通知，以便在某些特殊情况下实现对属性变化的观察和响应。

手动触发KVO通常涉及两个主要方法：`willChangeValueForKey:` 和 `didChangeValueForKey:`。这两个方法通常成对使用，以显式地通知观察者属性即将改变和已经改变。

### 手动触发KVO的步骤

1. **调用 `willChangeValueForKey:`**：通知系统某个属性即将改变。观察者会收到即将改变的通知。
2. **改变属性的值**：执行实际的属性值改变。
3. **调用 `didChangeValueForKey:`**：通知系统某个属性已经改变。观察者会收到属性已经改变的通知。

以下是具体的实现步骤和示例代码：

### 1. 声明一个需要观察的属性

首先，声明一个需要观察的属性。例如，我们有一个名为 `Person` 的类，有一个 `name` 属性：

```objective-c
@interface Person : NSObject
@property (nonatomic, strong) NSString *name;
@end

@implementation Person
@end
```

### 2. 添加 KVO 监听器

假设在另一个类中，我们希望观察 `Person` 对象的 `name` 属性变化。我们可以实现 KVO 监听器：

```objective-c
@interface Observer : NSObject
@property (nonatomic, strong) Person *person;
@end

@implementation Observer

- (instancetype)initWithPerson:(Person *)person {
    self = [super init];
    if (self) {
        _person = person;
        [_person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [_person removeObserver:self forKeyPath:@"name"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"Person's name changed to: %@", change[NSKeyValueChangeNewKey]);
    }
}

@end
```

### 3. 手动触发 KVO

在某些情况下，可能需要手动触发 KVO 通知，如在修改 `name` 属性前后显式通知观察者。

```objective-c
@implementation Person

- (void)setName:(NSString *)name {
    [self willChangeValueForKey:@"name"];
    _name = name;
    [self didChangeValueForKey:@"name"];
}

@end
```

### 4. 使用示例

以下是如何创建 `Person` 对象，并使用 `Observer` 观察 `name` 属性变化的示例：

```objective-c
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 创建 Person 对象
        Person *person = [[Person alloc] init];

        // 创建并初始化 Observer 对象
        Observer *observer = [[Observer alloc] initWithPerson:person];

        // 手动触发 KVO
        person.name = @"John Doe"; // 触发 KVO 通知
    }
    return 0;
}
```

在这个示例中，当你设置 `person.name = @"John Doe"` 时，会触发手动的 KVO 通知，观察者会收到属性改变的消息，并在控制台打印：

```
Person's name changed to: John Doe
```

### 5. 使用 KVC 修改属性值并触发 KVO

有时你可能会通过 KVC（Key-Value Coding）修改属性的值，并希望触发 KVO。这种方法不需要手动调用 `willChangeValueForKey:` 和 `didChangeValueForKey:` 方法，因为它们会自动触发。

```objective-c
[person setValue:@"Jane Doe" forKey:@"name"];
```

在这个示例中，KVC修改属性值并自动触发KVO通知。

### 总结

通过手动触发 KVO，开发者能够在某些特殊情况下控制属性变化的通知，提供更灵活的观察和响应机制。手动触发 KVO 主要涉及调用 `willChangeValueForKey:` 和 `didChangeValueForKey:` 方法，在属性变化前后显式通知观察者。这种方法不仅增强了对 KVO 的控制，同时也提高了代码的灵活性和可维护性。
