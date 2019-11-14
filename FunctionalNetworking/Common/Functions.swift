//
//  Functions.swift
//  FunctionalNetworking
//
//  Created by Maxim Kovalko on 11/14/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import Foundation

public func performIf(_ condition: Bool, callback: () -> Void) {
    guard condition else { return }
    callback()
}

infix operator =>
public func =>(_ condition: Bool, callback: () -> Void) {
    performIf(condition, callback: callback)
}

public func map<A, B>(_ a: A, f: @escaping (A) -> B) -> B {
    return f(a)
}

func flatMap<A, B>(_ a: A?, f: @escaping (A) -> B?) -> B? {
    return a.flatMap(f)
}

precedencegroup CompositionPrecedence {
    associativity: left
}

infix operator |>: CompositionPrecedence
public func |> <A, B>(_ a: A, f: @escaping (A) -> B) -> B {
    return map(a, f: f)
}

public func |> <A, B>(_ a: A?, f: @escaping (A) -> B?) -> B? {
    return a.flatMap(f)
}

public func map<A, B, C>(f: @escaping (A) -> B,
                  g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

public func |><A, B, C>(f: @escaping (A) -> B,
                 g: @escaping (B) -> C) -> (A) -> C {
    return map(f: f, g: g)
}

extension Optional {
    public func `do`<T>(_ wrapped: (Wrapped) -> T) {
        _ = self.map(wrapped)
    }
}

public func + <Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach { result[$0] = $1 }
    return result
}

public func cast<Value>(_ value: Any) -> Value? {
    return value as? Value
}

public func identity<Value>(_ value: Value) -> Value {
    return value
}

public func lift<A, B>(_ tuple: (A?, B?)) -> (A, B)? {
    return tuple.0.flatMap { a in
        tuple.1.flatMap { b in
            (a, b)
        }
    }
}

public func debug(_ closure: @autoclosure () -> Void) {
    #if DEBUG
    closure()
    #endif
}

public func onMainThread(_ closure: @escaping @autoclosure () -> Void) {
    DispatchQueue.main.async(execute: closure)
}
