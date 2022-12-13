import RxSwift

public struct Car {
    public enum BodyType {
        case sedan
        case coupe
        case suv
        case truck
    }
    
    public let model: String
    public let make: String
    public let topSpeed: Int
    public let milesPerGallon: Int
    public let bodyType: BodyType
}
