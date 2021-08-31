# Swift

### Day 6: Closures, part one

#### Creating basic closures

**One of the most common reasons for closures in Swift is to store functionality** – to be able to say “here’s some work I want you to do at some point, but not necessarily now.” Some examples:

1. Running some code after a delay.
2. Running some code after an animation has finished.
3. Running some code when a download has finished.
4. Running some code when a user has selected an option from your menu.

```swift
let driving = {
    print("I'm driving in my car")
}

driving()
```



#### Accepting parameters in a closure

```swift
let driving = { (place: String) in
    print("I'm going to \(place) in my car")
}

driving("Shang")
```

One of the differences between functions and closures is that you don’t use parameter labels when running closures.



#### Returning values from a closure

```swift
let drivingWithReturn = { (place: String) -> String in
    return "I'm going to \(place) in my car"
}

let t = drivingWithReturn("hhh")
print(t)
```



#### Closures as parameters

```swift
let driving = {
    print("I'm driving in my car")
}

func travel(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived!")
}

travel(action: driving)
```



#### Trailing closure syntax

```swift
let driving = {
    print("I'm driving in my car")
}

func travel(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived!")
}

travel(action: driving)

// trailing closure syntax
travel {
    print("I'm driving in my hourse")
}
```



### Day 7 Closures, part two

#### Using closures as parameters when they accept parameters

```swift
func travel(action: (String) -> Void) {
    print("I'm getting ready to go.")
    action("London")
    print("I arrived!")
}

// trailing closure syntax
travel { (place:String) in
    print("I'm going to \(place) in my car")
}
```

函数接受闭包作为参数，闭包接受参数，这种语法看上去就很“怪”了。



#### Using closures as parameters when they return values

```swift
func travel(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}


travel { (place: String) in
    return "I'm going to \(place) in my car"
}
```



Another example:

```swift
func reduce(_ values: [Int], using closure: (Int, Int) -> Int) -> Int {
    // start with a total equal to the first value
    var current = values[0]

    // loop over all the values in the array, counting from index 1 onwards
    for value in values[1...] {
        // call our closure with the current value and the array element, assigning its result to our current value
        current = closure(current, value)
    }

    // send back the final current value
    return current
}

let numbers = [10, 20, 30]

let sum = reduce(numbers) { (runningTotal: Int, next: Int) in
    runningTotal + next
}

print(sum)
```



#### Shorthand parameter names

```swift
func travel(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}

travel { (place: String) -> String in
    return "I'm going to \(place) in my car"
}

travel { place -> String in
    return "I'm going to \(place) in my car"
}

travel { place in
    return "I'm going to \(place) in my car"
}

travel {
    "I'm going to \($0) in my car"
}
```



#### Closures with multiple parameters

```swift
func travel(action: (String, Int) -> String) {
    print("I'm getting ready to go.")
    let description = action("London", 60)
    print(description)
    print("I arrived!")
}


travel {
    "I'm going to \($0) at \($1) miles per hour."
}
```



#### Returning closures from functions

```swift
func travel() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}


let result = travel()
result("London")

//It’s technically allowable – although really not recommended! – to call the return value from travel() directly:
travel()("Shanghai")
```

感觉很像是命令模式的应用。



#### Capturing values

[More infomation about Closures Capturing values.](https://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/ About Swift Closures)

```swift
func travel() -> (String) -> Void {
    var counter = 1

    return {
        print("\(counter). I'm going to \($0)")
        counter += 1
    }
}

let result = travel()

result("London")
result("London")
result("London")
```



#### Closures summary

1. You can assign closures to variables, then call them later on.
2. Closures can accept parameters and return values, like regular functions.
3. You can pass closures into functions as parameters, and those closures can have parameters of their own and a return value.
4. If the last parameter to your function is a closure, you can use trailing closure syntax.
5. Swift automatically provides shorthand parameter names like `$0` and `$1`, but not everyone uses them.
6. If you use external values inside your closures, they will be captured so the closure can refer to them later.
