多线程运行的情况下，线程A和线程B分别对某个变量进行写操作，同时，线程C对该变量进行读操作；因为线程的并发顺序是不确定的，这就会导致线程C可能会读到线程A写入的结果，或者是线程B写入的结果，这就导致结果的未知性。

锁的[思维导图](http://naotu.baidu.com/file/0e51cc28bf7363380e9c619f64a7e670)如下：![](./lock.png '锁的思维导图')


1. 锁

1.1 目标

确保线程安全，预防线程间对资源的操作产生不可预期的结果。

1.2 死锁

锁不是可以随便用的，用不好会产生死锁。

简单来说，线程A持有资源A，它想要访问资源B；与此同时，线程B持有资源B，它想要访问资源A，这就在线程A与线程B之间形成了一个欲望环，各自都在等待对方释放所持有的资源，而各自都不自动释放持有的资源，这就导致这2个线程一直处于这种阻塞状态。这明显不是我们想要的结果。
