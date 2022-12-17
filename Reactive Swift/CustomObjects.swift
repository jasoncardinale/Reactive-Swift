import RxSwift

public enum Error: Swift.Error {
    case invalidVehicle
}

public enum VehicleType {
    case car(Car)
    case plane(Plane)
    case train(Train)
    case boat(Boat)
}

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

public struct Plane {
    public let model: String
    public let company: String
    public let speedInMilesHour: Int
    public let wingSpanInFeet: Int
}

public struct Train {
    public let model: String
    public let company: String
    public let horesepower: Int
    public let weightInTons: Int
}

public struct Boat {
    public let name: String
    public let company: String
    public let weightInTons: Int
    public let lengthInFeet: Int
}

public struct Vehicle {
    public let name: String
    public let type: VehicleType
}
