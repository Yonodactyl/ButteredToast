# ButteredToast

ButteredToast is a simple, lightweight and buttery smooth swift package to show toasts / popup notifications inside your iOS application in SwiftUI.

## Table of contents
- [Installation](#installation)
    + [Swift Package Manager](#swift-package-manager)
    + [Manual](#manual)
- [Options](#options)
- [Changelog](#changelog)

## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/yonodactyl/ButteredToast.git", .branch:("main"))
]
```

### Manual
Simply drag the ButteredToast.swift file into your project.

## Usage

Add a binding bool to control popup presentation state.
Add .presentToast modifier to the outermost View in your stack.

```swift
struct ContentView: View {
    @State var showToast = false
    var body: some View {
        VStack {
            // your screen main stack
            Button(action: {
                self.showToast.toggle()
            }) {
                Text("Show Toast")
                    .foregroundColor(.black)
            }
        }
        .presentToast(isPresented: self.$showToast, type: .card(), position: .bottom) {
           /// add some View in here or self creating function
            self.createTopToastView()
        }
    }
    
    func createToastView() -> some View {
        VStack {
            HStack {
                Text("This is a test toast notification")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(red: 0.85, green: 0.65, blue: 0.56))
    }
}
```
