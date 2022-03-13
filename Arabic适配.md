# Arabic适配

产品要面向阿拉伯地区，故有此记录。



1. 增加Arabic的Localizations

   新增之后，将iOS系统的语言切换到Arabic，完成这一步后，APP中很多控件会调整为RLF（Right to Left）。

   右滑返回也会变成左滑返回。

   

2. left -> leading   &  right -> trailing

   Masonry 或者 Snapkit 提供了友好的API，但 left 与 right 不能自动适配RLF，需要使用 leading 与 trailing。

   

3. 图片翻转

   有些图片需要翻转显示，比如带有箭头的。增加 category method 来方便调用。

   ```swift
   #define isRTL() [[[[NSBundle mainBundle] preferredLocalizations] firstObject] hasPrefix:@"ar"]
   
   - (UIImage *)flipImage {    
       if (isRTL()) {
           return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUpMirrored];
       }
       return self;
   }
   ```

   