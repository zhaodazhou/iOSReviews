# iOS tips

## 1.自定义的导航栏右键，enable禁用

在自定义导航栏右键时，在某条件成立时，按钮可响应点击事件，尝试如下：

```
self.saveBtn = [self getBtn:MKString(@"Post_Button_Save") action:@selector(onSave)];
[self.saveBtn setEnabled:NO];
self.saveBtn.alpha = 0.4;
UIBarButtonItem *customBar = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    self.navigationItem.rightBarButtonItem = customBar;
    
```

测下来未达到预期效果，然后尝试如下：

```objective-c
self.saveBtn = [self getBtn:MKString(@"Post_Button_Save") action:@selector(onSave)];
UIBarButtonItem *customBar = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
self.navigationItem.rightBarButtonItem = customBar;
[self.saveBtn setEnabled:NO]; // 调换位置
self.saveBtn.alpha = 0.4;
```

这样是可以的。



## 2.UILabel上显示字符串尾部空格字符

UILabel对字符串的尾部有默认的trim功能，为了某些显示效果，需要其他的办法来实现UILabel，如下：

```objective-c
NSString * title = [NSString stringWithFormat:@" %d ", num];

NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc]
                                                initWithString:title                               attributes:@{NSForegroundColorAttributeName:ColorString(@"#ffffff"),                                                          							NSParagraphStyleAttributeName:style}];
self.mLabel.attributedText = attribut;
```



## 3.UIScrollView的Masonry布局

UIScrollView是可以左右上下滑动的控件，在用Masonry对在其之上的元素布局时，某些约束条件是无效的，比如：

```objective-c
[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollview.left).offset(200);
}];
```

上面代码可以使titleLabel在scrollview的左侧200的位置处。

```objective-c
[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollview.right);
}];
```

但是，上面代码并不能使titleLabel在scrollview的右侧。

所以，在对UIScrollView进行Masonry布局，需遵循从上到下、从左到右的方式，当布局内容超过一屏幕时，scrollview可以进行滑动。

具体的方式如下：

- 对scrollview进行约束

  ```objective-c
  [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.view);
  }];
  ```

- 声明containView 放置在scrollview上

  ```objective-c
  // 设置参照视图的约束
  [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.scrollview);
      make.width.equalTo(self.scrollview);
   }];
  ```

- 其他的视图，都放置在containView上，并进行约束

- 最后约束containView的底部条件

  ```objective-c
  [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
   				//productView是containView上最下面的一个子控件
          make.bottom.equalTo(self.productView.bottom);
  }];
  ```

通过以上方式，不需要再设置scrollview的contentSize就可以实现滑动，而且是正好的滑动。



## 4.view画圆角

```objective-c
UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:containView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
CAShapeLayer * layer = [[CAShapeLayer alloc] init];
layer.frame = containView.bounds;
layer.path = path.CGPath;
containView.layer.mask = layer;
```



## 5.UIActivityViewController

可以用此类调起系统的分享界面，其中包括了第三方APP的分享功能





## 6.CocoPads中的文件夹命名规则

是根据库的名称，比如 AFNetworking 的md5后字符串为 A75D452377F3996BDC4B623A5DF25820，其在Specs的目录位置即为 a/7/5/AFNetworking



这样的命名好处是，查找快。



## 7.导航栏的隐藏与显示

有场景页面是一进入页面时，导航栏是隐藏的，但在向滑动UIscrollview上时，根据滑动的距离，逐步隐藏刚开始的自定义“导航栏”，然后让原生的导航栏显示出来。

可以通过设置自定义“导航栏”与原生的导航的透明度，来控制这个过程，但在原生导航栏透明度到达1的时候，会导致UIscrollview向下的位移发生。这种情况可以通过重置位置属性来避免视觉上的变化，具体如下：

```objective-c

- (void)scrollYOffset:(CGFloat)y {
    float alpha = y / 44.0;
    self.topContainView.alpha = 1 - alpha;// 调整自定义“导航栏”的透明度
    if (alpha > 0.5) {
      // 透明度达到0.5时，显示原生导航栏，并调整UIscrollview上的cardview（即contain view）来避免UIscrollview的下移
        [self.navigationController setNavigationBarHidden:NO];
        [self.cardview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(- (SPStaticStatusBarHeight + APPCONFIG_UI_NAVIGATIONBAR_ITEM_HEIGHT));
        }];
    } else {
        [self.navigationController setNavigationBarHidden:YES];
        [self.cardview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
  // 调整原生导航栏的透明度，使其有渐变效果
    [self.navigationController.navigationBar navBarBackGroundColor:ColorStringAlpha(@"#ffffff", alpha) image:nil isOpaque:NO];
}
```



## 8.在release模式下进行真机调试

1：编辑工程的scheme模式，将【Run】模式下的【Build Configuration】选项设置为Release模式； 

2：设置工程的【Build Settings】，将【Code Signing Identity】与【Provisioning Profile】的Release的设置为相应的开发者cer和pro证书。

这个，就能在release模式下进行真机调试，毕竟有些问题在debug模式下是不复现的，而在release模式下却必现（比如对象的延迟释放问题）。



## 9.transitionFromViewController切换controller时的问题

```objective-c
[self transitionFromViewController:self.currentCtl
                      toViewController:toCtl
                              duration:1
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{}
                            completion:^(BOOL finished) {
         weakSelf.currentCtl = toCtl;
    }];
```

如果有2个controller的viewWillAppear中有刷新页面之类的功能，那在这2个controller之间快速切换时，极易容易发生白屏问题，其中finished变量在平常是yes，但发生白屏的那次，是no；而且在之后也不会再从白屏中恢复过来。



## 10.设置button的图片与文字的左右关系

可以通过titleEdgeInsets与imageEdgeInsets来实现：

```objective-c
CGFloat labelWidth = btn.titleLabel.intrinsicContentSize.width; //注意不能直接使用titleLabel.frame.size.width,原因为有时候获取到0值
                CGFloat imageWidth = self.imageWidth;;
                CGFloat space = 1.f; //定义两个元素交换后的间距

                btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space, 0,  -labelWidth - space);
```

当然，这种方式也可以用来设置上下之间的关系。



更简单的方式如下：

```objective-c
btn.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
```



## 11. transitionFromViewController

```objective-c
- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^ __nullable)(void))animations completion:(void (^ __nullable)(BOOL finished))completion API_AVAILABLE(ios(5.0));
```

iOS自带的切换controller的方式有2个问题。

1. 在iOS14上，completion的回调有时候finished为false；
2. completion的回调比较慢，这在一些连续回退页面的场景中会出现意外的bug。



## 12. NSTimer

计时器的block对业务会有强引用，即使用了weakSelf。

所以在有重复计时器场景时，不能简单的重新初始化一个计时器来重新计时。可以通过以下方法：

1. 将计时器invalidate后，再初始化；

2. 通过fire()来重新计时。比如：

   ```
   if (self.timer) {
           [self.timer fire];
       } else {
           self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer *timer) {
               weakSelf.countTimes--;
               
           } repeats:YES];
       }
   ```






## 13. iOS 字典初始化赋值一记

有例如下：

```
int index = 1, size = 1, type = 1;
    NSString * shopId = nil;
    NSString * word = @"";
    NSDictionary * para = [NSDictionary dictionaryWithObjectsAndKeys:
                           @(index), @"pageIndex",
                           @(size), @"pageSize",
                           shopId, @"shopId",
                           word, @"keyWord",
                           @(type), @"orderType",
                           nil];
```

问，字典para中有个key-value？

答案是2个，因为shopId为nil，中断了后续的赋值操作。



同样的操作在Array上类似，nil值也会中断后续的赋值初始化动作。



## 14.货币国际化的显示

```objective-c
// 本地化货币显示格式
+ (NSString *)localizePriceWithFloat:(float)price {
    if (!currencyFormat) {
        currencyFormat = [[NSNumberFormatter alloc] init];
        currencyFormat.numberStyle = NSNumberFormatterCurrencyStyle;
        currencyFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_BR"];
    }
    NSNumber * number = [[NSNumber alloc] initWithFloat:price];
    NSString * result = [currencyFormat stringFromNumber:number];
    return result;
}
```

## 15.数字格式化-针对巴西

```objective-c
static NSNumberFormatter * numberFormat;
// 数字格式化-针对巴西
+ (NSString *)localizeFormatWithFloat:(float)value {
    if (!numberFormat) {
        NSString * amountFormat = @"##.##0,00";
        numberFormat = [[NSNumberFormatter alloc] init];
        [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormat setPositiveFormat:amountFormat];
        [numberFormat setLenient:YES];
    }
    NSNumber * number = [[NSNumber alloc] initWithFloat:value];
    NSString * result = [numberFormat stringFromNumber:number];
    return result;
}
```

## 16.货币国际化之locale

对于locale的配置，比如配置意大利，如下：

```objective-c
[[NSLocale alloc] initWithLocaleIdentifier:@"IT"];
```

这种方式在oc下是可以正常显示的，但在Swift的代码中，却显示出了乱码。

尝试下来，应该如下设置：

```
[[NSLocale alloc] initWithLocaleIdentifier:@"ca_IT"];
```

这个 **ca_IT** 的获取，是通过[NSLocale availableLocaleIdentifiers]来的，具体代码如下：

```objective-c
- (void)listCountriesAndCurrencies {
    NSArray<NSString *> *localeIds = [NSLocale availableLocaleIdentifiers];
    NSMutableDictionary<NSString *, NSString *> *countryCurrency = [NSMutableDictionary dictionary];
    for (NSString *localeId in localeIds) {
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:localeId];

        NSString *country = [locale objectForKey: NSLocaleCountryCode];
        if (country && country.length == 2) {
            if ([country isEqualToString:@"IT"]) {
                NSLog(@"");
            }
            NSString *currency = [locale objectForKey: NSLocaleCurrencySymbol];
            countryCurrency[country] = currency;
        }
    }

    NSArray<NSString *> *sorted = [countryCurrency.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *country in sorted) {
        NSString *currency = countryCurrency[country];
        NSLog(@"country: %@, currency: %@", country, currency);
    }
}
```

