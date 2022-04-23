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

    public func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        return parseNode.numberOfChildren() == 1 && parseNode.getChild(i: 0).numberOfChildren() >= 1 && !parseNode.getChild(i: 0).isLeaf() && parseNode.getData() != parseNode.getChild(i: 0).getData()
    }
    
}
