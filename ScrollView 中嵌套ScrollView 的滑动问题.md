ScrollView 中嵌套ScrollView 的滑动问题

ScrollView中嵌套ScrollView时，滑动时，默认情况下，手指在哪个ScrollView上滑动，滑动事件就被其消费掉，滑动距离就在其上。

有时，会期望滑动内部ScrollView时，由外层的控制器来控制滑动的距离应该由哪个ScrollView来体现。看到一种实现方式，在此记录下：

总体思路是：

1. 移除当前被嵌套的ScrollView自身的contentOffset的观察者
2. 对被嵌套的ScrollView的contentOffset属性设置观察者，设置为当前控制器
3. contentOffset发生变化时，通过监听函数获取位移，根据事件生产者ScrollView，以及预先设置的条件，移动特定ScrollView的位移。

```objective-c
// contentOffset属性的声明
static NSString *const kObseverKeyContentOffset = @"contentOffset";

-(void)chooseNested:(id<NestedDelegate>)delegate{
    if (_currentNestedDelegate) {
      // 移除上一个ScrollView的contentOffset的监听
        [_currentNestedDelegate.getNestedScrollView removeObserver:self forKeyPath:kObseverKeyContentOffset];
    }
    // 保存当前被嵌套的scrollView对象
    _currentNestedDelegate = delegate;
    // 添加被嵌套的ScrollView的contentOffset属性监听
    [_currentNestedDelegate.getNestedScrollView  addObserver:self forKeyPath:kObseverKeyContentOffset options:NSKeyValueObservingOptionNew context:nil];
}

// 监听函数
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([kObseverKeyContentOffset isEqualToString:keyPath]) {
        [self scrollViewDidScroll:object];
    }
}

// 具体实现ScrollView的滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //最大上滑距离
    CGFloat maxOffset = _layoutHeaderViewHeight.constant;
    CGFloat mainContentOffsetY = _mainScrollView.contentOffset.y;
    if (scrollView == _mainScrollView) {
        if (mainContentOffsetY > maxOffset) {
            [_mainScrollView setContentOffset:CGPointMake(0, maxOffset)];
        }else if(mainContentOffsetY < 0){
            [_mainScrollView setContentOffset:CGPointMake(0, 0)];
        }
    }else if (scrollView == _currentNestedDelegate.getNestedScrollView){
        UIScrollView *currentScrollView = _currentNestedDelegate.getNestedScrollView;
        CGFloat currentOffsetY = currentScrollView.contentOffset.y;
        //避免死循环
        if (currentOffsetY == 0) {
            return;
        }
        
        if(currentOffsetY < 0){
            //下滑
            if(mainContentOffsetY > 0){
                [_mainScrollView setContentOffset:CGPointMake(0, mainContentOffsetY+currentOffsetY)];
                [currentScrollView setContentOffset:CGPointMake(0, 0)];
            }
        }else if(currentOffsetY >0){
            //上拉
            if(mainContentOffsetY < maxOffset){
                [_mainScrollView setContentOffset:CGPointMake(0, mainContentOffsetY+currentOffsetY)];
                [currentScrollView setContentOffset:CGPointMake(0, 0)];
            }
        }
    }
}
```

其他的协议定义如下，子控制器继承它，通过此函数来获取子控制器中的ScrollView对象。

```objective-c
@protocol NestedDelegate <NSObject>

-(UIScrollView *)getNestedScrollView;

@end
```

