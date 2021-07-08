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

