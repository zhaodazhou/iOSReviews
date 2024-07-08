# arc 下不显示指定任何属性关键字，默认关键字有哪些

在 Objective-C 中，当使用 ARC（Automatic Reference Counting）时，如果不显式指定属性关键字，编译器会使用某些默认的属性关键字。以下是 ARC 下默认属性关键字的具体情况：

### 1. **默认属性关键字**

1. **强引用（strong）**
2. **原子性（atomic）**
3. **读取器（readwrite）**

### 具体说明

#### 1.1 强引用（strong）

如果不指定 `nonatomic`、`weak`、`assign` 或 `copy` 等关键字，属性会默认使用 `strong` 关键字。这意味着编译器会生成使用强引用的存取方法，并增加对象的引用计数。

#### 1.2 原子性（atomic）

如果不显式指定 `nonatomic` 关键字，属性会默认使用 `atomic` 特性。这意味着编译器会生成线程安全的存取方法，但这也会带来一些性能开销。

#### 1.3 读取器（readwrite）

如果不显式指定 `readonly` 关键字，属性会默认使用 `readwrite` 关键字。这意味着编译器会生成属性的读取和写入方法。

```objective-c
@property id myProperty;
```

等同于

```objective-c
@property (strong, atomic, readwrite) id myProperty;
```

### 使用示例

假设你有一个 `Person` 类，并且在类中定义了一个没有任何属性关键字的属性：

```objective-c
@interface Person : NSObject
@property NSString *name;
@end
```

这个定义等同于：

```objective-c
@interface Person : NSObject
@property (strong, atomic, readwrite) NSString *name;
@end
```

### 其他常见的属性关键字

- **nonatomic**：如果不需要线程安全，可以使用 `nonatomic` 来提高性能。
- **weak**：适用于引用不会增加对象引用计数的情境，用于避免循环引用。
- **assign**：通常用于基本数据类型，既不会增加也不会减少引用计数。
- **copy**：在属性设置时创建副本，适用于不可变对象（如 `NSString`）以防止外部修改。

```objective-c
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *username;
```

### 总结

在 ARC 下，如果没有显式指定任何属性关键字，编译器会默认使用 `strong`、`atomic` 和 `readwrite`。这意味着，属性会拥有强引用、线程安全和可读写的特性。然而，根据具体应用情境，显式指定适当的关键字（如 `nonatomic`、`weak`、`assign` 或 `copy`）可以优化性能和内存管理。

理解这些默认关键字和如何根据需要选择合适的属性特性，对于编写高效和稳定的 Objective-C 代码至关重要。