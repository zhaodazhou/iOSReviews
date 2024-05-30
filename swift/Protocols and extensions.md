# Protocols and extensions

## Protocols

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

### Protocol inheritance

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

## Extensions

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

## Protocol extensions

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

## Protocol-oriented programming

protocol-oriented programming (**POP**) and object-oriented programming (OOP)  

In fact, the only important difference between the two is one of mindset: POP developers lean heavily on the protocol extension functionality of Swift to build types that get a lot of their behavior from protocols. This makes it easier to share functionality across many types, which in turn lets us build bigger, more powerful software without having to write so much code.

## Protocols and extensions summary

So let’s summarize:

1. Protocols describe what methods and properties a conforming type must have, but don’t provide the implementations of those methods.
2. You can build protocols on top of other protocols, similar to classes.
3. Extensions let you add methods and computed properties to specific types such as `Int`.
4. Protocol extensions let you add methods and computed properties to protocols.
5. Protocol-oriented programming is the practice of designing your app architecture as a series of protocols, then using protocol extensions to provide default method implementations.
