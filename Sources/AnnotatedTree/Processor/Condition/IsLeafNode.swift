//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsLeafNode : NodeDrawableCondition{
    
    public init(){
    }

    public func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        return parseNode.numberOfChildren() == 0
    }
    
}
