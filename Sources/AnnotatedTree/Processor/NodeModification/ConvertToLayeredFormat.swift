//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class ConvertToLayeredFormat : NodeModifier{
    
    public func modifier(parseNode: ParseNodeDrawable) {
        if parseNode.isLeaf(){
            let name = parseNode.getData()?.getName()
            parseNode.clearLayers()
            parseNode.getLayerInfo().setLayerData(viewLayer: .ENGLISH_WORD, layerValue: name!)
            parseNode.clearData()
        }
    }
}
