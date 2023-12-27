//
//  File.swift
//  
//
//  Created by Collin Palmer on 12/27/23.
//

import Foundation

// TODO: Match structure used by partial regex
// (Regex derivatives are primitive -- don't fit this pattern as well)
public indirect enum FlatRegexAST: CustomStringConvertible {
    // A sequence of matchable regex characters
    case sequence(String)
    case concat(FlatRegexAST, FlatRegexAST)
    case union(FlatRegexAST, FlatRegexAST)
    case quantifier(FlatRegexAST, RegexQuantifier)
    
    public var description: String {
        switch self {
        case .sequence(let string):
            return string
        case .concat(let e1, let e2):
            return "\(e1.description)\(e2.description)"
        case .union(let e1, let e2):
            return "\(e1.description)|\(e2.description)"
        case .quantifier(let e, let quantifier):
            return "(\(e.description))\(quantifier.description)"
        }
    }
}

/// Returns concat string and remaining AST node
// Try & make safe for any sequence
// Meant _only_ for running on the specified root
func flattenSequence(_ root: RegexExpression) -> (String, RegexExpression?) {
    var result = ""
    switch root {
    case .concat(let e1, let e2):
        if case .symbol(let char) = e1 {
            if case .symbol(let char2) = e2 {
                return ("\(e1)\(e2)", nil)
            }
            let subResult = flattenSequence(e2)
            result = String(char) + subResult.0
            return (result, subResult.1)
        }
        
        return (result, nil)
    default:
        return (result, nil)
    }
}

func flatten(_ root: RegexExpression) -> FlatRegexAST {
    switch root {
    // TODO: Is this missing a case
    // e2 could be a char sequence
    case .concat(let e1, let e2):
        if case .symbol(let character) = e1 {
            // TODO: Implement flatten sequence here
            let flat = flattenSequence(root)
            if let nextNode = flat.1 {
                return .concat(.sequence(flat.0), flatten(nextNode))
            } else {
                return .sequence(flat.0)
            }
        }
        
        return .concat(flatten(e1), flatten(e2))
    case .union(let e1, let e2):
        return .union(flatten(e1), flatten(e2))
    case .quantifier(let e1, let e2):
        return .quantifier(flatten(e1), e2)
    case .symbol(let character):
        // TODO: Not sure one this
        return .sequence(String(character))
    }
}
 
/*
extension RegexExpression {
    var flattened: FlatRegexAST {
        // If a node is a character, how to flatten it?
        // That is, concat w/ char (each node flattens itself?)
    }
}
*/

extension String {
    var substrings: [String] {
        (1...self.count).map {
            String(self.prefix($0))
        }
    }
}

func partialString(_ str: String) -> FlatRegexAST {
    var strings = str.substrings
    let initial = strings.removeFirst()
    
    let ast: FlatRegexAST = strings.reduce(.sequence(initial), { (acc, curr) -> FlatRegexAST in .union(.sequence(curr), acc)
    })
    
    return ast
}


/*
func partial(_ root: FlatRegexAST) -> FlatRegexAST {
    switch root {
    case .sequence(let string):
        if string.count > 1 {
            
        } else {
            return root
        }
    case .concat(let flatRegexAST, let flatRegexAST2):
        <#code#>
    case .union(let flatRegexAST, let flatRegexAST2):
        <#code#>
    case .quantifier(let flatRegexAST, let regexQuantifier):
        <#code#>
    }
}
*/
