//
//  Observable.swift
//  Weather
//
//  Created by MM on 6/18/23.
//

import Foundation

struct Observable<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    mutating func bind(listener: Listener?) {
        self.listener = listener
    }
    mutating func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
