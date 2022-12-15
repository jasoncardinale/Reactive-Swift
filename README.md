# Reactive-Swift
This is essentially going to be written as a tutorial but it is mainly just a series of exercises I am writing to
better understand how to use reactive programming in an Xcode project accompanied by some notes.

## Observables
The main idea behind an observable is to essentially keep track of a sequence of events. These events (or objects or types)
can also receive updates asynchonously. 

## Creating Observables
In order to subscribe to an observable and receive updates, we need to first create our observable. We can do so using several different methods. We will first look at `Observable.just` as it is relatively simple to understand due to it's simplistic use case.

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
}
```

We can create an instance of `Car` has such

```swift
let car = Car(model: "Camry", make: "Toyota", speedInMilesHour: 135, milesPerGallon: 30, bodyType: .sedan)
```

Now we can use our instance of `Car` to do whatever we like with. However, if we were working in the context of observables (say we needed to return an `Observable<Car>` from a function, we need to turn this into an observable. `.just` is essentially the simplest yet most limited way to do that.

Say we didn't actually need any of the benefits of observables and async updates but instead just wanted to conform to our functions return type. That is where `.just` comes in. Essentially we just wrap our struct instance like so ...

```swift
let observableCar = Observable.just(car)
```

and now we have `observableCar` of type `Observable<Car>`. As I mentioned before however, this is very limited and does not provide us with any rx-specfic benefits. This is because our struct instance is not capable of changing in anyway that would propagate updates down the observable chain. So `.just` just gives us what is essentially a single use one-and-done observable. 

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


