//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsNodeWithSynSetId : IsLeafNode{
    
    private var id: String
    
    /// Stores the synset id to check.
    /// - Parameter id: Synset id to check
    public init(id: String){
        self.id = id
    }
    
    /// Checks if at least one of the semantic ids of the parse node is equal to the given id.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if at least one of the semantic ids of the parse node is equal to the given id, false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            let layerInfo = parseNode.getLayerInfo()
            for i in 0..<layerInfo.getNumberOfMeanings(){
                let synSetId = layerInfo.getSemanticAt(index: i)
                if synSetId == id{
                    return true
                }
            }
        }
        return false
    }
}
