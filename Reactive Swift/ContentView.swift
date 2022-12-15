import RxSwift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
    
    func doSomething() {
        let car = Car(model: "Camry", make: "Toyota", speedInMilesHour: 135, milesPerGallon: 30, bodyType: .sedan)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
