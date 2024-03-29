# SwiftUI

### Day 16

#### NavigationView

```swift
NavigationView {
            Form {
                Group {
                    Text("Hello world!")
                }
            }
            .navigationBarTitle(Text("test"), displayMode: .inline)
        }
```



#### @State

```swift
@State var tapCount = 0
    
    var body: some View {
        Button("Tap Count: \(tapCount)") {
            self.tapCount += 1
        }
    }
```



#### Binding state to user interface controls

```swift
@State private var name = ""
    
    var body: some View {
        Form {
            TextField("Enter your name", text: $name)
            Text("Hello \(name)")
        }
    }
```



#### Creating views in a loop

```swift
let students = ["Harry", "Hermione", "Ron"]
    @State private var selectedStudent = 0
    
    var body: some View {
        VStack {
            Picker("Select your student", selection: $selectedStudent) {
                ForEach(0 ..< students.count) {
                    Text(self.students[$0])
                }
            }
            Text("You chose: Student # \(students[selectedStudent])")
        }
    }
```



### Day 17

#### Reading text from the user with TextField

```swift
@State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    let tipPercentages = [10, 15, 20, 25, 0]

    
    var body: some View {
        Form {
            Section {
                TextField("Amount", text: $checkAmount)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Text("$\(checkAmount)")
            }
        }
    }
```



#### Creating pickers in a form

```swift
@State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    let tipPercentages = [10, 15, 20, 25, 0]

    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Text("$\(checkAmount)")
                }
            }
            .navigationBarTitle("WeSplit")

        }
    }
```

The Picker inside Form or not, show different view. Here, though, it told SwiftUI that this is a form for user input.

Besides, NavigationView will add feature to go to next page on Picker.



#### Adding a segmented control for tip percentages

```swift
@State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    let tipPercentages = [10, 15, 20, 25, 0]

    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                   

                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                }
                
                Section {
                    Text("$\(checkAmount)")
                }
            }
            .navigationBarTitle("WeSplit")

        }
    }
```



#### Calculating the total per person

```swift
@State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson:Double {
        // calculate the total per person here
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                   

                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                }
                
                Section {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("WeSplit")

        }
    }
```

var totalPerPerson is a **computed property**.



### Day 18

#### WeSplit: Wrap up

```swift
@State private var checkAmount = ""
//    @State private var numberOfPeople = 2
    @State private var numberOfPeopleString = "1"

    @State private var tipPercentage = 2
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson:Double {
        // calculate the total per person here
//        let peopleCount = Double(numberOfPeople + 2)
        let peopleCount = Double(numberOfPeopleString) ?? 1
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0

        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalAmount:Double {
//        return totalPerPerson * Double((numberOfPeople + 2))
        return totalPerPerson * (Double(numberOfPeopleString) ?? 1)
    }
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
//                    Picker("Number of people", selection: $numberOfPeople) {
//                        ForEach(2 ..< 100) {
//                            Text("\($0) people")
//                        }
//                    }
                    
                    TextField("Number of people", text: $numberOfPeopleString).keyboardType(.numberPad)
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                   

                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                
                Section {
                    Text("Total amount \(totalAmount, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("WeSplit")

        }
    }
```



### Day 20

#### Colors and frames

```swift
var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.bottom)
            Text("Your content")
                .background(Color.red)
        }
        
    }
```



#### Gradients 

```swift
LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
        
RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 20, endRadius: 200)
    
AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)

```



#### Buttons and images

```swift
var body: some View {
        Button("Tap me") {
            print("Was Tapped")
        }
        
        Button(action: {
            print("Was Tapped")
        }, label: {
            Image(systemName: "pencil")
            Image(systemName: "pencil")
            Image(systemName: "pencil")

            Text("Button")

        })
        
        Button(action: {
            print("Was Tapped")
        }) {
            HStack(spacing:30) {
                Image(systemName: "pencil")
                Text("Button")
            }
        }
    }
```



#### Showing alert messages

```swift
@State private var showingAlert = false

    var body: some View {
        Button("Show Alert") {
            self.showingAlert = true
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Hello SwiftUI!"), message: Text("This is some detail message"), dismissButton: .default(Text("OK")))
        }
    }
```



### Day 21

#### Stacking up buttons

```swift
@State private var showingAlert = false
    var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    var correctAnswer = Int.random(in: 0...2)

    var body: some View {
        
        ZStack {
          // 颜色设置放在ZStack中，而不是VStack中，是因为在后者中，会占据部分空间。
          // Because Colors are views in SwiftUI
            Color.blue.edgesIgnoringSafeArea(.all)

            VStack(spacing:30) {

                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(countries[correctAnswer]).foregroundColor(.white)
                    
                    ForEach(0 ..< 3) { number in
                        Button(action: {
                            // flag was tapped
                        }) {
                            Image(self.countries[number])
                                .renderingMode(.original)
                        }
                    }
                }
            }
        }
    }
```



#### Showing the player’s score with an alert

```swift
@State private var showingAlert = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""

    var body: some View {
        
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)

            VStack(spacing:30) {

                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(countries[correctAnswer]).foregroundColor(.white)
                    
                    ForEach(0 ..< 3) { number in
                        Button(action: {
                            self.flagTapped(number)
                        }) {
                            Image(self.countries[number])
                                .renderingMode(.original)
                        }
                    }
                }
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is ???"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }

        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
```

#### Styling our flags

```swift
@State private var showingAlert = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""

    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing:30) {

                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(countries[correctAnswer]).foregroundColor(.white).font(.largeTitle)
                        .fontWeight(.black)
                    
                    ForEach(0 ..< 3) { number in
                        Button(action: {
                            self.flagTapped(number)
                        }) {
                            Image(self.countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                                .shadow(color: .red, radius: 6)
                        }
                    }
                }
            }

        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is ???"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }

        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
```



### Day 23

#### Views and modifiers: Introduction

#### Why does SwiftUI use structs for views?

First, there is an element of performance: structs are simpler and faster than classes.

it forces us to think about isolating state in a clean way. 

#### What is behind the main SwiftUI view?



#### Why modifier order matters

Whenever we apply a modifier to a SwiftUI view, we actually create a new view with that change applied – we don’t just modify the existing view in place. 

#### Why does SwiftUI use “some View” for its view type?

Returning `some View` has two important differences compared to just returning `View`:

1. We must always return the same type of view.

2. Even though we don’t know what view type is going back, the compiler does.

   

   The first difference is important for performance.

   The second difference is important because of the way SwiftUI builds up its data using `ModifiedContent`.

What `some View` lets us do is say “this will return one specific type of view, such as `Button` or `Text`, but I don’t want to say what.”



#### Conditional modifiers

```swift
@State private var useRedText = false

    var body: some View {
        Button("Hello World") {
            // flip the Boolean between true and false
            self.useRedText.toggle()            
        }
        .foregroundColor(useRedText ? .red : .blue)
    }
```

#### Environment modifiers

```swift
				VStack {
            Text("Gryffindor").font(.largeTitle)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .font(.title)	
```

#### Views as properties

```swift
		let motto1 = Text("123")
		let motto2 = Text("nunquam titillandus")
    
    var body: some View {
        VStack {
            motto1.foregroundColor(.red)
            motto2.font(.largeTitle)
        }
    }
```

Swift doesn’t let us create one stored property that refers to other stored properties, because it would cause problems when the object is created. This means trying to create a `TextField` bound to a local property will cause problems.

However, you can create *computed* properties if you want, like this:

```swift
		var tmp = "dz"
    let motto2 = Text("nunquam titillandus")
    //computed properties
    var motto1: some View { Text("Draco \(tmp)") }

    var body: some View {
        VStack {
            motto1.foregroundColor(.red)
            motto2.font(.largeTitle)
        }
    }
```

#### View composition

```swift
struct CapsuleText: View {
    var text1: String = ""
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 10) {
            CapsuleText(text1: "1", text: "2")
            CapsuleText(text: "Second")
        }
    }
}
```

#### Custom modifiers

```swift

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Hello World")
                .modifier(Title())
        }
    }
}
```

When working with custom modifiers, it’s usually a smart idea to create extensions on `View` that make them easier to use.

```swift

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Hello World")
                .titleStyle()
        }
    }
}
```

Remember, modifiers return new objects rather than modifying existing ones, so we could create one that embeds the view in a stack and adds another view:

```swift

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}


struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Hello World")
                .watermarked(with: "s")
        }
    }
}
```

#### Custom containers

```swift
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}


struct ContentView: View {
    
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            Text("R\(row) C\(col)")
        }
    }
}
```

Our `GridStack` is capable of accepting any kind of cell content, as long as it conforms to the `View` protocol. So, we could give cells a stack of their own if we wanted:

```swift

struct ContentView: View {
    
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            HStack {
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
            }
        }
    }
}

```



For more flexibility we could leverage one of SwiftUI’s features called *view builders*, which allows us to send in several views and have it form an implicit stack for us.

```swift
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    // 类似构造函数
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}


struct ContentView: View {
    
    var body: some View {
//        GridStack(rows: 4, columns: 4) { row, col in
//            HStack {
//                Image(systemName: "\(row * 4 + col).circle")
//                Text("R\(row) C\(col)")
//            }
//        }
        
        GridStack(rows: 4, columns: 4) { row, col in
            Image(systemName: "\(row * 4 + col).circle")
            Text("R\(row) C\(col)")
        }
    }
}
```



### Day 25 Milestone: Projects 1-3

Remember, all something needs to do in order to conform to the `View` protocol is to have a single computed property called `body` that returns `some View`.



#### Key points

##### Structs vs classes

There are five key differences between structs and classes:

1. Classes don’t come with a memberwise initializer; structs get these by default.
2. Classes can use inheritance to build up functionality; structs cannot.
3. If you copy a class, both copies point to the same data; copies of structs are always unique.
4. Classes can have deinitializers; structs cannot.
5. You can change variable properties inside constant classes; properties inside constant structs are fixed regardless of whether the properties are constants or variables.



##### Working with ForEach

```swift
let agents = ["Cyril", "Lana", "Pam", "Sterling"]

VStack {
    ForEach(0 ..< agents.count) {
        Text(self.agents[$0])
    }
    
    ForEach(agents, id: \.self) {
        Text($0)
    }
}
```



##### Working with bindings

```swift
struct ContentView: View {
    @State var selection = 0

    var body: some View {
        let binding = Binding(
            get: { self.selection },
            set: { self.selection = $0 }
        )

        return VStack {
            Picker("Select a number", selection: binding) {
                ForEach(0 ..< 3) {
                    Text("Item \($0)")
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}
```

So, that binding is effectively just acting as a passthrough – it doesn’t store or calculate any data itself, but just acts as a shim between our UI and the underlying state value that is being manipulated.



```swift
		@State var agreedToTerms = false
    @State var agreedToPrivacyPolicy = false
    @State var agreedToEmails = false
    
    
    var body: some View {
        let agreedToAll = Binding<Bool>(
            get: {
                self.agreedToTerms && self.agreedToPrivacyPolicy && self.agreedToEmails
            },
            set: {
                self.agreedToTerms = $0
                self.agreedToPrivacyPolicy = $0
                self.agreedToEmails = $0
            }
        )

        
        VStack {
            Toggle(isOn: $agreedToTerms) {
                Text("Agree to terms")
            }
            
            Toggle(isOn: $agreedToPrivacyPolicy) {
                Text("Agree to privacy policy")
            }
            
            Toggle(isOn: $agreedToEmails) {
                Text("Agree to receive shipping emails")
            }
            
            Toggle(isOn: agreedToAll) {
                Text("Agree to all")
            }
        }	
```



#### Challenge



### Day 26

#### Entering numbers with Stepper

```swift
	@State private var sleepAmount = 8.0

    var body: some View {
        Stepper(value: $sleepAmount, in: 4...12, step:0.25) {
            Text("\(sleepAmount, specifier: "%g") hours")
        }
    }
```

#### Selecting dates and times with DatePicker

```swift
	@State private var wakeUp = Date()

    var body: some View {
        // when you create a new Date instance it will be set to the current date and time
        let now = Date()

        // create a second Date instance set to one day in seconds from now
        let tomorrow = Date().addingTimeInterval(86400)

        // create a range from those two
        let range = now ... tomorrow
        
        Form {
            DatePicker("Please enter a date", selection: $wakeUp, in : range, displayedComponents: .date)
                .labelsHidden()
            DatePicker("Please enter a date", selection: $wakeUp, in : now...)
        }
    }
```

#### Working with dates

```swift
let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
let hour = components.hour ?? 0
let minute = components.minute ?? 0
```





```swift
let formatter = DateFormatter()
formatter.timeStyle = .short
let dateString = formatter.string(from: Date())
```



#### Training a model with Create ML



### Day 27

But, as Andre Gide said, “you cannot discover new oceans unless you have the courage to lose sight of the shore.”

#### [Building a basic layout](https://www.hackingwithswift.com/books/ios-swiftui/building-a-basic-layout)

```swift
struct ContentView: View {
    @State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:.hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(value: $coffeeAmount, in: 1...20, step: 1) {
                    if coffeeAmount == 1 {
                        Text("1 cup")
                    } else {
                        Text("\(coffeeAmount) cups")
                    }
                }
            }
            
            .navigationTitle("BetterRest")
            .navigationBarItems(trailing:
                                    HStack {
                                        Button("Calculate") {
                                            self.calculateBedtime()
                                        }
                                        
                                        Button(action: calculateBedtime, label: {
                                            Text("Calculate")
                                        })
                                        
                                        Button(action: calculateBedtime) {
                                            Text("Calculate")
                                        }
                                    }
            )
        }
    }
    
    func calculateBedtime() {
        
        
    }
}
```



#### [Connecting SwiftUI to Core ML](https://www.hackingwithswift.com/books/ios-swiftui/connecting-swiftui-to-core-ml)

```swift
struct ContentView: View {
    @State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:.hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(value: $coffeeAmount, in: 1...20, step: 1) {
                    if coffeeAmount == 1 {
                        Text("1 cup")
                    } else {
                        Text("\(coffeeAmount) cups")
                    }
                }
            }
            
            .navigationTitle("BetterRest")
            .navigationBarItems(trailing:
                                    Button(action: calculateBedtime) {
                                        Text("Calculate")
                                    }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep

            let formatter = DateFormatter()
            formatter.timeStyle = .short

            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"
            showingAlert = true

        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            showingAlert = true

        }
    }
}
```



#### Cleaning up the user interface

```swift
struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:.hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                    
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper(value: $coffeeAmount, in: 1...20, step: 1) {
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
            }
            
            .navigationTitle("BetterRest")
            .navigationBarItems(trailing:
                                    Button(action: calculateBedtime) {
                                        Text("Calculate")
                                    }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep

            let formatter = DateFormatter()
            formatter.timeStyle = .short

            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}

```



https://www.youtube.com/watch?v=a905KIBw1hs This is a video about Create ML for Everyone.

### Day 28

#### BetterRest: Wrap up

1. Change the user interface so that it always shows their recommended bedtime using a nice and large font. You should be able to remove the “Calculate” button entirely.

   ```swift
   
   struct GridStack: View {
       
       let wakeUp : Date
       let sleepAmount : Double
       let coffeeAmount : Int
       
       var sleepTime:String {
           var t = calculateBedtime()
           return t
       }
       
       var body: some View {
           Text("\(sleepTime)")
       }
       
       func calculateBedtime() -> String {
           let model = SleepCalculator()
           
           let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
           let hour = (components.hour ?? 0) * 60 * 60
           let minute = (components.minute ?? 0) * 60
           
           do {
               let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
               let sleepTime = wakeUp - prediction.actualSleep
   
               let formatter = DateFormatter()
               formatter.timeStyle = .short
   
               return formatter.string(from: sleepTime)
           } catch {
               return "Error"
           }
       }
   }
   
   struct ContentView: View {
       @State private var wakeUp = defaultWakeTime
       @State private var sleepAmount = 8.0
       @State private var coffeeAmount = 1
   
       
       static var defaultWakeTime: Date {
           var components = DateComponents()
           components.hour = 7
           components.minute = 0
           return Calendar.current.date(from: components) ?? Date()
       }
   
       var body: some View {
           NavigationView {
               Form {
                   Section(header: Text("When do you want to wake up?")) {
                       
                       DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:.hourAndMinute)
                           .labelsHidden()
                           .datePickerStyle(WheelDatePickerStyle())
                   }
                   
                   VStack(alignment: .leading, spacing: 0) {
                       Text("Desired amount of sleep")
                           .font(.headline)
                       Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                           Text("\(sleepAmount, specifier: "%g") hours")
                       }
                   }
                   
                   VStack(alignment: .leading, spacing: 0) {
                       Picker("Daily coffee intake", selection: $coffeeAmount) {
                           ForEach(0 ..< 20) {index in
                               if index < 1 {
                                   Text("\(index) cup")
                               } else {
                                   Text("\(index) cups")
                               }
                           }
                       }
                   }
                   
                   Section(header: Text("Your ideal bedtime is:").foregroundColor(.green)) {
                       GridStack(wakeUp: wakeUp, sleepAmount: sleepAmount, coffeeAmount: coffeeAmount).foregroundColor(.green)
                   }
               }
               
               .navigationTitle("BetterRest")
           }
       }
   }
   ```

   Or, more simple solution like:

   ```swift
   struct ContentView: View {
       @State private var wakeUp = defaultWakeTime
       @State private var sleepAmount = 8.0
       @State private var coffeeAmount = 1
       
       var sleepTime:String {
           let t = calculateBedtime()
           return t
       }
       
       static var defaultWakeTime: Date {
           var components = DateComponents()
           components.hour = 7
           components.minute = 0
           return Calendar.current.date(from: components) ?? Date()
       }
   
       var body: some View {
           NavigationView {
               Form {
                   Section(header: Text("When do you want to wake up?")) {
                       
                       DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:.hourAndMinute)
                           .labelsHidden()
                           .datePickerStyle(WheelDatePickerStyle())
                   }
                   
                   VStack(alignment: .leading, spacing: 0) {
                       Text("Desired amount of sleep")
                           .font(.headline)
                       Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                           Text("\(sleepAmount, specifier: "%g") hours")
                       }
                   }
                   
                   VStack(alignment: .leading, spacing: 0) {
                       Picker("Daily coffee intake", selection: $coffeeAmount) {
                           ForEach(0 ..< 20) {index in
                               if index < 1 {
                                   Text("\(index) cup")
                               } else {
                                   Text("\(index) cups")
                               }
                           }
                       }
                   }
                   
                   Text("\(sleepTime)")
               }
               
               .navigationTitle("BetterRest")
           }
       }
       
       
       func calculateBedtime() -> String {
           let model = SleepCalculator()
           
           let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
           let hour = (components.hour ?? 0) * 60 * 60
           let minute = (components.minute ?? 0) * 60
           
           do {
               let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
               let sleepTime = wakeUp - prediction.actualSleep
   
               let formatter = DateFormatter()
               formatter.timeStyle = .short
   
               return formatter.string(from: sleepTime)
           } catch {
               return "Error"
           }
       }
   }
   ```

   

### Day 29 Project 5, part 1

#### Introducing List, your best friend

```swift
struct ContentView: View {
    var body: some View {
        let people = ["Finn", "Leia", "Luke", "Rey"]

        VStack {
            List(people, id: \.self) {
                Text($0)
            }
        
            List {
                ForEach(people, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}
```



#### Loading resources from your app bundle

```swift
	func test() {
        if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            if let fileContents = try? String(contentsOf: fileURL) {
                print(fileContents)
            }
        }
    }
```



#### Working with strings

```swift
let word = "swiftlyly"
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)

        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allGood = misspelledRange.location == NSNotFound
```



### Day 30 Project 5, part 2

#### Adding to a list of words

```
struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationView {
                VStack {
                    TextField("Enter your word", text: $newWord, onCommit:addNewWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none)

                    List(usedWords, id: \.self) {
                        Image(systemName: "\($0.count).circle")
                        Text($0)
                    }
                }
                .navigationBarTitle(rootWord)
            }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

				guard answer.count > 0 else {
            return
        }
             
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
}
```

#### Running code when our app launches

&

#### Validating words with UITextChecker

```swift
struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
                VStack {
                    TextField("Enter your word", text: $newWord, onCommit:addNewWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none)

                    List(usedWords, id: \.self) {
                        Image(systemName: "\($0.count).circle")
                        Text($0)
                    }
                }
                .navigationBarTitle(rootWord)
                .onAppear(perform: {
                    startGame()
                })
                .alert(isPresented: $showingError) {
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else {
            return
        }
        
        // extra validation to come
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // If we are here everything has worked, so we can exit
                return
            }
        }
        
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
}

```



### Day 32 Project 6, part 1

#### Animation: Introduction

#### Creating implicit animations

```swift
struct ContentView: View {
    @State private var animationAmount: CGFloat = 1

    var body: some View {
        Button("Tap Me") {
            self.animationAmount += 1
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        .animation(.easeIn)
        .blur(radius: (animationAmount - 1) * 3)
    }
}
```

#### Customizing animations in SwiftUI

```swift
Button("Tap Me") {
    // self.animationAmount += 1
}
.padding(40)
.background(Color.red)
.foregroundColor(.white)
.clipShape(Circle())
.overlay(
    Circle()
        .stroke(Color.red)
        .scaleEffect(animationAmount)
        .opacity(Double(2 - animationAmount))
        .animation(
            Animation.easeOut(duration: 1)
                .repeatForever(autoreverses: false)
        )
)
.onAppear {
    self.animationAmount = 2
}

```

#### Animating bindings

```swift
@State private var animationAmount: CGFloat = 1
    
    var body: some View {
        print(animationAmount)

        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(
                Animation.easeInOut(duration: 1)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            
            Spacer()
            
            Button("Tap Me") {
                self.animationAmount += 1
            }
            .padding(40)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)
        }
    }
```

#### Creating explicit animations

```swift
struct ContentView: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        return VStack {
            Button("Tap Me") {
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                    self.animationAmount += 360
                }
            }
            .padding(40)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(.degrees(animationAmount),
                              axis: (x: 0.5, y: 1, z: 0))
            
        }
    }
}
```



### Day 33 Project 6, part 2

#### Controlling the animation stack

```swift
// example animating gesture 2
        HStack(spacing: 0) {
            ForEach(0..<letters.count) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
    // example animating gesture 1
    LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
        .frame(width: 300, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation}
                .onEnded { _ in
                    withAnimation(.spring()) {
                        dragAmount = .zero
                    }
                }
        )
        .animation(.spring(), value: dragAmount)
```



```swift

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}


struct ContentView: View {
    @State private var enabled = false
    @State private var enabled1 = false
    
    @State private var dragAmount = CGSize.zero
    let letters = Array("Hello SwiftUI")
    
    @State private var isShowingRed = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}
```





















