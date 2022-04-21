//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation

public class ShallowParseLayer : MultiWordLayer<String>{
    
    init(layerValue: String){
        super.init()
        layerName = "shallowParse"
        setLayerValue(layerValue: layerValue)
    }
    
    public func setLayerValue(layerValue: String?){
        self.layerValue = layerValue!
        if layerValue != nil{
            let splitWords = layerValue?.split(separator: " ").map(String.init)
            items.append(contentsOf: splitWords!)
        }
    }
}
