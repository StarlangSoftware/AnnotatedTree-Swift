//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation
import WordNet

public class IsVerbNode : IsLeafNode{
    
    private var wordNet : WordNet
    
    /// Stores the wordnet for checking the pos tag of the synset.
    /// - Parameter wordNet: Wordnet used for checking the pos tag of the synset.
    public init(wordNet: WordNet){
        self.wordNet = wordNet
    }
    
    /// Checks if the node is a leaf node and at least one of the semantic ids of the parse node belong to a verb synset.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the node is a leaf node and at least one of the semantic ids of the parse node belong to a verb
    /// synset, false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        let layerInfo = parseNode.getLayerInfo()
        if super.satisfies(parseNode: parseNode) && layerInfo.getLayerData(viewLayer: .SEMANTICS) != nil{
            for i in 0..<layerInfo.getNumberOfMeanings(){
                let synSetId = layerInfo.getSemanticAt(index: i)
                if wordNet.getSynSetWithId(synSetId: synSetId) != nil && wordNet.getSynSetWithId(synSetId: synSetId)?.getPos() == .VERB{
                    return true
                } else {
                    if wordNet.getSynSetWithId(synSetId: synSetId) == nil{
                        return false
                    }
                }
            }
        }
        return false
    }
}
