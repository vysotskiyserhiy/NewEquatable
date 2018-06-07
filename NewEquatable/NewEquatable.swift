//
//  NewEquatable.swift
//  NewEquatable
//
//  Created by Serhiy Vysotskiy on 6/7/18.
//  Copyright © 2018 Serhiy Vysotskiy. All rights reserved.
//

import Foundation

public protocol NewEquatable: Equatable {
    func comparers() -> [(Self, Self) -> Bool]
}

// MARK: - Equatable
extension NewEquatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return compareDefaultProperties(lhs, rhs) && checkComparers(lhs, rhs, lhs.comparers())
    }
    
    private static func compareDefaultProperties(_ lhs: Self, _ rhs: Self) -> Bool {
        let comparers = [
            comparer(for: String.self),
            comparer(for: Int.self),
            comparer(for: Double.self),
            comparer(for: Float.self),
            comparer(for: Bool.self),
            comparer(for: Date.self),
            comparer(for: UInt.self),
        ]
        
        return checkComparers(lhs, rhs, comparers)
    }
    
    private static func checkComparers(_ lhs: Self, _ rhs: Self, _ comparers: [(Self, Self) -> Bool]) -> Bool {
        return comparers.reduce(true, { $0 && $1(lhs, rhs) })
    }
}

extension NewEquatable {
    // you can override it to set additional types to check
    func comparers() -> [(Self, Self) -> Bool] {
        return []
    }
    
    // returns equality check for given types
    func comparer<E: Equatable>(for type: E.Type) -> (Self, Self) -> Bool {
        return {
            let (d1, d2, keys) = Self.mirror($0, $1)
            
            var returnBool = true
            
            for key in keys {
                if let compare = Self.compareValuesOfType(type.self, value1: d1[key]!, value2: d2[key]!) {
                    returnBool = returnBool && compare
                }
            }
            
            return returnBool
        }
    }
    
    static func comparer<E: Equatable>(for type: E.Type) -> (Self, Self) -> Bool {
        return {
            let (d1, d2, keys) = Self.mirror($0, $1)
            
            var returnBool = true
            
            for key in keys {
                if let compare = Self.compareValuesOfType(type.self, value1: d1[key]!, value2: d2[key]!) {
                    returnBool = returnBool && compare
                }
            }
            
            return returnBool
        }
    }
}

// MARK: - Delegate functions
extension NewEquatable {
    private static func compareValuesOfType<T: Equatable>(_ type: T.Type, value1: Any, value2: Any) -> Bool? {
        let possibleValue1 = value1 as? T
        let possibleValue2 = value2 as? T
        
        let possibleArrayValue1 = value1 as? [T]
        let possibleArrayValue2 = value2 as? [T]
        
        if let ar1 = possibleArrayValue1, let ar2 = possibleArrayValue2 {
            return ar1 == ar2
        } else if possibleArrayValue1 == nil && possibleArrayValue2 == nil {
            return possibleValue1 == possibleValue2
        } else {
            return false
        }
    }
    
    private static func mirror(_ lhs: Any, _ rhs: Any) -> (lhsInfo: [String: Any], rhsInfo: [String: Any], keys: Set<String>) {
        let info1 = Mirror(reflecting: lhs).children.reduce([String: Any](), { $0.setting($1.value, for: $1.label) })
        let info2 = Mirror(reflecting: rhs).children.reduce([String: Any](), { $0.setting($1.value, for: $1.label) })
        let keys = info1.keySet.intersection(info2.keySet)
        return (info1, info2, keys)
    }
}

extension Dictionary {
    func setting(_ value: Value?, for key: Key?) -> Dictionary {
        var dict = self
        key.map { dict[$0] = value }
        return dict
    }
    
    var keySet: Set<Key> {
        return Set(keys)
    }
}
