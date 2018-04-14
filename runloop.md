

参考[深入理解RunLoop](https://blog.ibireme.com/2015/05/18/runloop/)而画了一个RunLoop的[思维导图](http://naotu.baidu.com/file/38e078659c7f9d8c92e88955c1b47dad?token=2a9366375883ce0f)，

![](./RunLoop.png '')

[官方文档](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html#//apple_ref/doc/uid/10000057i-CH16-SW1)
##作用

RunLoop是一个运行循环，循环里可以处理事件，与接收到的消息；这个运行循环的目的是让线程在有事处理的时候就去处理事情，没有事情处理的时候就进入休眠状态。

##事件来源

[RunLoop的结构图与它的输入源](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Multithreading/Art/runloop.jpg)

![](./runloop_1.jpg '')

1：Input Sources，来自别的线程或者其他应用，这个是异步的事件。

2：Timer Sources，这是同步事件，一般会在预定的时间，或者一定的时间间隔触发。

RunLoop在处理消息或者事件时的行为，在其中某些行为阶段，还会发送通知，注册了这些通知的观察者们，能收到这些通知，并可以在线程内处理额外的事情。


##Run Loop Modes

A run loop mode is a collection of input sources and timers to be monitored and a collection of run loop observers to be notified. 



###Input Sources

Input sources deliver events asynchronously to your threads.有2种类型，分别是**Port-based input sources**, **Custom input sources**.

####Port-based input sources

Port-based sources are signaled automatically by the kernel

####Custom input sources

Custom input sources must be signaled manually form another thread.

