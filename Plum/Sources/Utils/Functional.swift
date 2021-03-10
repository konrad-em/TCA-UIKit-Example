public func identity<T>(_ value: T) -> T {
    return value
}

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |> : ForwardApplication

public func |> <T, U>(x: T, f: (T) -> U) -> U {
    f(x)
}

infix operator ?|> : ForwardApplication

public func ?|> <T, U>(x: T?, f: (T) -> U) -> U? {
    x.map(f)
}

public func ?|> <T, U>(x: T?, f: (T) -> U?) -> U? {
    x.flatMap(f)
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    { g(f($0)) }
}

public func >>> <B, C>(f: @escaping () -> B, g: @escaping (B) -> C) -> () -> C {
    { g(f()) }
}

public func curry<A, B, C>(
    _ function: @escaping (A, B) -> C)
-> (A)
-> (B)
-> C {
    { (a: A) -> (B) -> C in
        { (b: B) -> C in
            function(a, b)
        }
    }
}

public func equal<A: Equatable>(to a: A) -> (A) -> Bool {
    curry(==)(a)
}
