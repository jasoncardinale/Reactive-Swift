# Reactive-Swift
This is essentially going to be written as a tutorial but it is mainly just a series of exercises I am writing to
better understand how to use reactive programming in an Xcode project accompanied by some notes.

## Observables
The main idea behind an observable is to essentially keep track of a sequence of events. These events (or objects or types)
can also receive updates asynchonously. 

## Creating Observables
In order to subscribe to an observable and receive updates, we need to first create our observable. We can do so using several different methods. 
We will first look at `Observable.just` as it is relatively simple to understand due to it's simplistic use case.

Say we have a non-observable struct called `Car`. 

```swift
public struct Car {
    public enum BodyType {
        case sedan
        case coupe
        case suv
        case truck
    }
    
    public let model: String
    public let make: String
    public let speedInMilesHour: Int
    public let milesPerGallon: Int
    public let bodyType: BodyType
    
    public init(model: String = "Miata", make: String = "Mazda", speedInMilesHour: Int = 143, milesPerGallon: Int = 32, bodyType: BodyType = .coupe) {
        self.model = model
        self.make = make
        self.speedInMilesHour = speedInMilesHour
        self.milesPerGallon = milesPerGallon
        self.bodyType = bodyType
    }
}
```

### just
We can create an instance of `Car` has such

```swift
let camry = Car(model: "Camry", make: "Toyota", speedInMilesHour: 135, milesPerGallon: 30, bodyType: .sedan)
```

Now we can use our instance of `Car` to do whatever we like with. However, if we were working in the context of observables (say we needed to return 
an `Observable<Car>` from a function, we need to turn this into an observable. `.just` is essentially the simplest yet most limited way to do that.

Say we didn't actually need any of the benefits of observables and async updates but instead just wanted to conform to our functions return type. 
That is where `.just` comes in. Essentially we just wrap our struct instance like so ...

```swift
let car: Observable<Car> = Observable.just(camry)
```

and now we have `observableCar` of type `Observable<Car>`. As I mentioned before however, this is very limited and does not provide us with any rx-specfic 
benefits. This is because our struct instance is not capable of changing in anyway that would propagate updates down the observable chain. So `.just` just 
gives us what is essentially a single use one-and-done observable. 

### from
What if instead of just tracking a single instance of a `Car` as an observable, we wanted to track a sequence of objects as an observable. This is were
we can begin to see the distinction between synchronous and asynchronous observation (well at least identify what an observable that is synchronous throughout
it's lifetime looks like). A `Sequence` in Swift can be thought of as any iterable list of elements, the most obvious of which being an array. We can use 
`Observable.just` to convert an array of cars into an observable but that treats the entire array as one unit essentially, so any subscription to the 
resulting observable will dispose of the entire list of cars at once. How can we force the subscription to return each element of the array one at a time?

This is where `Observable.from` comes in. This operator takes in a sequence, an array of cars for example, and converts it to an observable which will
emit each car in the array one at a time.

```swift
let cars: Observable<Car> = Observable.from([Car(model: "Supra"), Car(model: "WRX"), Car(model: "Camaro"), Car(model: "Mustang")])
```

### create
So `Observable.just` and `Observable.from` help us convert our regular old non-observable elements and sequences into observable elements and sequences. 
However, while this is helpful when we want to conform to some observable standard when handling our data (say returning an observable from a function),
how do we create observables that are asynchronous (since this is one of the most attractive use cases for observables in the first place)?

`Observable.create` comes in handy in this situation. But before we can get into how to use the create operator, we need to think of a situation where
we would benefit from an asynchronous observable. A common example of this is sending a request to a server and waiting for the response. We need 
an action like this to be performed asynchronously on a thread other than the main thread so that our application doesn't hang while waiting for a response
from the server. By using an observable in this scenario, we can create the observable and send the request, once that is taken care of the main thread 
executes as normal while the server prepares a response. When the response is received the observable will emit the result. So let's take a closer look at
how something like that would work.

## Handling Observables
### onNext


### onError


### onCompleted


## Transforming Observables
### map


### flatMap


### compactMap


## Disposing of Observables


## Combining Observables
### zip


### combineLatest


### merge


### concat


## Find a descriptive label for this later

### share


### replay


### retry


## Filtering Observables

### take


### filter

### take



