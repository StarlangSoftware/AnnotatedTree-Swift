//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation
import AnnotatedSentence

public class TargetLanguageWordLayer : MultiWordLayer<String>{
    
    /// Sets the surface form(s) of the word(s) possibly separated with space.
    /// - Parameter layerValue: Surface form(s) of the word(s) possibly separated with space.
    init(layerValue: String){
        super.init()
        self.setLayerValue(layerValue: layerValue)
    }
    
    /// Sets the surface form(s) of the word(s). Value may consist of multiple surface form(s)
    /// separated via space character.
    /// - Parameter layerValue: New layer info
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
