//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsEnglishLeafNode : IsLeafNode{
    
    /// Checks if the parse node is a leaf node and contains a valid English word in its data.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the parse node is a leaf node and contains a valid English word in its data; false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            return IsNullElement().satisfies(parseNode: parseNode)
        }
        return false
    }
}
