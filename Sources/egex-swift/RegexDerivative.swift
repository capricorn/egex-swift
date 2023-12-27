//
//  File.swift
//  
//
//  Created by Collin Palmer on 12/27/23.
//

import Foundation

/**
 Given an input takes its regex derivative wrt Character
 */
public typealias RegexDerivative = (String?) -> (String?, RegexExpression)

infix operator ..: NilCoalescingPrecedence
infix operator |: MultiplicationPrecedence
postfix operator *
postfix operator +
postfix operator ~
postfix operator <

public enum RegexQuantifier: CustomStringConvertible {
    case zeroOrOne
    case zeroOrMore
    case oneOrMore
    
    public var description: String {
        switch self {
        case .zeroOrOne:
            return "?"
        case .zeroOrMore:
            return "*"
        case .oneOrMore:
            return "+"
        }
    }
}

public indirect enum RegexExpression: CustomStringConvertible {
    case concat(RegexExpression, RegexExpression)
    case union(RegexExpression, RegexExpression)
    case quantifier(RegexExpression, RegexQuantifier)
    case symbol(Character)
    
    public var description: String {
        switch self {
        case .concat(let regexExpression, let regexExpression2):
            return regexExpression.description + regexExpression2.description
        case .union(let regexExpression, let regexExpression2):
            return "\(regexExpression.description)|\(regexExpression2.description)"
        case .quantifier(let regexExpression, let regexQuantifier):
            return "(\(regexExpression.description))\(regexQuantifier.description)"
        case .symbol(let character):
            return String(character)
        }
    }
}

// Represents the wildcard match '.'
private func wildcard() -> RegexDerivative {
    return { input in
        guard let input, input.isEmpty == false else {
            return (nil, .symbol("."))
        }
        
        return (String(input.dropFirst()), .symbol("."))
    }
}

public let W = wildcard()

public func D(_ symbol: Character) -> RegexDerivative {
    return { input in
        guard let input else {
            return (nil, .symbol(symbol))
        }
        
        if input.first == symbol {
            return (String(input.dropFirst()), .symbol(symbol))
        }
        
        return (nil, .symbol(symbol))
    }
}

public func .. (_ d1: @escaping RegexDerivative, _ d2: @escaping RegexDerivative) -> RegexDerivative {
    return { input in
        // Fail early to terminate potential recursion
        guard let d1Match = d1(input).0 else {
            return (nil, .concat(d1(nil).1, d2(nil).1))
        }
        
        return (d2(d1Match).0, .concat(d1(nil).1, d2(nil).1))
    }
}

public func | (_ d1: @escaping RegexDerivative, _ d2: @escaping RegexDerivative) -> RegexDerivative {
    return { input in
        return (d1(input).0 ?? d2(input).0, .union(d1(nil).1, d2(nil).1))
    }
}

public postfix func * (_ d: @escaping RegexDerivative) -> RegexDerivative {
    return { input in
        var lastGoodInput = input
        while d(lastGoodInput).0 != nil {
            lastGoodInput = d(lastGoodInput).0
        }
        
        return (lastGoodInput, .quantifier(d("*").1, .zeroOrMore))
    }
}

public postfix func + (_ d: @escaping RegexDerivative) -> RegexDerivative {
    return { input in
        var lastGoodInput = d(input).0
        while d(lastGoodInput).0 != nil {
            lastGoodInput = d(lastGoodInput).0
        }
        
        return (lastGoodInput, .quantifier(d("*").1, .oneOrMore))
    }
}

// ?
public postfix func ~ (_ d: @escaping RegexDerivative) -> RegexDerivative {
    return { input in
        return (d(input).0 ?? input, .quantifier(d("*").1, .zeroOrOne))
    }
}
