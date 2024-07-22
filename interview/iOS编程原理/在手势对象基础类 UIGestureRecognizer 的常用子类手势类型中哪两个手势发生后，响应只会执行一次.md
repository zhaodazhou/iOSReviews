# 在手势对象基础类 UIGestureRecognizer 的常用子类手势类型中哪两个手势发生后，响应只会执行一次

在iOS开发中，`UIGestureRecognizer` 提供了多种手势识别方式，用于处理用户的触摸事件。常用的 `UIGestureRecognizer` 子类包括 `UITapGestureRecognizer`、`UIPinchGestureRecognizer`、`UIRotationGestureRecognizer`、`UISwipeGestureRecognizer`、`UIPanGestureRecognizer`、`UILongPressGestureRecognizer` 以及 `UIScreenEdgePanGestureRecognizer` 等。

在这些手势识别器中，有两个手势类型的响应逻辑是“只会执行一次”，即当手势满足一定条件时，响应动作只执行一次。这两个手势类型是：

1. **UITapGestureRecognizer**（点击手势）
2. **UISwipeGestureRecognizer**（滑动手势）

### 1. UITapGestureRecognizer

`UITapGestureRecognizer` 用于识别点击手势。一个点击手势就是用户点击一次或多次（如双击或三击）的动作。该手势识别器在识别到预定的点击次数（由 `numberOfTapsRequired` 属性指定）时，会触发一次响应。

#### 使用示例

```objective-c
UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
tapGesture.numberOfTapsRequired = 1; // 单击
[self.view addGestureRecognizer:tapGesture];

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Tap gesture recognized");
        // 处理点击手势
    }
}
```

在这个示例中，当用户在视图上单击时，`handleTapGesture:` 方法会被触发一次。

### 2. UISwipeGestureRecognizer

`UISwipeGestureRecognizer` 用于识别滑动手势。滑动手势是用户在屏幕上快速滑动一段距离的动作。该手势识别器在识别到特定方向（由 `direction` 属性指定）的滑动手势时，会触发一次响应。

#### 使用示例

```objective-c
UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; // 向右滑动
[self.view addGestureRecognizer:swipeGesture];

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Swipe gesture recognized");
        // 处理滑动手势
    }
}
```

在这个示例中，当用户在视图上快速向右滑动时，`handleSwipeGesture:` 方法会被触发一次。

### 总结

`UITapGestureRecognizer` 和 `UISwipeGestureRecognizer` 是 `UIGestureRecognizer` 的两种常用子类手势类型，它们在手势识别成功后，响应动作只会执行一次。

- **UITapGestureRecognizer**：用于识别点击手势，如单击、双击等。手势识别成功后响应一次。
- **UISwipeGestureRecognizer**：用于识别滑动手势，如向左、向右、向上或向下滑动。手势识别成功后响应一次。

通过正确使用这些手势识别器，可以方便地处理用户的点击和滑动操作，提高应用的交互体验。
