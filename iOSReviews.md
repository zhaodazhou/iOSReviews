# iOSReviews

## 前言
之前看到band（jspatch作者）的[iOS 开发技术栈与进阶](http://cnbang.net)，其中iOS技术栈部分有张思维导图，写了四个方面，分别是“基础”、“需求”、“质量”和“效率”。
其中“基础”部分的[思维导图](http://naotu.baidu.com/file/946e3aed6dc34ff2336a2cbe3b5338e5?token=1e8e68a9805a0b1b)如下：


打算按照这个体系，将网上各路大神的文章学习，做个笔记。

### 线程
线程是比进程还小的单位，因为进程的切换所耗费的资源相对比较大，所以就有了线程这个东西。一个进程中可以有多个线程。

### RunLoop

官方定义
```
A run loop is an event processing loop that you use to schedule work and coordinate the receipt of incoming events. The purpose of a run loop is to keep your thread busy when there is work to do and put your thread to sleep when there is none.
```
[基本介绍](./runloop.md)。

### 锁
锁是为了让多线程操作的结果可预期，防止线程间相互影响而产生不可预期的结果。锁的[基本介绍](./lock.md)。

### Cache

缓存一般是三级缓存：内存——磁盘——服务，在此做个[记录](./cache.md)。
