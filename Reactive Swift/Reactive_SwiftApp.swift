import RxCocoa
import RxSwift
import SwiftUI

@main
struct Reactive_SwiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
//    let progress: Observable<Double>
    
    init() {
//        doSomething()
        let disposeBag = DisposeBag()

//        self.progress = cars()
//            .stride(to: 2)
//            .flatMap { [self] event -> Observable<API.Event<Plane>> in
//                switch event {
//                case .finished:
//                    return planes()
//                        .stride(from: 1, to: 2)
//                case let .progress(progress):
//                    return .just(.progress(progress))
//                }
//            }
//            .compactMap { event -> Double? in
//                switch event {
//                case .finished:
//                    return nil
//                case let .progress(progress):
//                    return progress
//                }
//            }
//            .asDriver(onErrorJustReturn: 0)
//            .asObservable()
        
//        progress
//            .subscribe(
//                onNext: { progress in
//                    print("** \(progress)")
//                }
//            )
//            .disposed(by: disposeBag)
    }
    
    
    func something() -> Driver<Double> {
        return cars()
            .stride(to: 2)
            .flatMap { [self] event -> Observable<Event<Plane>> in
                switch event {
                case .finished:
                    return planes()
                        .stride(from: 1, to: 2)
                case let .progress(progress):
                    return .just(.progress(progress))
                }
            }
            .compactMap { event -> Double? in
                switch event {
                case .finished:
                    return nil
                case let .progress(progress):
                    return progress
                }
            }
            .asDriver(onErrorJustReturn: 0)
    }
    
    func planes() -> Observable<Event<Plane>> {
        let planes = [0, 1, 2, 4]
            .map { delay in
                Observable.create { observer in
                    observer.onNext(Event<Car>.progress(1))
                    observer.onNext(Event<Car>.completed(Car()))
                    observer.onCompleted()
                    return Disposables.create()
                }//.delay(.seconds(delay), scheduler: MainScheduler.instance)
            }
        
        let concatPlanes = Observable<Event<Plane>>.apiConcat(planes)
        return Observable<API.Event<[Plane]>>.apiCollect(concatPlanes)
            .map { event -> API.Event<Plane> in
                return event.mapFinished { plane -> Plane in
                    return Plane(model: "777")
                }
            }
        
    }
        
    func cars() -> Observable<API.Event<Car>> {
//        let car = Observable.create { observer in
//            observer.onNext(API.Event<Car>.progress(1))
//            observer.onNext(API.Event<Car>.finished(Car()))
//            observer.onCompleted()
//            return Disposables.create()
//        }
//
//        let car2 = Observable.create { observer in
//            observer.onNext(API.Event<Car>.progress(1))
//            observer.onNext(API.Event<Car>.finished(Car(model: "altima")))
//            return Disposables.create()
//        }.delay(.seconds(2), scheduler: MainScheduler.asyncInstance)
//
        let cars = [0, 1, 2, 4, 8]
            .map { delay in
                Observable.create { observer in
//                    observer.onNext(API.Event<Car>.progress(1))
//                    observer.onNext(API.Event<Car>.finished(Car()))
                    observer.onCompleted()
                    return Disposables.create()
                }//.delay(.milliseconds(delay), scheduler: MainScheduler.asyncInstance)
            }
        
//        let concatCar = Observable<API.Event<Car>>.apiConcat(cars)
//        let mergeCar = Observable<API.Event<Car>>.apiMerge(cars)
//        let zipCar = Observable<API.Event<Car>>.apiZip(cars)
        
//        return concatCar
//            .map { event in
//                switch event {
//                case let .finished(car):
//                    return API.Event<Car>.finished(car)
//                case let .progress(progress):
//                    let scale = (Double(3) / Double(4))
//                    let adjustedProgress = ((Double(1) - scale) * progress) + scale
//                    return .progress(adjustedProgress)
//                }
//            }
        
        
//        let collectCar = Observable<API.Event<[Car]>>.apiCollect(concatCar)
//        zipCar
//            .map { event -> API.Event<Car> in
//                return event.mapFinished { cars -> Car in
//                    return Car(model: "Camry")
//                }
//            }
//        concatCar
//            .compactMap { event -> Double? in
//                switch event {
//                case .finished:
//                    return nil
//                case let .progress(progress):
//                    return progress
//                }
//            }
//        car.concat(car2)
//            .subscribe(
//                onNext: { progress in
//                   print("** \(progress)")
//                },
//                onError: { error in
//                    print("** \(error.localizedDescription)")
//                },
//                onCompleted: {
//                    print("** completed")
//                }
//            )
//            .disposed(by: disposeBag)

//        let observableConcat =
        return collectCar
            .map { event -> API.Event<Car> in
                return event.mapFinished { cars -> Car in
                    return Car(model: "Camry")
                }
            }
    }
    
    func doSomething() {
        let car = Car(model: "Camry", make: "Toyota", speedInMilesHour: 135, milesPerGallon: 30, bodyType: .sedan)
//        let cars = [Car(model: "Supra"), Car(model: "WRX"), Car(model: "Camaro"), Car(model: "Mustang")]
        let observableCar = Observable.create { observer in
            observer.onNext(car)
            observer.on(.completed)
            return Disposables.create()
        }
        let cars: Observable<Car> = Observable.from([Car(model: "Supra"), Car(model: "747"), Car(model: "Camaro"), Car(model: "Mustang")])
        let disposeBag = DisposeBag()
        
        cars.subscribe(
            onNext: { car in
                print(car.model)
            }
        )
        .disposed(by: disposeBag)
        
        let error = Error.invalidVehicle
        print(error.localizedDescription)
        
        let carsWithError = cars.map { car in
            guard car.model != "747" else {
                throw Error.invalidVehicle
            }
        }
        
        carsWithError.subscribe(
            onError: { error in
                print(error.localizedDescription)
            }
        )
        .disposed(by: disposeBag)
    }
}
