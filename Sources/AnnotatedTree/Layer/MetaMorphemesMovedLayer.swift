//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 12.04.2022.
//

import Foundation
import MorphologicalAnalysis
import AnnotatedSentence

public class MetaMorphemesMovedLayer : MultiWordMultiItemLayer<MetamorphicParse> {
    
    init(layerValue: String) {
        super.init()
        self.layerName = "metaMorphemesMoved"
        setLayerValue(layerValue: layerValue)
    }
    
    public func setLayerValue(layerValue: String?){
        self.layerValue = layerValue!
        if layerValue != nil{
            let splitWords = layerValue?.split(separator: " ").map(String.init)
            for word in splitWords! {
                self.items.append(MetamorphicParse(parse: word))
            }
        }
    }
    
    public override func getLayerSize(viewLayer: ViewLayerType) -> Int{
        var layerSize = 0
        for parse in items{
            layerSize = layerSize + parse.size()
        }
        return layerSize
    }
    
    public override func getLayerInfoAt(viewLayer: ViewLayerType, index: Int) -> String?{
        var size = 0
        for parse in items{
            if index < size + parse.size(){
                return parse.getMetaMorpheme(index: index - size)
            }
            size += parse.size()
        }
        return nil
    }
}
