# 简述 iOS 中常用的设计模式

## 在iOS开发中，设计模式提供了一套可复用的解决方案，用于解决常见的编程问题和提高代码的可维护性和可扩展性。以下是iOS中常用的一些设计模式

### 1. **MVC（Model-View-Controller）模式**

MVC模式是iOS开发中最基础的设计模式，它将应用程序分为三个部分：

- **Model（模型）：** 数据层，负责数据和业务逻辑。
- **View（视图）：** 界面层，负责显示和布局。
- **Controller（控制器）：** 逻辑层，负责在View和Model之间进行通信。

```objective-c
@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;
@end

@interface UserView : UIView
- (void)displayUser:(User *)user;
@end

@interface UserController : UIViewController
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UserView *userView;
@end
```

### 2. **Singleton（单例）模式**

单例模式确保一个类只有一个实例，并提供一个全局访问点。常用于管理全局状态或共享资源（如网络管理器、数据库连接）。

```objective-c
@interface NetworkManager : NSObject
+ (instancetype)sharedInstance;
@end

@implementation NetworkManager
+ (instancetype)sharedInstance {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
```

### 3. **Delegate（委托）模式**

委托模式允许一个对象将某些行为或事件委托给另一个对象去处理。常用于实现回调、事件处理等，如 `UITableViewDelegate` 和 `UITableViewDataSource`。

```objective-c
@protocol CustomViewDelegate <NSObject>
- (void)didTapButtonInView:(UIView *)view;
@end

@interface CustomView : UIView
@property (nonatomic, weak) id<CustomViewDelegate> delegate;
@end

@implementation CustomView
- (void)buttonTapped {
    [self.delegate didTapButtonInView:self];
}
@end
```

### 4. **Observer（观察者）模式**

观察者模式允许对象在其状态发生改变时通知其他对象，KVO（Key-Value Observing）和通知中心（Notification Center）是常见的实现方式。

```objective-c
// Notification
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"CustomNotification" object:nil];
[[NSNotificationCenter defaultCenter] postNotificationName:@"CustomNotification" object:nil];

// KVO
[self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"Name changed to: %@", change[NSKeyValueChangeNewKey]);
    }
}
```

### 5. **Factory（工厂）模式**

工厂模式提供了创建对象的接口，而不指定具体要实例化的类。常用于创建复杂对象时，将对象创建的逻辑抽离出来。

```objective-c
@interface ShapeFactory : NSObject
- (id)createShape:(NSString *)shapeType;
@end

@implementation ShapeFactory
- (id)createShape:(NSString *)shapeType {
    if ([shapeType isEqualToString:@"Circle"]) {
        return [[Circle alloc] init];
    } else if ([shapeType isEqualToString:@"Square"]) {
        return [[Square alloc] init];
    }
    return nil;
}
@end
```

### 6. **Strategy（策略）模式**

策略模式定义一系列算法，并将每个算法封装起来，使它们可以互换。使用策略模式可以使算法独立于使用它的客户而独立变化。

```objective-c
@protocol PaymentStrategy <NSObject>
- (void)pay:(NSInteger)amount;
@end

@interface CreditCardPayment : NSObject <PaymentStrategy>
@end

@implementation CreditCardPayment
- (void)pay:(NSInteger)amount {
    NSLog(@"Paying %ld using Credit Card", amount);
}
@end

@interface PayPalPayment : NSObject <PaymentStrategy>
@end

@implementation PayPalPayment
- (void)pay:(NSInteger)amount {
    NSLog(@"Paying %ld using PayPal", amount);
}
@end

@interface ShoppingCart : NSObject
@property (nonatomic, strong) id<PaymentStrategy> paymentStrategy;
- (void)checkoutWithAmount:(NSInteger)amount;
@end

@implementation ShoppingCart
- (void)checkoutWithAmount:(NSInteger)amount {
    [self.paymentStrategy pay:amount];
}
@end
```

### 7. **Builder（建造者）模式**

建造者模式用于创建复杂对象，它将对象的创建过程分解为多个步骤，使得对象的创建过程更加灵活和可控。

```objective-c
@interface House : NSObject
@property (nonatomic, strong) NSString *wall;
@property (nonatomic, strong) NSString *roof;
@end

@interface HouseBuilder : NSObject
@property (nonatomic, strong) House *house;
- (void)buildWall;
- (void)buildRoof;
- (House *)getResult;
@end

@implementation HouseBuilder
- (instancetype)init {
    self = [super init];
    if (self) {
        _house = [[House alloc] init];
    }
    return self;
}

- (void)buildWall {
    _house.wall = @"Brick Wall";
}

- (void)buildRoof {
    _house.roof = @"Concrete Roof";
}

- (House *)getResult {
    return _house;
}
@end
```

### 8. **Facade（外观）模式**

外观模式提供了一个统一的接口，用来访问子系统中的一群接口。使子系统更容易使用。常用于简化复杂子系统的接口。

```objective-c
@interface HomeTheaterFacade : NSObject
- (void)watchMovie;
@end

@implementation HomeTheaterFacade
- (void)watchMovie {
    [self turnOnProjector];
    [self setScreen];
    [self turnOnSound];
}

- (void)turnOnProjector {
    // Logic to turn on projector
}

- (void)setScreen {
    // Logic to set screen
}

- (void)turnOnSound {
    // Logic to turn on sound
}
@end
```

### 总结

这些设计模式在iOS开发中频繁使用，帮助开发者编写更高效、可维护和可扩展的代码。通过合理地应用这些设计模式，可以有效地解决常见的编程问题，提高开发效率。