//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation
import WordNet

public class IsPredicateVerbNode : IsVerbNode{
    
    /// Stores the wordnet for checking the pos tag of the synset.
    /// - Parameter wordNet: Wordnet used for checking the pos tag of the synset.
    public override init(wordNet: WordNet){
        super.init(wordNet: wordNet)
    }
    
    /// Checks if the node is a leaf node and at least one of the semantic ids of the parse node belong to a verb synset,
    /// and the semantic role of the node is PREDICATE.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the node is a leaf node and at least one of the semantic ids of the parse node belong to a verb
    ///          synset and the semantic role of the node is PREDICATE, false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        let layerInfo = parseNode.getLayerInfo()
        return super.satisfies(parseNode: parseNode) && layerInfo.getArgument() != nil && layerInfo.getArgument()?.getArgumentType() == "PREDICATE"
    }
}
