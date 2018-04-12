# iOSReviews
Consider the past, and you shall know the future.


##前言
之前看到band（jspatch作者）的[iOS 开发技术栈与进阶](http://cnbang.net)，其中iOS技术栈部分有张思维导图，写了四个方面，分别是“基础”、“需求”、“质量”和“效率”。
其中“基础”部分的[思维导图](http://naotu.baidu.com/file/946e3aed6dc34ff2336a2cbe3b5338e5?token=1e8e68a9805a0b1b)如下：
![](./base.png 'iOS基础的思维导图')

打算按照这个体系，将网上各路大神的文章学习学习，做个笔记。

###线程
线程是比进程还小的单位，因为进程的切换所耗费的资源相对比较大，所以就有了线程这个东西。一个进程中可以有多个线程。

####锁
锁是为了让多线程操作的结果可预期，防止线程间相互影响而产生不可预期的结果。锁的[基本介绍](./lock.md)。

