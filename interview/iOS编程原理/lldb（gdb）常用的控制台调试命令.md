# lldb（gdb）常用的控制台调试命令

在 iOS 开发中，LLDB（Low-Level Debugger）是一个非常强大和流行的调试器，同时也有一部分开发者可能仍然在使用 GDB（GNU Debugger）。LLDB 和 GDB 都提供了丰富的命令行接口，用于控制程序的执行、检查变量、设置断点和调试等操作。以下是一些常用的 LLDB 和 GDB 控制台调试命令。

### LLDB 常用命令

#### 1. 基本信息

- **查看帮助：** 显示 LLDB 的命令帮助。

  ```shell
  (lldb) help
  ```

- **显示当前线程堆栈：** 打印当前线程的堆栈信息，包括调用链。

  ```shell
  (lldb) bt
  (lldb) bt all  # 显示所有线程的堆栈信息
  ```

#### 2. 断点管理

- **设置断点：** 在指定行或方法名处设置断点。

  ```shell
  (lldb) b main  # 在 main 函数设置断点
  (lldb) b MyClass::myMethod  # 在 C++ 类方法设置断点
  (lldb) b -[MyClass myMethod]  # 在 Objective-C 实例方法设置断点
  (lldb) b +[MyClass myMethod]  # 在 Objective-C 类方法设置断点
  (lldb) b FileName.m:42  # 在文件的指定行设置断点
  ```

- **列出断点：** 查看已设置的断点。

  ```shell
  (lldb) break list
  ```

- **删除断点：** 删除指定断点。

  ```shell
  (lldb) break delete 1  # 删除编号为 1 的断点
  ```

- **启用/禁用断点：** 启用或禁用指定断点。

  ```shell
  (lldb) break enable 1
  (lldb) break disable 1
  ```

#### 3. 程序控制

- **继续执行：** 从当前断点继续执行程序。

  ```shell
  (lldb) c
  ```

- **单步执行：** 执行下一行代码；单步进入函数体内。

  ```shell
  (lldb) s
  ```

- **单步跳过：** 执行下一行代码，但不进入函数体内。

  ```shell
  (lldb) n
  ```

- **步骤返回：** 执行直到从当前函数返回。

  ```shell
  (lldb) finish
  ```

#### 4. 检查状态

- **打印变量：** 打印变量的值。

  ```shell
  (lldb) p variableName  # 打印变量
  (lldb) po objectName  # 打印 Objective-C 对象
  ```

- **查看寄存器：** 查看当前寄存器的值。

  ```shell
  (lldb) register read
  ```

- **内存检查：** 查看内存内容。

  ```shell
  (lldb) memory read address  # 查看指定地址的内存内容
  ```

#### 5. 表达式求值

- **执行表达式：** 动态执行表达式并返回结果。

  ```shell
  (lldb) expr (int)myVariable
  (lldb) expr (void)printf("Debug message\n")
  ```

### GDB 常用命令

#### 1. 基本信息

- **查看帮助：** 显示 GDB 的命令帮助。

  ```shell
  (gdb) help
  ```

- **显示当前线程堆栈：** 打印当前线程的堆栈信息，包括调用链。

  ```shell
  (gdb) bt
  ```

#### 2. 断点管理

- **设置断点：** 在指定行或方法名处设置断点。

  ```shell
  (gdb) break main  # 在 main 函数设置断点
  (gdb) break MyClass::myMethod  # 在 C++ 类方法设置断点
  (gdb) break -[MyClass myMethod]  # 在 Objective-C 实例方法设置断点
  (gdb) break +[MyClass myMethod]  # 在 Objective-C 类方法设置断点
  (gdb) break FileName.m:42  # 在文件的指定行设置断点
  ```

- **列出断点：** 查看已设置的断点。

  ```shell
  (gdb) info breakpoints
  ```

- **删除断点：** 删除指定断点。

  ```shell
  (gdb) delete 1  # 删除编号为 1 的断点
  ```

- **启用/禁用断点：** 启用或禁用指定断点。

  ```shell
  (gdb) enable breakpoints 1
  (gdb) disable breakpoints 1
  ```

#### 3. 程序控制

- **继续执行：** 从当前断点继续执行程序。

  ```shell
  (gdb) c
  ```

- **单步执行：** 执行下一行代码；单步进入函数体内。

  ```shell
  (gdb) s
  ```

- **单步跳过：** 执行下一行代码，但不进入函数体内。

  ```shell
  (gdb) n
  ```

- **步骤返回：** 执行直到从当前函数返回。

  ```shell
  (gdb) finish
  ```

#### 4. 检查状态

- **打印变量：** 打印变量的值。

  ```shell
  (gdb) p variableName  # 打印变量
  (gdb) po objectName  # 打印 Objective-C 对象
  ```

- **查看寄存器：** 查看当前寄存器的值。

  ```shell
  (gdb) info registers
  ```

- **内存检查：** 查看内存内容。

  ```shell
  (gdb) x /fmt address  # 查看指定地址的内存内容，其中 fmt 为格式说明符（如 x、i、u等）
  ```

#### 5. 表达式求值

- **执行表达式：** 动态执行表达式并返回结果。

  ```shell
  (gdb) print (int)myVariable
  (gdb) call (void)printf("Debug message\n")
  ```

### 总结

LLDB 和 GDB 都是强大的调试工具，掌握这些工具的常用命令，可以帮助开发者在调试 iOS 应用时更加高效，定位和解决问题更快捷。无论是设置断点、控制程序执行、检查变量状态，还是执行表达式，这些命令都可以极大地提升调试的效率和准确性。
