//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class IsTurkishLeafNode : IsLeafNode{
    
    /// Checks if the parse node is a leaf node and contains a valid Turkish word in its data.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the parse node is a leaf node and contains a valid Turkish word in its data; false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            let data = parseNode.getLayerInfo().getLayerData(viewLayer: .TURKISH_WORD)
            let parentData = parseNode.getParent()?.getData()?.getName()
            return data != nil && !(data?.contains("*"))! && !(data == "0" && parentData == "-NONE-")
        }
        return false
    }
}
