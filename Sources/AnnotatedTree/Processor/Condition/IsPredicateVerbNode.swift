//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation
import WordNet

public class IsPredicateVerbNode : IsVerbNode{
    
    public override init(wordNet: WordNet){
        super.init(wordNet: wordNet)
    }
    
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        let layerInfo = parseNode.getLayerInfo()
        return super.satisfies(parseNode: parseNode) && layerInfo.getArgument() != nil && layerInfo.getArgument()?.getArgumentType() == "PREDICATE"
    }
}
