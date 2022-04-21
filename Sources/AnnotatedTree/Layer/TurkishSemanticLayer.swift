//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation

public class TurkishSemanticLayer : MultiWordLayer<String>{
    
    init(layerValue: String){
        super.init()
        layerName = "semantics"
        setLayerValue(layerValue: layerValue)
    }
    
    public func setLayerValue(layerValue: String?){
        self.layerValue = layerValue!
        if layerValue != nil{
            let splitMeanings = layerValue?.split(separator: "$").map(String.init)
            items.append(contentsOf: splitMeanings!)
        }
    }
}
