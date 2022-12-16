import RxSwift
import SwiftUI

@main
struct Reactive_SwiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        doSomething()
    }
    
    func doSomething() {
        let car = Car(model: "Camry", make: "Toyota", speedInMilesHour: 135, milesPerGallon: 30, bodyType: .sedan)
        let cars = [Car(model: "Supra"), Car(model: "WRX"), Car(model: "Camaro"), Car(model: "Mustang")]
        let observableCar = Observable.create { observer in
            observer.on(.next(car))
            observer.on(.completed)
            return Disposables.create()
        }
        let observableSequence: Observable<Car> = Observable.from(cars)
        let disposeBag = DisposeBag()
        
        observableSequence.subscribe(
            onNext: { car in
                print(car.model)
            }
        )
        .disposed(by: disposeBag)
    }
}
