# 阐述 iOS Viewcontroller 生命周期

在 iOS 开发中，`UIViewController` 是核心组件之一，用于管理应用程序的一个视图层次结构。`UIViewController` 有一系列生命周期方法，通过这些方法你可以在视图加载、显示、隐藏和销毁等各个阶段执行相应的逻辑操作。理解 `UIViewController` 的生命周期对于创建和管理视图、确保数据一致性和提高应用性能至关重要。

### UIViewController 生命周期方法

以下是 `UIViewController` 的生命周期方法及其触发顺序：

1. **`initWithNibName:bundle:`**
2. **`awakeFromNib`**
3. **`loadView`**
4. **`viewDidLoad`**
5. **`viewWillAppear:`**
6. **`viewWillLayoutSubviews`**
7. **`viewDidLayoutSubviews`**
8. **`viewDidAppear:`**
9. **`viewWillDisappear:`**
10. **`viewDidDisappear:`**
11. **`dealloc`**

### 详细解释

#### 1. `initWithNibName:bundle:` / `init`

当你通过代码或 Storyboard 初始化 `UIViewController` 时，`initWithNibName:bundle:` 方法会被调用。

```objective-c
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 初始设置
    }
    return self;
}
```

#### 2. `awakeFromNib`

如果视图控制器是从 nib 文件或 storyboard 加载的，`awakeFromNib` 方法会在视图加载到内存中后被调用。这通常用于初始化界面元素。

```objective-c
- (void)awakeFromNib {
    [super awakeFromNib];
    // 初始化 UI 元素
}
```

#### 3. `loadView`

如果你没有使用 nib 文件或 storyboard，`loadView` 方法会被调用来手动创建视图层次结构。当你需要自定义视图时，可以重写这个方法。

```objective-c
- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}
```

#### 4. `viewDidLoad`

当视图控制器的视图被加载到内存中时，`viewDidLoad` 方法会被调用。你通常会在这个方法中进行视图的进一步设置和子视图的初始化。

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    // 视图加载后的额外设置，适合初始化子视图和数据
    NSLog(@"viewDidLoad");
}
```

#### 5. `viewWillAppear:`

在视图即将加入窗口并显示给用户之前调用这个方法。你可以在这个方法里执行与界面显示相关的准备工作。

```objective-c
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 准备视图的显示，例如网络请求或数据刷新
    NSLog(@"viewWillAppear:");
}
```

#### 6. `viewWillLayoutSubviews`

在视图层次结构中的视图即将布局其子视图时调用这个方法。你可以在这里更新子视图的布局。

```objective-c
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 更新子视图布局前需要的操作
    NSLog(@"viewWillLayoutSubviews");
}
```

#### 7. `viewDidLayoutSubviews`

在视图控制器的 `view`完成布局其子视图后调用。此时视图和子视图已经全部布局好。

```objective-c
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 完成对视图布局，需要执行一些额外操作
    NSLog(@"viewDidLayoutSubviews");
}
```

#### 8. `viewDidAppear:`

在视图已经加入窗口并显示给用户之后调用。你可以在这里启动视图相关的任务，如动画或数据加载。

```objective-c
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 视图已经显示出来后执行的操作，例如启动动画
    NSLog(@"viewDidAppear:");
}
```

#### 9. `viewWillDisappear:`

在视图即将从窗口移除之前调用。你可以在这里保存数据或取消网络请求等。

```objective-c
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 视图即将消失前执行的操作，例如保存数据或状态
    NSLog(@"viewWillDisappear:");
}
```

#### 10. `viewDidDisappear:`

在视图已经从窗口移除后调用。你可以在这里进行视图相关的清理任务。

```objective-c
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 视图已经消失后执行的操作，进行一些清理工作
    NSLog(@"viewDidDisappear:");
}
```

#### 11. `dealloc`

当视图控制器不再被使用，并且其所有强引用都被释放时调用。在这里清理手动管理的资源。

```objective-c
- (void)dealloc {
    // 清理手动管理的资源
    NSLog(@"dealloc");
}
```

### 总结

`UIViewController` 的生命周期方法提供了在视图的不同阶段执行特定操作的机制。理解这些方法的触发顺序和作用，可以帮助你更好地管理视图的创建、更新和销毁，确保数据一致性和提高应用性能。通过正确使用生命周期方法，你可以开发出更高效、更稳定的 iOS 应用。
