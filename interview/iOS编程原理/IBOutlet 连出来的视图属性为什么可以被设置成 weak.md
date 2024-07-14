# IBOutlet 连出来的视图属性为什么可以被设置成 weak

在 iOS 和 macOS 应用开发中，使用 Interface Builder 来设计视图，并将视图与代码文件中的属性连接（即 IBOutlet）是常见且重要的步骤。`IBOutlet` 属性通常可以声明为 `weak`，但这需要结合视图层次结构和内存管理的具体实现来理解。

### Core 理念

#### 1. **视图层次结构（View Hierarchy）**

- 在 iOS 应用中，所有的视图（`UIView`）都存在于一个视图层次结构中，每个子视图都有一个父视图（superview）。
- 顶层视图（`UIViewController` 的 `view` 属性）通常强持有它的根视图和其他子视图，这意味着当视图控制器仍然存在时，所有的子视图都将被强引用，从而不会被释放。

#### 2. **内存管理**

- 在 ARC（自动引用计数）下，内存管理是通过引用计数实现的。对象有强引用（`strong`）时会增加引用计数，而弱引用（`weak`）不会增加引用计数。
- 视图控制器的视图（以及所有子视图）通过视图层次结构被强引用，因此不会被过早释放。

### IBOutlet 为什么可以被设置为 `weak`

#### 1. **避免循环引用**

使用 `weak` 来避免循环引用是一个主要原因。如果 IBOutlet 属性使用 `strong`，可能会导致视图和视图控制器之间的循环引用。例如：

```objc
@interface ViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIView *subview; // 坚持使用 weak
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 假设有一个从 storyboard 中连线的 subview
}
@end
```

在这种情况下，即使视图控制器被释放，`subview` 也会因为 `strong` 持有的原因而无法释放，导致内存泄漏。

#### 2. **视图层次结构强引用**

UIKit 确保视图层次结构中的视图保持强引用，因此子视图不会被释放。例如，视图控制器的 `view` 持有所有它的子视图，确保子视图存在的生命周期与父视图一致：

```swift
class ViewController: UIViewController {
    @IBOutlet weak var subview: UIView? // 使用 weak 避免内存泄漏
}
```

这里，`weak` 修饰的 `subview` 即使是弱引用，由于其父视图强引用了它，释放父视图之前，`subview` 不会被释放。

#### 3. **视图的生命周期**

在视图控制器处理视图的过程中（加载视图，处理内存警告等），ViewController 知道何时需要释放不再需要的子视图。通过 `weak` 引用，可以确保当视图层次结构改变时，引用也可以适当更新。

### 使用示例及最佳实践

#### 代码示例展示 `IBOutlet` 的使用

设想一个视图控制器包含一个子视图，我们需要在Interface Builder中将其连接：

```objc
// Objective-C
@interface ViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIView *subview;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    // 可以安全地使用 subview，这里假设 subview 从 storyboard 中连线
    self.subview.backgroundColor = [UIColor blueColor];
}
@end
```

```swift
// Swift
class ViewController: UIViewController {
    @IBOutlet weak var subview: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 子视图也被安全地保持，假设从 storyboard 中连线
        subview?.backgroundColor = .blue
    }
}
```

#### 使用 `strong` 的特殊情况

有时需要用 `strong`，例如：

- 在从代码中创建并需要手动管理视图的生命周期。
- 当视图不在视图层次结构时，也需要强引用。

```objc
@property (nonatomic, strong) UIView *manualSubview; // 从代码中创建、手动管理
```

### 结论

通过将 `IBOutlet` 属性声明为 `weak`，你可以消除可能的循环引用，而不必担心子视图被意外回收，因为视图层次结构确保了子视图的存在。一般来说，这是一个推荐的方法，其原因包括避免循环引用和依赖视图层次结构的强引用机制。

`IBOutlet` 使用 `weak` 是 iOS 内存管理和视图控制的最佳实践之一，理解上述概念有助于避免内存泄漏并保持更干净的内存管理模式。
