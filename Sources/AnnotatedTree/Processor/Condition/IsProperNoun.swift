//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class IsProperNoun : IsLeafNode{
    
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            let parentData = parseNode.getParent()?.getData()?.getName()
            return parentData == "NNP" || parentData == "NNPS"
        }
        return false
    }
}
