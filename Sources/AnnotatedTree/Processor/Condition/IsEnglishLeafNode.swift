//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsEnglishLeafNode : IsLeafNode{
    
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            return IsNullElement().satisfies(parseNode: parseNode)
        }
        return false
    }
}
