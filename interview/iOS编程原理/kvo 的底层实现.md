# 阐述 kvo 的底层实现

## Key-Value Observing（KVO）是iOS中一个强大的机制，它允许对象在某个属性发生变化时通知观察者。KVO的底层实现依赖于Objective-C的动态特性，包括运行时机制和类的调度。以下是对KVO底层实现的详细阐述

### 1. **自动KVO实现的核心**

KVO的核心机制是通过isa-swizzling和动态方法解析来实现的。当你为某个属性添加观察者时，系统会动态地创建对象的一个子类，并使用该子类替换原对象的类。

### 2. **isa-swizzling**

- **动态子类化：** 当调用`addObserver:forKeyPath:options:context:`时，系统会创建被观察对象的一个新子类，该子类会重写被观察的属性的setter方法。
- **修改isa指针：** 被观察对象的isa指针会被指向新创建的子类，实际类继承层次关系发生了变化。

```objective-c
// 示例代码
Person *person = [[Person alloc] init];
[person addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
// person的isa指针指向动态生成的子类
```

### 3. **Setter方法的重写**

在动态子类中，系统会重新实现被观察属性的setter方法，该方法在修改属性值前后插入通知逻辑：

- **调用`willChangeValueForKey:`**：在属性值更改前调用，通知系统即将变化。
- **调用原始setter**：调用父类的setter方法实际更改值。
- **调用`didChangeValueForKey:`**：在属性值更改后调用，通知系统变化已完成。

```objective-c
- (void)setName:(NSString *)name {
    [self willChangeValueForKey:@"name"];
    // 调用父类setter方法
    [super setName:name];
    [self didChangeValueForKey:@"name"];
}
```

### 4. **isa指针复原**

当你调用`removeObserver:forKeyPath:`时，系统会移除观察者，并将被观察对象的isa指针指回最初的类。

### 5. **Notification机制**

`willChangeValueForKey:`和`didChangeValueForKey:`方法内部使用了KVO通知机制：

- **依赖于NSKeyValueObservance和NSKeyValueArrayObserverItem**：这些仅内部可见的数据结构记录了观察者信息。
- **对观察者调用回调方法**：在属性值改变后，系统会对每个观察者调用`observeValueForKeyPath:ofObject:change:context:`方法，传递变化信息。

### 6. **手动触发KVO**

通过`+ (BOOL)automaticallyNotifiesObserversForKey:`方法可以控制某个属性是否参与自动KVO。手动管理KVO时，可以禁用自动通知并在需要时使用`willChangeValueForKey:` 和`didChangeValueForKey:`手动插入通知逻辑。

```objective-c
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"name"]) {
        return NO; // 手动管理
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

// 手动触发
- (void)changeName:(NSString *)name {
    [self willChangeValueForKey:@"name"];
    _name = name;
    [self didChangeValueForKey:@"name"];
}
```

### 7. **依赖属性**

可以通过`+ (NSSet *)keyPathsForValuesAffectingValueForKey:`方法返回属性依赖关系，从而触发连锁KVO通知。

```objective-c
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"fullname"]) {
        return [NSSet setWithObjects:@"firstname", @"lastname", nil];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}
```

### 8. **性能和使用注意事项**

- **性能开销**：由于isa-swizzling和动态子类的创建，KVO可能引入一定的性能开销。
- **内存管理**：在dealloc方法中一定要移除所有观察者，避免对象释放后仍有观察者尝试访问。

```objective-c
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"name"];
}
```

### 总结

KVO通过运行时机制实现了对对象属性变化的观察和通知，其核心是通过isa-swizzling创建动态子类，并重写setter方法插入通知逻辑。然而，使用KVO时需要注意性能和内存管理，以确保系统的高效和稳定运行。
