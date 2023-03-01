# Reactive-Swift
This is essentially going to be written as a tutorial but it is mainly just a series of exercises I am writing to
better understand how to use reactive programming in an Xcode project accompanied by some notes.

## Observables
The main idea behind an observable is to essentially keep track of a sequence of events. These events (classes, structs, enums, or basic data types)
can also receive updates asynchonously. A common use case, or at least a use for which I most commonly employ observables is when communicating with a server.
We often need to wait for an unknown period of time for a response from a server but we typically can't afford to simply pause our entire application until the
response is received. We could manage multiple threads on our own or schedule work so that the communication between the user device and the server does not interrupt 
the main thread (where all our UI work must be done), but this can get messy and hard to manage. 

Using observables essentially removes this work as subscribing to observables will automatically schedule work to be done on the thread which `.subscribe` was called.
There are other methods such as `.subscribeOn` and `.observeOn` that allow us to change the default scheduler (which will change the scheduler on which the subscription
and observer code is executed respectively). We will take a closer look at those later on however.

The main takeaway for now is that observables allow us to maintain a responsive UI despite having to wait for work to be done.

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
    
    public init(
        model: String = "Miata", 
        make: String = "Mazda", 
        speedInMilesHour: Int = 143,
        milesPerGallon: Int = 32, 
        bodyType: BodyType = .coupe
    ) {
        self.model = model
        self.make = make
        self.speedInMilesHour = speedInMilesHour
        self.milesPerGallon = milesPerGallon
        self.bodyType = bodyType
    }
}
```

### `.just`
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
gives us what is essentially a single use one-and-done observable. It emits the element which it was passed, which in this case is an instance of the `Car` 
struct, followed by a `.completed` event.

### `.from`
What if instead of just tracking a single instance of a `Car` as an observable, we wanted to track a sequence of objects as an observable. This is were
we can begin to see the distinction between synchronous and asynchronous observation (well at least identify what an observable that is synchronous throughout
it's lifetime looks like). A `Sequence` in Swift can be thought of as any iterable list of elements, the most obvious of which being an array. We can use 
`Observable.just` to convert an array of cars into an observable but that treats the entire array as one unit essentially, so any subscription to the 
resulting observable will dispose of the entire list of cars at once. How can we force the subscription to return each element of the array one at a time?

This is where `Observable.from` comes in. This operator takes in a sequence, an array of cars for example, and converts it to an observable which will
emit each car in the array one at a time.

```swift
let cars: Observable<Car> = Observable.from([Car(model: "Supra"), Car(model: "F-150"), Car(model: "Challenger"), Car(model: "Prius")])
```

### `.of`
`Observable.of` is similar to `.from` in the sense that it too creates an observable from a sequence of events. However, rather than being passed an argument
that is itself a sequence, like how we pass an array to `.from`, we instead pass the values of said sequence as arguments.

```swift
let cars: Observable<Car> = Observable.of(Car(model: "Supra"), Car(model: "F-150"), Car(model: "Challenger"), Car(model: "Prius"))
```

The observables generated by `.of` and `.from` mentioned above are identical.

### `.create`
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
We can create observables as was shown above, but how do we actually retrieve information from our observables? This is where subscriptions come in handy.
Lets assume that most if the time when we are dealing with observables it is because we have an activity that we wish to run async from our 
main thread. If this is the case, we can't just assign a variable or constant to the result of our function which returns an observable, since the process 
of assigning this variable with a value would sit on the main thread. We can use `.subscribe` to handle an observable when it emits a value so that the rest
of the application doesn't need to wait. 

Essentially, we call subscribe like a member function on an observable

```swift
cars.subscribe()
```

and once the observable emits a value the subscribe closures will execute along with whatever logic we put in it. This information on it's own isn't incredibly
userful so next I will talk about the different closures that can be triggered by an observable we have subscribed to.

### `onNext`
`onNext` will be triggered for every element in an observable chain aside from the final element in that chain. In other words, using our `cars` observable 
as an example, for each car in the sequence onNext will run. Let's take a look at this in code.

```swift
cars.subscribe(
     onNext: { car in
         print(car.model)
     }
)
.disposed(by: disposeBag)
```

We can then expect the output of said code to look like ...

```
Supra
F-150
Challenger
Prius
```

It is important to note that `subscribe` is required in order for the values emitted by the observable to actually be retrieved. An observable
cannot simply be read like a variable or called like a function. 

It is also important to note that in this is example we are using the `cars` observable we created earlier using `Observable.of`. While this
does demonstrate how `subscribe` works in the sense that we can essentially pop from the observable stack all of the `Car` objects we pushed in,
it isn't necessarily a good example of the asyncronous power subscriptions provide since all the events are emitted at once one after the other.

Like I mentioned earlier, a common use case for observables is working with servers and waiting for responses. So let's create an example where
that is the case. 

// Todo

### onError
```swift
public enum Error: Swift.Error {
    case invalidVehicle
}
```


```swift
cars.subscribe(
    onNext: { car in
        print(car.model)
    },
    onError: { error in
        print(error.localizedDescription)
    }
)
.disposed(by: disposeBag)
```

### `onCompleted`


## Transforming Observables
When it comes to using observables, one useful thing we can do is transform the type of an observable, `Observable<Vehicle> -> Observable<Car>`.
This can be achieved in a few different ways which I will explain in detail below.

One thing to note about transforming observables using either `map`, `flatMap`, or `compactMap` is that within the closure, we are able to 
access the value currently being tracked by the observable. So in other words, calling `map` on an observable of type `Vehicle` 
(`Observable<Vehicle>`), within the `map` closure we can access the `Vehicle` directly.

### `.flatMap`
`flatMap` should be used when we want to transform the type being tracked by an observable to an observable of another type.
Say we are given the following function that takes a `Car` and returns an observable `Vehicle`.

```
func vehicle(from car: Car) -> Observable<Vehicle> {
    return Observable.create { observer in
        observer.onNext(Vehicle(name: "\(car.make) \(car.model)", type: .car))
        observer.onCompleted()
        return Disposables.create()
    }
}
```

Now imagine that the `Car` being passed to this function is being tracked by some observable, how can we access the observable in order to 
use this function to carry out the transformation from `Car` to `Vehicle`? The following code uses the `flatMap` method to do exactly this.

```
let car = Observable.create { observer in
    observer.onNext(Car())
    observer.onCompleted()
    return Disposables.create()
}

return car
    .flatMap { [weak self] car -> Observable<Vehicle> in
        guard let self = self else {
            throw Error.failed
        }
        
        self.vehicle(from: car)
    }
```

This code will return an `Observable<Vehicle>`. We first generate a `Car` object and use it to create an observable. We then call the 
`ObservableType` member function `.flatMap` on the `Observable<Car>`. Within the `.flatMap` closure we take the `Car` object as our sole 
parameter and assign it the name `car`. We then specify that the return type of this closure is `Observable<Vehicle>` thus indicating our 
intention to convert the given car to a vehicle. We also specify `[weak self]` in order to avoid a retain cycle within the closure.

Aside from the `guard` statement, which is in place in order to verify that we indeed still have a reference to self, all that is left is to 
return an `Observable<Vehicle>`. Note that this part is very important and is essentially what sets `flatMap` apart from `map`: we need to 
return an `Observable<Vehicle>` and not just a `Vehicle` object. `flatMap` will not handle the conversion from non-observable to observable so
if you attempt to return a `Vehicle` you will be met with this error.

```
Instance method 'flatMap' requires that 'Vehicle' conform to 'ObservableConvertibleType'
```

One way to think of how `flatMap` is working is it essentially taking an observable that emits one or more elements which themselves can in
some way be turned into observables. So in our simple example we had the observable which emitted only one `Car` object. So there really
wasn't any interesting merging going on because we essentially just took our `car` observable, flattened out all of the results into 

### `.map`
Similar to `flatMap`, `map` will enable us to transform an observable we are given to an observable of another type. The one major difference
here is that what we return from the `map` closure is the observed element rather than the observable itself.

Therefore, with `map` we are able to something like this now ...

```
let result = car
    .map { car -> Vehicle in
        Vehicle(name: "\(car.make) \(car.model)", type: .car)
    }
```

`result` here will still be of type `Observable<Vehicle>`. This is great for when we want to continue to track a sequence, wish to transform
the elements being tracked, but don't need any more async information from another observable sequence.

### `.compactMap`


## Disposing of Observables
### `.dispose`

###`.disposed(by: Disposable)`

## Combining Observables
### `.zip`


### `.combineLatest`


### `.merge`


### `.concat`


## Find a descriptive label for this later
### share


### replay


### retry


## Filtering Observables
### take


### filter



