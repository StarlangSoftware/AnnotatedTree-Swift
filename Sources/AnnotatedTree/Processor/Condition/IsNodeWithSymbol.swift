//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsNodeWithSymbol : NodeDrawableCondition{
    private var symbol : String
    
    /// Stores the symbol to check.
    /// - Parameter symbol: Symbol to check
    public init(symbol: String){
        self.symbol = symbol
    }
    
    /// Checks if the tag of the parse node is equal to the given symbol.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the tag of the parse node is equal to the given symbol, false otherwise.
    public func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if parseNode.numberOfChildren() > 0{
            return parseNode.getData()?.description() == symbol
        } else {
            return false
        }
    }
    
}
