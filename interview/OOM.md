# OOM

临近OOM，如何获取内存分配信息及分析问题

## 通过 JetsamEvent 日志计算内存限制值

这种方法APP端是没有权限的，需要从手机的 设置 -> 隐私 -> 分析中看到这些日志，

## 通过 XNU 获取内存限制值

需要root权限，APP是做不到的。获取进程的优先级和内存限值，代码如下：

```Objective-C
typedef struct memorystatus_priority_entry {
  pid_t pid;
  int32_t priority;
  uint64_t user_data;
  int32_t limit;
  uint32_t state;
} memorystatus_priority_entry_t;
```

## 通过内存警告获取内存限制值

```Objective-C
struct mach_task_basic_info info;
mach_msg_type_number_t size = sizeof(info);
kern_return_t kl = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &size);

其中 info.resident_size 表示使用了多少内存，这样我们就知道APP占用了多少内存了。
```

## 定位内存问题信息收集

在APP内的 didReceiveMemoryWarning 去监控，收到系统回调时，大概有6s的时间去处理
内存分配函数 malloc 和 calloc 等默认使用的是 nano_zone。nano_zone 是 256B 以下小内存的分配，大于 256B 的时候会使用 scalable_zone 来分配。

在这里，我主要是针对大内存的分配监控，所以只针对 scalable_zone 进行分析，同时也可以过滤掉很多小内存分配监控。比如，malloc 函数用的是 malloc_zone_malloc，calloc 用的是 malloc_zone_calloc。

这样的话，问题就好解决了，你可以使用 fishhook 去 Hook 这个函数，加上自己的统计记录就能够通盘掌握内存的分配情况。



