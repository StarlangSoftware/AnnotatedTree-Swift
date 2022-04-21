//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsNodeWithSynSetId : IsLeafNode{
    
    private var id: String
    
    init(id: String){
        self.id = id
    }
    
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
