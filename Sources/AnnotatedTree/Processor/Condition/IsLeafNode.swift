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
    
    /// Checks if the parse node is a leaf node, i.e., it has no child.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the parse node is a leaf node, false otherwise.
    public func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        return parseNode.numberOfChildren() == 0
    }
    
}
