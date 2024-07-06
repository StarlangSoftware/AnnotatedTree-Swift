//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsDoubleNodeWithDifferentTags : NodeDrawableCondition{
    
    public init(){
    }
    
    /// Checks if the parse node is a double node, i.e., it has one child and his child has one or more children; and its
    /// tag is not equal to its child tag.
    /// - Parameter parseNode: Parse node to check
    /// - Returns: True if the tag of the parse node is not equal to the tag of its child node, false otherwise.
    public func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        return parseNode.numberOfChildren() == 1 && parseNode.getChild(i: 0).numberOfChildren() >= 1 && !parseNode.getChild(i: 0).isLeaf() && parseNode.getData() != parseNode.getChild(i: 0).getData()
    }
    
}
