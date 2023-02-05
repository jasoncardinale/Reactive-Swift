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

    func somethingelse() {
        let car = Observable.create { observer in
            observer.onNext(VehicleType.car)
            observer.onCompleted()
            return Disposables.create()
        }
        
        let obs = Observable.from([Car()])
        let obs2 = Observable.of(Car(), Car(), Car())
        
//        car
//            .flatMap { car -> Vehicle in
////                self.vehicle(from: car)
//                Vehicle()
//            }
    }
    
    func vehicle(from car: Car) -> Observable<Vehicle> {
        return Observable.create { observer in
            observer.onNext(Vehicle(name: "\(car.make) \(car.model)", type: .car))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func something() -> Driver<Double> {
        return cars()
            .progressRange(end: 3)
            .flatMap { [self] event -> Observable<ProgressState<Plane>> in
                switch event {
                case .completed:
                    return planes()
                        .progressRange(start: 1, end: 3)
                case let .progress(progress):
                    return .just(.progress(progress))
                }
            }
            .flatMap { [self] event -> Observable<ProgressState<Vehicle>> in
                switch event {
                case .completed:
                    return vehicles()
                        .progressRange(start: 2, end: 3)
                case let .progress(progress):
                    return .just(.progress(progress))
                }
            }
            .compactMap { event -> Double? in
                switch event {
                case .completed:
                    return nil
                case let .progress(progress):
                    return progress
                }
            }
            .asDriver(onErrorJustReturn: 0)
    }
    
    func vehicles() -> Observable<ProgressState<Vehicle>> {
        let vehicles = [0, 1, 2]
            .map { delay in
                Observable.create { observer in
                    observer.onNext(ProgressState<Vehicle>.progress(1))
                    observer.onNext(ProgressState<Vehicle>.completed(Vehicle()))
                    observer.onCompleted()
                    return Disposables.create()
                }//.delay(.seconds(delay), scheduler: MainScheduler.instance)
            }
        return vehicles[0]
    }
    
    func planes() -> Observable<ProgressState<Plane>> {
        let planes = [0, 1, 2, 3]
            .map { delay in
                Observable.create { observer in
                    observer.onNext(ProgressState<Plane>.progress(1))
                    observer.onNext(ProgressState<Plane>.completed(Plane()))
                    observer.onCompleted()
                    return Disposables.create()
                }//.delay(.seconds(delay), scheduler: MainScheduler.instance)
            }
        return planes[0]
    }
        
    func cars() -> Observable<ProgressState<Car>> {
        let car = Observable.create { observer in
            observer.onNext(ProgressState<Car>.progress(1))
            observer.onNext(ProgressState<Car>.completed(Car()))
            observer.onCompleted()
            return Disposables.create()
        }
        let car2 = Observable.create { observer in
            observer.onNext(ProgressState<Car>.progress(1))
            observer.onNext(ProgressState<Car>.completed(Car(model: "altima")))
            return Disposables.create()
        }.delay(.seconds(2), scheduler: MainScheduler.asyncInstance)
        let cars = [0, 1, 2, 3, 4]
            .map { delay in
                Observable.create { observer in
                    observer.onNext(ProgressState<Car>.progress(1))
                    observer.onNext(ProgressState<Car>.completed(Car()))
                    observer.onCompleted()
                    return Disposables.create()
                }//.delay(.seconds(delay), scheduler: MainScheduler.asyncInstance)
            }
        return car
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
