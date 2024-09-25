# Build a library

## 创建工程

```shell
mkdir MyLibrary
cd MyLibrary
swift package init --name MyLibrary --type library
```

## 修改内容

将 MyLibrary.swift 中内容修改为:

```swift
import Foundation

struct Email: CustomStringConvertible {
  var description: String

  public init(_ emailString: String) throws {
    let regex = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#
    guard let _ = emailString.range(of: regex, options: .regularExpression) else {
      throw InvalidEmailError(email: emailString)
    }
    self.description = emailString
  }
}

private struct InvalidEmailError: Error {
  let email: String
}
```

将 MyLibraryTests.swift 修改为如下：

```swift
@testable import MyLibrary
import XCTest

final class MyLibraryTests: XCTestCase {
  func testEmail() throws {
    let email = try Email("john.appleseed@apple.com")
    XCTAssertEqual(email.description, "john.appleseed@apple.com")

    XCTAssertThrowsError(try Email("invalid"))
  }
}
```

## 自测

通过命令 `swift test` 可以运行测试用例，判断提供的函数是否正确。