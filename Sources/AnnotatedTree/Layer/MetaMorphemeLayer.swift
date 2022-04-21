//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 12.04.2022.
//

import Foundation
import MorphologicalAnalysis

public class MetaMorphemeLayer : MetaMorphemesMovedLayer{
    
    override init(layerValue: String) {
        super.init(layerValue: layerValue)
        self.layerName = "metaMorphemes"
    }
    
    public func setLayerValue(parse: MetamorphicParse){
        layerValue = parse.description()
        let splitWords = layerValue.split(separator: " ").map(String.init)
        for word in splitWords {
            self.items.append(MetamorphicParse(parse: word))
        }
    }
    
    public func getLayerInfoFrom(index: Int) -> String?{
        var size = 0
        var newIndex = index
        for parse in items{
            if newIndex < size + parse.size(){
                var result = parse.getMetaMorpheme(index: newIndex - size)
                newIndex = newIndex + 1
                while newIndex < size + parse.size(){
                    result = result + "+" + parse.getMetaMorpheme(index: newIndex - size)
                    newIndex = newIndex + 1
                }
                return result
            }
            size = size + parse.size()
        }
        return nil
    }
    
    public func metaMorphemeRemoveFromIndex(index : Int) -> MetamorphicParse?{
        if (index >= 0 && index < getLayerSize(viewLayer: .META_MORPHEME)){
            var size = 0
            for parse in items{
                if index < size + parse.size(){
                    parse.removeMetaMorphemeFromIndex(index: index - size)
                    return parse
                }
                size = size + parse.size()
            }
        }
        return nil
    }
}
