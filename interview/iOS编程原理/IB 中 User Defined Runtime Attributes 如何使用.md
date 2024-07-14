# IB 中 User Defined Runtime Attributes 如何使用

在 iOS 的 Interface Builder (IB) 中，User Defined Runtime Attributes 是一个功能强大的工具，它允许开发者在 Interface Builder 中直接为视图对象设置运行时属性，而无需在代码中显式设置这些属性。这种方式可以让开发者更直观地配置视图的外观和行为，并提高开发效率和代码的可维护性。

### User Defined Runtime Attributes 的基本概念

User Defined Runtime Attributes 允许你为 Interface Builder 中任意视图对象设置任意键路径的值。可以为视图对象设置任意的属性值，包括自定义的属性，只要这些属性支持 Key-Value Coding (KVC)。

### 支持的属性类型

可用于 User Defined Runtime Attributes 的属性类型包括：

- **Boolean**：布尔值
- **Number**：数值类型（整数、浮点数等）
- **String**：字符串
- **Point**：CGPoint 类型
- **Size**：CGSize 类型
- **Rect**：CGRect 类型
- **Color**：UIColor 类型
- **Image**：UIImage 类型
- **Range**：NSRange 类型

### 使用步骤

让我们通过一个具体的示例展示如何在 Interface Builder 中使用 User Defined Runtime Attributes 设置视图属性。

#### 示例：为一个 UIView 设置边框颜色和宽度

假设我们有一个自定义的 `UIView` 类 `CustomView`，它有两个属性：`borderColor` 和 `borderWidth`，可以通过 Interface Builder 设置这些属性。

1. **创建自定义视图类**

首先，我们创建一个继承自 `UIView` 的自定义视图类 `CustomView`，并添加 `borderColor` 和 `borderWidth` 属性。

```objective-c
// CustomView.h
#import <UIKit/UIKit.h>

@interface CustomView : UIView
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@end

// CustomView.m
#import "CustomView.h"

@implementation CustomView

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

@end
```

2. **在 Interface Builder 中配置视图**

接下来，在 Interface Builder 中配置 `CustomView` 的 User Defined Runtime Attributes：

- 打开你的 Storyboard 或 XIB 文件。
- 将一个 `UIView` 拖到你的界面布局中。
- 在 Identity Inspector 中，将 `UIView` 的类名设置为 `CustomView`。
- 在 User Defined Runtime Attributes 部分，点击加号添加一个新属性。
- 设置 `Key Path` 为 `borderColor`，`Type` 为 `Color`，选择一个颜色（例如红色）。
- 再添加一个新属性，设置 `Key Path` 为 `borderWidth`，`Type` 为 `Number`，设置值为 2。

你应该会看到配置如下图所示：

![User Defined Runtime Attributes](https://developer.apple.com/design/human-interface-guidelines/images/technologies/attributes-user-defined_2x.png)

3. **运行你的应用**

运行你的应用程序，你将会看到 `CustomView` 的边框颜色和宽度已经按照你在 Interface Builder 中的设置进行了更新。

### 代码实现总结

通过在 Interface Builder 中设置 User Defined Runtime Attributes，我们避免了在代码中显式设置属性，从而简化了界面配置。

```objective-c
// CustomView.h
#import <UIKit/UIKit.h>

@interface CustomView : UIView
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@end

// CustomView.m
#import "CustomView.h"

@implementation CustomView

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

@end
```

在 Interface Builder 中的配置使得视图的外观可以在设计时直接设置和预览，而不必等到运行时才能看到效果。这大大提高了开发和调试的效率。

### 总结

User Defined Runtime Attributes 是 Xcode Interface Builder 中强大的特性，使得开发者可以在界面设计时方便地设置和预览视图的运行时属性。通过这种方式，开发者可以更直观地配置视图的外观和行为，减少代码量，提高开发效率和代码的可维护性。

这种方式不仅支持常见的属性类型，还支持设置自定义视图类的运行时属性，只要这些属性符合 KVC（Key-Value Coding）规范。理解和应用 User Defined Runtime Attributes，可以帮助开发者更高效地进行界面设计和配置。
