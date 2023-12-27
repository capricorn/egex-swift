//
//  File.swift
//  
//
//  Created by Collin Palmer on 12/27/23.
//

import Foundation

// TODO: Match structure used by partial regex
// (Regex derivatives are primitive -- don't fit this pattern as well)
public indirect enum FlatRegexAST {
    // A sequence of matchable regex characters
    case sequence(String)
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

/*
func flatten(_ root: RegexExpression) -> FlatRegexAST {
    switch root {
    case .concat(let e1, let e2):
        if case .symbol(let character) = e1 {
            // TODO: Implement flatten sequence here
            return flattenSequence(e1)
        }
    case .union(let e1, let e2):
        // TODO
        break
    case .quantifier(let regexExpression, let regexQuantifier):
        <#code#>
    case .symbol(let character):
        <#code#>
    }
}
 */
 
/*
extension RegexExpression {
    var flattened: FlatRegexAST {
        // If a node is a character, how to flatten it?
        // That is, concat w/ char (each node flattens itself?)
    }
}
*/
