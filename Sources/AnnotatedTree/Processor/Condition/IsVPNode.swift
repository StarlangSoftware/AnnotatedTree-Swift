//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class IsVPNode : NodeDrawableCondition{
    
    public func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        return parseNode.numberOfChildren() > 0 && parseNode.getData()!.isVP()
    }
}
