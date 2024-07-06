//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation
import Dictionary

public class IsPunctuationNode : IsLeafNode{
    
    /// Checks if the node is a leaf node and contains punctuation as the data.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the node is a leaf node and contains punctuation as the data, false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            let data = parseNode.getLayerData(viewLayer: .ENGLISH_WORD)
            return Word.isPunctuationSymbol(surfaceForm: data!) && data != "$"
        }
        return false
    }
}
