
# Struct

## Structs, part one

### Creating your own structs

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

### Property observers

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

### Methods

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

### What’s the difference between a function and a method?

Honestly, the only real difference is that methods belong to a type, such as structs, enums, and classes, whereas functions do not.

Heck, they are so similar that Swift still uses the `func` keyword to define a method.

### Mutating methods

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

### Properties and methods of strings

String and Array is Struct.

## Structs, part two

### Initializers

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

### Referring to the current instance

Use **self** keyword.

### Static properties and methods

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
