//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsNodeWithSymbol : NodeDrawableCondition{
    private var symbol : String
    
    public init(symbol: String){
        self.symbol = symbol
    }
    
    public func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if parseNode.numberOfChildren() > 0{
            return parseNode.getData()?.description() == symbol
        } else {
            return false
        }
    }
    
}
