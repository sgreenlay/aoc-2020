//
//  File.swift
//  
//
//  Created by Scott Greenlay on 12/23/20.
//

import Foundation

public struct CircularBuffer<T: Hashable> {
    var next = [T: T]()
    var prev = [T: T]()
    
    public init() {}
    public init(contentsOf values: [T]) {
        var prevValue = values.last!
        for value in values {
            next[prevValue] = value
            prev[value] = prevValue
            prevValue = value
        }
    }
    
    public func contains(_ value: T) -> Bool {
        return next[value] != nil
    }
    
    public func before(_ value: T) -> T {
        return prev[value]!
    }

    public func after(_ value: T) -> T {
        return next[value]!
    }
    
    public func toArray(startingWith: T) -> [T] {
        var output = [T]()
        
        var value = startingWith
        repeat {
            output.append(value)
            value = next[value]!
        } while value != startingWith
    
        return output
    }
    
    public mutating func remove(after prevValue: T, count: Int = 1) -> [T] {
        assert(count < next.count)
        
        var value = next[prevValue]!
        
        var output = [T]()
        for _ in 1...count {
            output.append(value)
            
            let nextValue = next[value]!
            
            prev.removeValue(forKey: value)
            next.removeValue(forKey: value)

            value = nextValue
        }

        next[prevValue] = value
        prev[value] = prevValue
        
        return output
    }
    
    public mutating func insert(after: T, contentsOf values: [T]) {
        prev[next[after]!] = values.last!
        next[values.last!] = next[after]!

        var prevValue = after
        for value in values {
            next[prevValue] = value
            prev[value] = prevValue
            prevValue = value
        }
    }
}
