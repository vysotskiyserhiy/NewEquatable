# NewEquatable

## Example

```swift
// To make struct Equatable by all fields just conform to NewEquatable

struct SomeEasyStruct: NewEquatable {
    let id: String
    let name: String
    let isActive: Bool
    let users: [String]
}


// for class you need to make it final

final class SomeClass: NewEquatable {
    let id: String = "ID"
    let name: String = "SomeClassObject"
    var isActive: Bool = true
}
```

## Compare against custom types

```swift
struct A: NewEquatable {
    // you can add comparers for any custom Equatable type like that
    // if you want objects to be comparable with this custom type
    func comparers() -> [(A, A) -> Bool] {
        return [comparer(for: B.self)]
    }
    
    
    let id: String
    let date: Date
    
    // custom property
    let b: B
    
    struct B: NewEquatable {
        let id: String
        let count: Int
    }
}
```
