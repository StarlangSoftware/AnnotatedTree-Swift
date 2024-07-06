//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class IsVPNode : NodeDrawableCondition{
    
    public init(){
    }
    
    /// Checks if the node is not a leaf node and its tag is VP.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the node is not a leaf node and its tag is VP, false otherwise.
    public func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        return parseNode.numberOfChildren() > 0 && parseNode.getData()!.isVP()
    }
}
