import RxCocoa
import RxSwift
import SwiftUI

struct ContentView: View {
    @State var progress = 0.0
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            Button(
                action: {
                    
                },
                label: {
                    Text("Tap")
                }
            )
            
            ProgressView(value: progress, total: 1)
                .onAppear {
                    let disposeBag = DisposeBag()
                    something()
                        .drive(onNext: { progress in
                            print("** \(progress)")
                            self.progress = progress
                        })
                        .disposed(by: disposeBag)
                }
        }
        .padding()
    }
    
    func something() -> Driver<Double> {
        return cars()
            .stride(to: 3)
            .flatMap { [self] event -> Observable<API.Event<Plane>> in
                switch event {
                case .finished:
                    return planes()
                        .stride(from: 1, to: 3)
                case let .progress(progress):
                    return .just(.progress(progress))
                }
            }
            .flatMap { [self] event -> Observable<API.Event<Vehicle>> in
                switch event {
                case .finished:
                    return vehicles()
                        .stride(from: 2, to: 3)
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
    
    func vehicles() -> Observable<API.Event<Vehicle>> {
        let vehicles = [0, 1, 2]
            .map { delay in
                Observable.create { observer in
                    observer.onNext(API.Event<Vehicle>.progress(1))
                    observer.onNext(API.Event<Vehicle>.finished(Vehicle()))
                    observer.onCompleted()
                    return Disposables.create()
                }//.delay(.seconds(delay), scheduler: MainScheduler.instance)
            }
        let concatVehicles = Observable<API.Event<Vehicle>>.apiConcat(vehicles)
        return Observable<API.Event<[Vehicle]>>.apiCollect(concatVehicles)
            .map { event -> API.Event<Vehicle> in
                return event.mapFinished { plane -> Vehicle in
                    return Vehicle(name: "pilot")
                }
            }
    }
    
    func planes() -> Observable<API.Event<Plane>> {
        let planes = [0, 1, 2, 3]
            .map { delay in
                Observable.create { observer in
                    observer.onNext(API.Event<Car>.progress(1))
                    observer.onNext(API.Event<Car>.finished(Car()))
                    observer.onCompleted()
                    return Disposables.create()
                }//.delay(.seconds(delay), scheduler: MainScheduler.instance)
            }
        
        let concatPlanes = Observable<API.Event<Plane>>.apiConcat(planes)
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
        let cars = [0, 1, 2, 3, 4]
            .map { delay in
                Observable.create { observer in
                    observer.onNext(API.Event<Car>.progress(1))
                    observer.onNext(API.Event<Car>.finished(Car()))
                    observer.onCompleted()
                    return Disposables.create()
                }//.delay(.seconds(delay), scheduler: MainScheduler.asyncInstance)
            }
        
        let concatCar = Observable<API.Event<Car>>.apiConcat(cars)
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
        
        
        let collectCar = Observable<API.Event<[Car]>>.apiCollect(concatCar)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
