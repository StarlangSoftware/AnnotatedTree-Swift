//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation
import AnnotatedSentence

public class TargetLanguageWordLayer : MultiWordLayer<String>{
    
    init(layerValue: String){
        super.init()
        self.setLayerValue(layerValue: layerValue)
    }
    
    public func setLayerValue(layerValue: String?){
        self.layerValue = layerValue!
        if (layerValue != nil){
            let splitWords = layerValue?.split(separator: " ").map(String.init)
            self.items.append(contentsOf: splitWords!)
        }
    }
    
    public func getLayerSize(viewLayer: ViewLayerType) -> Int{
        return 0
    }
    
    public func getLayerInfoAt(viewLayer: ViewLayerType, index: Int) -> String{
        return ""
    }
}
