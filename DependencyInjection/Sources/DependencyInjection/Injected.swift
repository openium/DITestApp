@propertyWrapper
public struct Injected<T> {

    // MARK: Properties

    private let keyPath: WritableKeyPath<InjectedValues, T>

    public var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }

    // MARK: Init

    public init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}
