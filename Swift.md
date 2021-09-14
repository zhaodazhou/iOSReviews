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





### Day 8 Structs, part one

#### Creating your own structs

#### Computed properties

```swift
struct Sport {
    var name: String
    var isOlympicSport: Bool

    var olympicStatus: String {
        if isOlympicSport {
            return "\(name) is an Olympic sport"
        } else {
            return "\(name) is not an Olympic sport"
        }
    }
}
```

Properties let us attach information to structs, and Swift gives us two variations: stored properties, where a value is stashed away in some memory to be used later, and computed properties, where a value is recomputed every time it’s called.



#### Property observers

```swift
struct Progress {
    var task: String
    var amount: Int {
        willSet {
            print("\(task) is will \(amount)% complete")
        }
        didSet {
            print("\(task) is now \(amount)% complete")
        }
    }
}
```

The most important reason is *convenience*: using a property observer means your functionality will be executed whenever the property changes.

There is *one* place where using a property observer is a bad idea, and that’s if you put slow work in there.



#### Methods

```swift
struct City {
    var population: Int

    func collectTaxes() -> Int {
        return population * 1000
    }
}

let london = City(population: 9_000_000)
london.collectTaxes()
```

##### What’s the difference between a function and a method?

Honestly, the only real difference is that methods belong to a type, such as structs, enums, and classes, whereas functions do not.

Heck, they are so similar that Swift still uses the `func` keyword to define a method.



#### Mutating methods

If a struct has a variable property but the instance of the struct was created as a constant, that property can’t be changed – the struct is constant, so all its properties are also constant regardless of how they were created.

```swift
struct Person {
    var name: String

    mutating func makeAnonymous() {
        name = "dd"
    }
}

var person = Person(name: "dz")
person.name = "dd"
// or
person.makeAnonymous()
```

There are two important details you’ll find useful:

- Marking methods as `mutating` will stop the method from being called on constant structs, even if the method itself doesn’t actually change any properties. If you say it changes stuff, Swift believes you!

- A method that is *not* marked as mutating cannot call a mutating function – you must mark them both as mutating.

  

#### Properties and methods of strings

String and Array is Struct.



### Day 9 Structs, part two

#### Initializers

```swift
struct User {
    var username: String
}

var user = User(username: "twostraws")

```



Or:

```swift
struct User {
    var username: String

    init() {
    //You don’t write func before initializers, but you do need to make sure all properties have a value before the initializer ends.
        username = "Anonymous"
        print("Creating a new user!")
    }
}

var user = User()
user.username = "twostraws"
```



First, if any of your properties have default values, then they’ll be incorporated into the initializer as default parameter values. 

The second clever thing Swift does is *remove* the memberwise initializer if you create an initializer of your own.

So, as soon as you add a custom initializer for your struct, the default memberwise initializer goes away. If you want it to stay, move your custom initializer to an extension.



#### Referring to the current instance

Use **self** keyword.



#### Static properties and methods

```swift
struct Student {
    static var classSize = 0
    var name: String

    init(name: String) {
        self.name = name
        Student.classSize += 1
    }
}

print(Student.classSize)

```

#### Access control

If Struces has a private property, then Swift is unable to generate its memberwise initializer for us.



#### Structs summary

1. You can create your own types using structures, which can have their own properties and methods.
2. You can use stored properties or use computed properties to calculate values on the fly.
3. If you want to change a property inside a method, you must mark it as `mutating`.
4. Initializers are special methods that create structs. You get a memberwise initializer by default, but if you create your own you must give all properties a value.
5. Use the `self` constant to refer to the current instance of a struct inside a method.
6. The `lazy` keyword tells Swift to create properties only when they are first used.
7. You can share properties and methods across all instances of a struct using the `static` keyword.
8. Access control lets you restrict what code can use properties and methods.





### Day 10 Classes

Classes and Structs have five important differences:

- Classes do not come with synthesized memberwise initializers.

- One class can be built upon (“inherit from”) another class, gaining its properties and methods.

- Copies of structs are always unique, whereas copies of classes actually point to the same shared data.

- Classes have deinitializers, which are methods that are called when an instance of the class is destroyed, but structs do not.

  [So, the simple reason for why structs don’t have deinitializers is because they don’t need them: each struct has its own copy of its data, so nothing special needs to happen when it is destroyed.]

- Variable properties in constant classes can be modified freely, but variable properties in constant structs cannot.



let’s summarize:

1. Classes and structs are similar, in that they can both let you create your own types with properties and methods.
2. One class can inherit from another, and it gains all the properties and methods of the parent class. It’s common to talk about class hierarchies – one class based on another, which itself is based on another.
3. You can mark a class with the `final` keyword, which stops other classes from inheriting from it.
4. Method overriding lets a child class replace a method in its parent class with a new implementation.
5. When two variables point at the same class instance, they both point at the same piece of memory – changing one changes the other.
6. Classes can have a deinitializer, which is code that gets run when an instance of the class is destroyed.
7. Classes don’t enforce constants as strongly as structs – if a property is declared as a variable, it can be changed regardless of how the class instance was created.



### Day 11 Protocols and extensions

#### Protocols

Protocols are a way of describing what properties and methods something must have. You then tell Swift which types use that protocol – a process known as adopting or conforming to a protocol.

```swift
protocol Identifiable {
    var id: String { get set }
}

struct User: Identifiable {
    var id: String
    
    func displayID(thing: Identifiable) {
        print("My ID is \(thing.id)")
    }
}
```

#### Protocol inheritance

```swift
protocol Payable {
    func calculateWages() -> Int
}

protocol NeedsTraining {
    func study()
}

protocol HasVacation {
    func takeVacation(days: Int)
}

protocol Employee: Payable, NeedsTraining, HasVacation { }


struct ZooEmplyee : Employee {
    func calculateWages() -> Int {
        return 1
    }
    
    func study() {
        
    }
    
    func takeVacation(days: Int) {
        
    }
}
```



#### Extensions

```swift
extension Int {
    func squared() -> Int {
        return self * self
    }
}

let number = 8
print(number.squared())

//Swift doesn’t let you add stored properties in extensions, so you must use computed properties instead.
extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}

print(number.isEven)
```



#### Protocol extensions

```swift
extension Collection {
    func summarize() {
        print("There are \(count) of us:")

        for name in self {
            print(name)
        }
    }
}
```



#### Protocol-oriented programming

protocol-oriented programming (**POP**) and object-oriented programming (OOP) 

In fact, the only important difference between the two is one of mindset: POP developers lean heavily on the protocol extension functionality of Swift to build types that get a lot of their behavior from protocols. This makes it easier to share functionality across many types, which in turn lets us build bigger, more powerful software without having to write so much code.



#### Protocols and extensions summary

So let’s summarize:

1. Protocols describe what methods and properties a conforming type must have, but don’t provide the implementations of those methods.
2. You can build protocols on top of other protocols, similar to classes.
3. Extensions let you add methods and computed properties to specific types such as `Int`.
4. Protocol extensions let you add methods and computed properties to protocols.
5. Protocol-oriented programming is the practice of designing your app architecture as a series of protocols, then using protocol extensions to provide default method implementations.





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
