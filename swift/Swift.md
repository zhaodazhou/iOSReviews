# Swift

- [Closures](./Closures.md)
- [Struct](./Struct.md)
- [Class](./Class.md)
- [Protocols and extensions](./Protocols%20and%20extensions.md)






### Day 12 optionals, unwrapping, and typecasting

#### Handling missing data

```swift
var age: Int? = nil
age = 1

// error
var age: Int = nil
```



#### Unwrapping optionals

```swift
var name: String? = nil

if let unwrapped = name {
    print("\(unwrapped.count) letters")
} else {
    print("Missing name.")
}
```



#### Unwrapping with guard

```swift
func greet(_ name: String?) {
    guard let unwrapped = name else {
        print("You didn't provide a name!")
        return
    }

    print("Hello, \(unwrapped)!")
}
```



#### Force unwrapping

```
let str = "5"
let num = Int(str)

// Or
let num = Int(str)!

```



#### Implicitly unwrapped optionals

Implicitly unwrapped optionals are created by adding an exclamation mark after your type name, like this:

```swift
let age: Int! = nil
```

Because they behave as if they were already unwrapped, you don’t need `if let` or `guard let` to use implicitly unwrapped optionals. However, if you try to use them and they have no value – if they are `nil` – your code crashes.



#### Nil coalescing

If there *isn’t* a value – if the optional was `nil` – then a default value is used instead.

```swift
func username(for id: Int) -> String? {
    if id == 1 {
        return "Taylor Swift"
    } else {
        return nil
    }
}


// Nil coalescing
let user = username(for: 15) ?? "Anonymous"
```



#### Optional chaining

Swift provides us with a shortcut when using optionals: if you want to access something like `a.b.c` and `b` is optional, you can write a question mark after it to enable *optional chaining*: `a.b?.c`.

When that code is run, Swift will check whether `b` has a value, and if it’s `nil` the rest of the line will be ignored – Swift will return `nil` immediately. But if it *has* a value, it will be unwrapped and execution will continue.



#### Optional try

```swift
if let result = try? checkPassword("password") {
    print("Result was \(result)")
} else {
    print("D'oh.")
}
```

The other alternative is `try!`, which you can use when you know for sure that the function will not fail. If the function *does* throw an error, your code will crash.

```swift
try! checkPassword("sekrit")
print("OK!")
```



#### Failable initializers

This is a *failable initializer*: an initializer that might work or might not. You can write these in your own structs and classes by using `init?()` rather than `init()`, and return `nil` if something goes wrong. 

```swift
struct Person {
    var id: String

    init?(id: String) {
        if id.count == 9 {
            self.id = id
        } else {
            return nil
        }
    }
}
```



#### Typecasting

This uses a new keyword called `as?`, which returns an optional: it will be `nil` if the typecast failed, or a converted type otherwise.

Here’s how we write the loop in Swift:

```swift
for pet in pets {
    if let dog = pet as? Dog {
        dog.makeNoise()
    }
}
```



Type casting lets us tell Swift that an object it thinks is type A is actually type B, which is helpful when working with protocols and class inheritance.



#### Optionals summary

let’s summarize:

1. Optionals let us represent the absence of a value in a clear and unambiguous way.
2. Swift won’t let us use optionals without unwrapping them, either using `if let` or using `guard let`.
3. You can force unwrap optionals with an exclamation mark, but if you try to force unwrap `nil` your code will crash.
4. Implicitly unwrapped optionals don’t have the safety checks of regular optionals.
5. You can use nil coalescing to unwrap an optional and provide a default value if there was nothing inside.
6. Optional chaining lets us write code to manipulate an optional, but if the optional turns out to be empty the code is ignored.
7. You can use `try?` to convert a throwing function into an optional return value, or `try!` to crash if an error is thrown.
8. If you need your initializer to fail when it’s given bad input, use `init?()` to make a failable initializer.
9. You can use typecasting to convert one type of object to another.
