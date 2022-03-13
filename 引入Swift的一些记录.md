## 引入Swift的一些记录



### 1：调用声明

Swift调用OC源码，需要在market-Bridging-Header.h中，加入相应的import引用，然后才可以在swift源码中可以使用。这类似于一个全局性的声明，只要加入了，无论是在哪个Swift文件中，都可以直接用，不再需要import；

OC调用Swift源码，需用在OC源码中引入头文件\#import "OOOOO-Swift.h"，这个是自动生成的，每次新建Swift文件，会在其中增加相应的内容来便于给OC中调用。



### 2：耦合问题

目标：Swift中尽量少、最好不引用oc的东西；但涉及到底层的功能组件时，该如何取舍？

1：oc的category，用Swift实现了一遍extension，方便使用

2：用Swift把oc包装一下，再使用？

3：oc可以给Swift功能赋值，便于Swift使用这个Swift功能，比如currentManage功能，将Swift版本的赋值，放到oc中

4：Swift中跳转到oc的页面？因为考虑到Swift中对Swift的引用，不需要import，这样方便了很多，所以，如果能尽量在Swift中闭环的功能，就闭环。

