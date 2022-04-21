//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsNodeWithPredicate : IsNodeWithSynSetId{
    
    override init(id: String){
        super.init(id: id)
    }
    
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        let layerInfo = parseNode.getLayerInfo()
        return super.satisfies(parseNode: parseNode) && layerInfo.getLayerData(viewLayer: .PROPBANK) != nil && layerInfo.getLayerData(viewLayer: .PROPBANK) == "PREDICATE"
    }
}
