## 【iOS】集成CocosCreate导出的项目

### 背景

由于现实需求，需要将**多个h5**的Cocos2d-x，转变为**原生**后，再集成进现有项目。



### 参考

如果是通过新建的空工程来集成CocosCreate导出的项目（后面简称Cocos项目），可以直接参考

[《CocosCreator导出的iOS项目》](https://blog.csdn.net/u014516197/article/details/105530707?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-6.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-6.control) ，对这篇参考文档简单那总结如下：

1. 修改Appdelegate类名称，复制cocos2d-x、Classes、jsb-default等资源文件；
2. 引入相关的工程与文件到目的项目中；
3. 修改Build Phases与Build settings中的配置；
4. c/c++编译选项的修改；
5. 原生使用，包括import "cocosd.h"等

上述文档中做了详尽的描述与截图，此处不再复述，以下仅做不同之处的记录。



### 不同之处

这是集成到现有项目中，不是新建的空工程；

此次集成多个Cocos项目。

Always Search User Paths  设置为YES

### 编译问题

由于目的项目是比较复杂的，在按照一般步骤来集成时在编译过程中一直失败，所以在此记录下一些典型的错误类型，以便需要时参考。当然，这些问题都是在特定项目中出现的，换个项目可能就不存在或者导致出现的原因不一样了。

#### 错误1

```swift
Swift Compiler Error: unknown type name uint32_t
```

这个编译错误，是cocos2d-x的位置引起的。原先将其放置在与工程文件同一目录下，将其移到工程文件上一级后就ok了。



#### 错误2

```swift
 import <string> - 'string' file not found
```

这个编译错误出现在引入cocos项目中的文件导致的，比如\#import "cocos2d.h"

cocos项目中的文件直接或间接的引入了c++的文件和库，一般情况下Compile Sources As这个编译选项默认一般是According to File Type，这就需要让让编译器知道引入文件要通过c++类型的编译器来编译此文件。

可以通过修改Compile Sources As这个配置来实现，如果修改后还能编译成功的话；

修改源文件的文件名的后缀，比如TestViewController.m中引入了\#import "cocos2d.h"，可以将其文件名修改为TestViewController.mm



### 集成问题

#### 文件名称相同问题的解决

由于cocos create导出的项目，文件名称之类的都是相同的，导致无法直接的将2个cocos项目直接简单的引入现有项目中。这就需要在导出时进行配置，在文件名称后加上哈希值后以进行区分。然后将各自目录下的文件复制到对应的目录中去，这样就能各自进行区分，且不会相互覆盖。



#### cocos2d-x引擎的使用

在导出的cocos项目示例中，在AppController.mm文件中对游戏引擎进行了实例化，可知，这是一个单例模式。在笔者的集成过程中，尝试了实例化2个引擎分别加载不同功能，发现并不能达到目的。由此可以推测，一个项目中不能有多个引擎实例。

在cocos项目中，有名称为Appdelegate.cpp的文件（插一句，这文件名一般在我们的项目中有了，所以可以修改这个文件名），其中有加载js的功能，比如：

```
jsb_run_script("main.js");
```

这行代码就是加载目标项目的，如果要加载不同的项目，只需要传入特定的js文件，然后执行即可，这样就可以令cocos2d-x引擎执行不同的功能。

当将js文件做为参数传入后，再调用：

```
//run the cocos2d-x game scene
app->start();
```

这样就可以在不同的功能间进行切换。



### 总结

至此，这篇文章基本就把重点的内容写完了，集成到不同的项目中，必然会遇到不同的问题。有些问题的出现，非常的无厘头，只能通过一步一步的去排查才能找到解决办法。

