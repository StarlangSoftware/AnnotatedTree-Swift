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
    
    /// Constructor for the metaMorphemesMoved layer. Sets the metamorpheme information for multiple words in the node.
    /// - Parameter layerValue: Layer value for the metaMorphemesMoved information. Consists of metamorpheme information of multiple words separated via space character.
    init(layerValue: String) {
        super.init()
        self.layerName = "metaMorphemesMoved"
        setLayerValue(layerValue: layerValue)
    }
    
    /// Sets the layer value to the string form of the given parse.
    /// - Parameter layerValue: New metamorphic parse.
    public func setLayerValue(layerValue: String?){
        self.layerValue = layerValue!
        if layerValue != nil{
            let splitWords = layerValue?.split(separator: " ").map(String.init)
            for word in splitWords! {
                self.items.append(MetamorphicParse(parse: word))
            }
        }
    }
    
    /// Returns the total number of metamorphemes in the words in the node.
    /// - Parameter viewLayer: Not used.
    /// - Returns: Total number of metamorphemes in the words in the node.
    public override func getLayerSize(viewLayer: ViewLayerType) -> Int{
        var layerSize = 0
        for parse in items{
            layerSize = layerSize + parse.size()
        }
        return layerSize
    }
    
    /// Returns the metamorpheme at position index in the metamorpheme list.
    /// - Parameters:
    ///   - viewLayer: Not used.
    ///   - index: Position in the metamorpheme list.
    /// - Returns: The metamorpheme at position index in the metamorpheme list.
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
