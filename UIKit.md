# UIKit

## 1.UIWindow : UIView



```
@property(nonatomic) UIWindowLevel windowLevel;                   // default = 0.0
```

值越大，越是显示在顶层。



## 2. UIWindowScene : UIScene

iOS13新增的，官方解释：A specific type of scene that manages one or more windows for your app.

管理UIWindow的一个类。13之前是一个UIscreen可以有多个UIWindow，现在在UIscreen与UIWindow之间加入了一层UIWindowScene。

```
@property (nonatomic, readonly) UITraitCollection *traitCollection;

```



## 3. UIScene : UIResponder

iOS13.

```
// UIScene is strongly retained by UIKit like UIApplication, however, unlike UIApplication, the delegate may not need to live for the whole lifetime of the process.
// A strong ref here relieves clients of the responsibility of managing the delegate lifetime directly.
@property (nullable, nonatomic, strong) id<UISceneDelegate> delegate;
```

strong类型的**delegate**



## 4.UIResponder : NSObject

事件的响应者。

touch/press/motion事件响应。

设置对象为事件的响应者，如果可以。

```
@property(nonatomic, readonly) BOOL canBecomeFirstResponder;    // default is NO
- (BOOL)becomeFirstResponder;

@property(nonatomic, readonly) BOOL canResignFirstResponder;    // default is YES
- (BOOL)resignFirstResponder;
```



```
@property(nullable, nonatomic,readonly) NSUndoManager *undoManager API_AVAILABLE(ios(3.0));

```

## 5.UIControl : UIView

控制者，或响应者，可以对各种控件的事件进行响应，比如UITextField、sliders。

control类型：

```objective-c
typedef NS_OPTIONS(NSUInteger, UIControlEvents) {
    UIControlEventTouchDown                                         = 1 <<  0,      // on all touch downs
    UIControlEventTouchDownRepeat                                   = 1 <<  1,      // on multiple touchdowns (tap count > 1)
    UIControlEventTouchDragInside                                   = 1 <<  2,
    UIControlEventTouchDragOutside                                  = 1 <<  3,
    UIControlEventTouchDragEnter                                    = 1 <<  4,
    UIControlEventTouchDragExit                                     = 1 <<  5,
    UIControlEventTouchUpInside                                     = 1 <<  6,
    UIControlEventTouchUpOutside                                    = 1 <<  7,
    UIControlEventTouchCancel                                       = 1 <<  8,

    UIControlEventValueChanged                                      = 1 << 12,     // sliders, etc.
    UIControlEventPrimaryActionTriggered API_AVAILABLE(ios(9.0)) = 1 << 13,     // semantic action: for buttons, etc.

    UIControlEventEditingDidBegin                                   = 1 << 16,     // UITextField
    UIControlEventEditingChanged                                    = 1 << 17,
    UIControlEventEditingDidEnd                                     = 1 << 18,
    UIControlEventEditingDidEndOnExit                               = 1 << 19,     // 'return key' ending editing

    UIControlEventAllTouchEvents                                    = 0x00000FFF,  // for touch events
    UIControlEventAllEditingEvents                                  = 0x000F0000,  // for UITextField
    UIControlEventApplicationReserved                               = 0x0F000000,  // range available for application use
    UIControlEventSystemReserved                                    = 0xF0000000,  // range reserved for internal framework use
    UIControlEventAllEvents                                         = 0xFFFFFFFF
};
```

可以对一个控件增加多种类型的事件响应。



control状态

```objective-c

typedef NS_OPTIONS(NSUInteger, UIControlState) {
    UIControlStateNormal       = 0,
    UIControlStateHighlighted  = 1 << 0,                  // used when UIControl isHighlighted is set
    UIControlStateDisabled     = 1 << 1,
    UIControlStateSelected     = 1 << 2,                  // flag usable by app (see below)
    UIControlStateFocused API_AVAILABLE(ios(9.0)) = 1 << 3, // Applicable only when the screen supports focus
    UIControlStateApplication  = 0x00FF0000,              // additional flags available for application use
    UIControlStateReserved     = 0xFF000000               // flags reserved for internal framework use
};
```



## 6. UIView : UIResponder

```objective-c
@property(nonatomic,getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is YES. if set to NO, user events (touch, keys) are ignored and removed from the event queue.
```

默认为NO。



```objective-c
@property (nonatomic) UISemanticContentAttribute semanticContentAttribute API_AVAILABLE(ios(9.0));

```

可以设置UIbutton的左图右字顺序，尤其对阿拉伯地区的国际化有用。



```objective-c
@property(null_resettable, nonatomic, strong) UIColor *tintColor API_AVAILABLE(ios(7.0));

@property(nonatomic) UIViewTintAdjustmentMode tintAdjustmentMode API_AVAILABLE(ios(7.0));

```

可以影响子view的tintColor，除非特意设置子view的tintColor。



有截图相关的category：



## 7. UIViewController : UIResponder

```objective-c
@property(null_resettable, nonatomic,strong) UIView *view; // The getter first invokes [self loadView] if the view hasn't been set yet. Subclasses must call super if they override the setter or getter.
- (void)loadView; // This is where subclasses should create their custom view hierarchy if they aren't using a nib. Should never be called directly.
```

如果没有使用nib，则loadView方法不能直接调用。

```objective-c
- (void)viewDidLoad; // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
```

注意调用的时机。



## 8.UILabel : UIView

```objective-c
// the underlying attributed string drawn by the label, if set, the label ignores the properties above.
@property(nullable, nonatomic,copy)   NSAttributedString *attributedText API_AVAILABLE(ios(6.0));  // default is nil
```

设置了attributedText就会忽略text等属性的设置了。



```objective-c
@property(nonatomic,getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is NO
@property(nonatomic,getter=isEnabled)                BOOL enabled;                 // default is YES. changes how the label is drawn
```

注意上面2者的区别，前者设置为NO了，但事件还是会往下传递；后者不会。



## 9.UIButton : UIControl

```objective-c
// return title and image views. will always create them if necessary. always returns nil for system buttons
@property(nullable, nonatomic,readonly,strong) UILabel     *titleLabel API_AVAILABLE(ios(3.0));
@property(nullable, nonatomic,readonly,strong) UIImageView *imageView  API_AVAILABLE(ios(3.0));

```

自带label与imageview属性。



## 10.UITableView : UIScrollView

### UITableViewRowAction & UIContextualAction

row的自定义操作，前者在iOS13之后被废弃，后者从iOS11开始使用。



### **@protocol** UITableViewDelegate<NSObject, UIScrollViewDelegate>

决定显示与行为。this represents the display and behaviour of the cells.



协议：

```objective-c
UITableViewDragDelegate
UITableViewDropDelegate
```

这2个协议的含义不甚明了……



## 11.UITextView : UIScrollView

可以用富文本的方式插入显示图片或文档，并点击处理相应的动作。

代理方法：

```objective-c
- (void)textViewDidChange:(UITextView *)textView
```

与

```objective-c
UITextViewTextDidChangeNotification
```

应该是一样功能。



```objective-c
@property (nullable, readwrite, strong) UIView *inputView;             
@property (nullable, readwrite, strong) UIView *inputAccessoryView;
```

上面2个属性是与键盘有关的属性，可以通过inputView，放置自定义的显示在原本键盘显示的地方；

通过inputAccessoryView来实现键盘上方放置自定义的视图，比如特定的按钮。

## 12.UIColor : NSObject



## 13:UIDatePicker : UIControl



## 14:UIDevice : NSObject



## 15:UIEvent : NSObject



## 16:UIToolbar

工具条，可以放多个控件，那最多可以放几个呢？



## 17:UIColorPickerViewController

选色板，可以自己配置颜色，也可以返回调用页面，萃取页面上的颜色，并且返回给调用者，iOS14及以上可用。



## 18：UIColorWell

点击这个小按钮可以弹出UIColorPickerViewController的功能。



## 19:UIActivity

## 20:UIActivityIndicatorView

小菊花



## 21: NSAttributedString

富文本属性相关的内容。

## 22:NSDataAsset

NSDataAsset represents the contents of data entries in your asset catalog.

Data assets are not in the same class of stored content as images, so you cannot use a data asset to get image data for an image.

Asset Catalog允许根据当前设备来组织资源文件。比如@2x、@3x类型。对于其他类型的asset，可能根据可用内容或Metal版本而提供不同的文件。

除了图片，json、xml和其他数据文件之类的资源也可以通过NSDataAsset读取。



## 23:NSDiffableDataSourceSectionSnapshot

没看到具体的例子。



UIBarButtonItem

## 24：UIGestureRecognizer

属性：**cancelsTouchesInView**

```
@property(nonatomic) BOOL cancelsTouchesInView;       // default is YES. causes touchesCancelled:withEvent: or pressesCancelled:withEvent: to be sent to the view for all touches or presses recognized as part of this gesture immediately before the action method is called.
```

默认为YES。表示当手势识别器成功识别了手势之后，会通知Application取消响应链对事件的响应，并不再传递事件给hit-test view。若设置成NO，表示手势识别成功后不取消响应链对事件的响应，事件依旧会传递给hit-test view。





参考链接 



[手势与变形]: https://byblog.github.io/2016/10/10/iOS-%E6%89%8B%E5%8A%BF%E4%B8%8E%E5%8F%98%E5%BD%A2/	"手势与变形"



 [https://byblog.github.io/2016/10/10/iOS-%E6%89%8B%E5%8A%BF%E4%B8%8E%E5%8F%98%E5%BD%A2/](https://byblog.github.io/2016/10/10/iOS-手势与变形/)



iOS手势分为下面这几种：



\- UITapGestureRecognizer（点按）

\- UIPanGestureRecognizer（拖动）

\- UIScreenEdgePanGestureRecognizer (边缘拖动)

\- UIPinchGestureRecognizer（捏合）

\- UIRotationGestureRecognizer（旋转）

\- UILongPressGestureRecognizer（长按）

\- UISwipeGestureRecognizer（轻扫）