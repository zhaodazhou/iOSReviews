# 阐述 kvc 的底层实现

## Key-Value Coding（KVC）是iOS和macOS编程中非常重要的一部分，它允许通过键值字符串（key path）来访问对象的属性。KVC底层的运行机制大大简化了动态的、灵活的数据访问方式。具体来说，KVC的底层实现主要包括

### 1. **基本机制**

KVC 使用一系列约定和反射技术来实现对对象属性的访问。这通常由 `NSObject` 类提供默认实现。

### 2. **查找模式**

当你通过 KVC 访问某个属性时，比如 `valueForKey:`, 它会按以下顺序搜索：

#### 2.1. 查找 Getter 方法

- **首先查找方法：**
  - 调用类的 `get<Key>`, `<key>` 和 `is<Key>` 这几个模式之一的 getter 方法。

  ```objective-c
  - (NSString *)getName; // 示例
  - (NSString *)name;
  - (NSString *)isName;
  ```

  - 例如，对于 `valueForKey:@"name"`，KVC 会首先查找 `-name` 方法。

#### 2.2. 查找实例变量

- **直接访问实例变量：**
  - 不考虑封装，直接按顺序查找以 `_key`、`_is<Key>`、`key` 和 `is<Key>` 命名的实例变量。

  ```objective-c
  @interface Person : NSObject {
    NSString *_name;
  }
  ```

### 3. **设置属性（Setter）**

类似地，当你用 KVC 设置属性值时，比如 `setValue:forKey:`, 它会按以下顺序操作：

#### 3.1. 查找 Setter 方法

- **查找方法：**
  - 按顺序查找 `set<Key>:`, `_set<Key>:` 方法。

  ```objective-c
  - (void)setName:(NSString *)name; // 示例
  ```

#### 3.2. 直接访问实例变量

- **直接访问变量：**
  - 如果没有找到合适的 setter 方法，KVC 会尝试直接访问与键相关的实例变量。

### 4. **处理不可访问的键**

如果在上述步骤中未能找到合适的方法或变量，KVC 会调用特定的处理方法：

#### 4.1. 键路径追加方法

- `valueForUndefinedKey:`: 当获取值的键找不到时调用
- `setValue:forUndefinedKey:`: 当设置值的键找不到时调用

这些方法的默认实现会抛出异常，但你可以在子类中重载它们来提供自定义行为。

### 5. **KVC的集合访问**

对于集合类对象（如数组和字典），KVC 提供了方便的集合操作方法：

#### 5.1. `valueForKeyPath:`

- 支持点语法，能同时访问嵌套的属性。

  ```objective-c
  NSString *city = [person valueForKeyPath:@"address.city"];
  ```

#### 5.2. `setValue:forKeyPath:`

- 可以直接设置嵌套属性的值。

### 6. **键值验证**

KVC 还支持键值验证，通过 `validateValue:forKey:error:` 方法来验证键路径上的值是否正确。

### 总结

KVC 的底层实现通过协议约定、方法查找、直接访问实例变量以及容错机制来实现对对象属性的动态访问和操作。它提供了一种简洁而灵活的方式来访问属性，极大地增强了 Cocoa 和 Cocoa Touch 中对象间的消息传递和状态管理能力。