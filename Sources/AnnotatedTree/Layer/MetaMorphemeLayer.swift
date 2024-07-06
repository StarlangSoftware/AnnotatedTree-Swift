//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 12.04.2022.
//

import Foundation
import MorphologicalAnalysis

public class MetaMorphemeLayer : MetaMorphemesMovedLayer{
    
    /// Constructor for the metamorpheme layer. Sets the metamorpheme information for multiple words in the node.
    /// - Parameter layerValue: Layer value for the metamorpheme information. Consists of metamorpheme information of multiple words separated via space character.
    override init(layerValue: String) {
        super.init(layerValue: layerValue)
        self.layerName = "metaMorphemes"
    }
    
    /// Sets the layer value to the string form of the given parse.
    /// - Parameter parse: New metamorphic parse.
    public func setLayerValue(parse: MetamorphicParse){
        layerValue = parse.description()
        let splitWords = layerValue.split(separator: " ").map(String.init)
        for word in splitWords {
            self.items.append(MetamorphicParse(parse: word))
        }
    }
    
    /// Constructs metamorpheme information starting from the position index.
    /// - Parameter index: Position of the morpheme to start.
    /// - Returns: Metamorpheme information starting from the position index.
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
    
    /// Removes metamorphemes from the given index. Index shows the position of the metamorpheme in the metamorphemes list.
    /// - Parameter index: Position of the metamorpheme from which the other metamorphemes will be removed.
    /// - Returns: New metamorphic parse not containing the removed parts.
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
