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
    
    public init(wordNet: WordNet){
        self.wordNet = wordNet
    }
    
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
