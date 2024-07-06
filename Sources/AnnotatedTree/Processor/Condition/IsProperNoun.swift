//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class IsProperNoun : IsLeafNode{
    
    /// Checks if the node is a leaf node and its parent has the tag NNP or NNPS.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the node is a leaf node and its parent has the tag NNP or NNPS, false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            let parentData = parseNode.getParent()?.getData()?.getName()
            return parentData == "NNP" || parentData == "NNPS"
        }
        return false
    }
}
