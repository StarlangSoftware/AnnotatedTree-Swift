//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsNodeWithPredicate : IsNodeWithSynSetId{
    
    /// Stores the synset id to check.
    /// - Parameter id: Synset id to check
    public override init(id: String){
        super.init(id: id)
    }
    
    /// Checks if at least one of the semantic ids of the parse node is equal to the given id and also the node is
    /// annotated as PREDICATE with semantic role.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if at least one of the semantic ids of the parse node is equal to the given id and also the node is
    /// annotated as PREDICATE with semantic role, false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        let layerInfo = parseNode.getLayerInfo()
        return super.satisfies(parseNode: parseNode) && layerInfo.getLayerData(viewLayer: .PROPBANK) != nil && layerInfo.getLayerData(viewLayer: .PROPBANK) == "PREDICATE"
    }
}
