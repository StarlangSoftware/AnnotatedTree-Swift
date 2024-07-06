//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsNullElement : IsLeafNode{
    
    /// Checks if the parse node is a leaf node and its data is '*' and its parent's data is '-NONE-'.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the parse node is a leaf node and its data is '*' and its parent's data is '-NONE-', false
    /// otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            let data = parseNode.getLayerData(viewLayer: .ENGLISH_WORD)
            let parentData = parseNode.getParent()!.getData()!.getName()
            return data!.contains("*") || (data == "0" && parentData == "-NONE-")
        }
        return false
    }
}
