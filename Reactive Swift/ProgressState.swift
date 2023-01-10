import Foundation
import RxSwift

public enum ProgressState<T> {
    case completed(T)
    case progress(Double)
}

public protocol Result {
    associatedtype ProgressState
}

extension ProgressState: Result {
    public typealias ProgressState = T
}

extension ObservableType where Self.Element: Result {
    public func progressRange(start: Int = 0, end: Int = 1) -> Observable<ProgressState<Self.Element.ProgressState>> {
        return self
            .map { element -> ProgressState<Self.Element.ProgressState> in
                guard let progressState = element as? ProgressState<Self.Element.ProgressState> else {
                    fatalError()
                }
                
                switch progressState {
                case let .completed(result):
                    return .completed(result)
                case let .progress(progress):
                    return .progress(Double(start) / Double(end) + progress / Double(end))
                }
            }
    }
}
