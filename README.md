# Reactive-Swift
This is essentially going to be written as a tutorial but it is mainly just a series of exercises I am writing to
better understand how to use reactive programming in a an Xcode project accompanied by some notes.

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



