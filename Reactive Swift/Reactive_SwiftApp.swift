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
//        let cars = [Car(model: "Supra"), Car(model: "WRX"), Car(model: "Camaro"), Car(model: "Mustang")]
        let observableCar = Observable.create { observer in
            observer.on(.next(car))
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
