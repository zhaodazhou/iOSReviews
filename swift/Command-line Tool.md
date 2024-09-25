# Build a Command-line Tool

通过[官方的一个例子](https://www.swift.org/getting-started/cli-swiftpm/)来说明一下 Command-line Tool 如何创建并使用。

## swift

需要安装 swift，通过其初始化一个工程，命令如下：

```shell
mkdir MyCLI
cd MyCLI
swift package init --name MyCLI --type executable
```

上面的步骤会生成一个 `hello world` 的程序，通过 `swift run MyCLI` 命令可以运行。

## 添加依赖

在 Package.swift 文件中修改，如下：

```swift
import PackageDescription

let package = Package(
    name: "MyCLI",
    dependencies: [
      .package(url: "https://github.com/apple/example-package-figlet", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "MyCLI",
            dependencies: [
                .product(name: "Figlet", package: "example-package-figlet"),
            ],
            path: "Sources"),
    ]
)
```

添加完依赖后，可以通过命令 `swift build` 来指示 SwiftPM 来下载新的依赖并预编译代码。

remove 掉自带的 main.swift 文件，新建 MyCLI.swift 文件，内容如下：

```swift
import Figlet

@main
struct FigletTool {
  static func main() {
    Figlet.say("Hello, Swift!")
  }
}
```

@main 语意 与 main.swift 文件 都可以表示工程的入口处，但只能二者存一，不可同时存在。

通过命令 `swift run` 可以运行此工程，可以见到运行效果。

## 增加输入参数

将 Package.swift 修改为如下：

```swift
import PackageDescription

let package = Package(
    name: "MyCLI",
    dependencies: [
      .package(url: "https://github.com/apple/example-package-figlet", branch: "main"),
      .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "MyCLI",
            dependencies: [
                .product(name: "Figlet", package: "example-package-figlet"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources"),
    ]
)
```

MyCLI.swift 文件修改为如下：

```swift
import Figlet
import ArgumentParser

@main
struct FigletTool: ParsableCommand {
  @Option(help: "Specify the input")
  public var input: String

  public func run() throws {
    Figlet.say(self.input)
  }
}
```

通过命令 `swift run MyCLI --input 'Hello, world!'` 运行后可以看到运行效果。