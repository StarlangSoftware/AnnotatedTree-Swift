//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation
import MorphologicalAnalysis
import AnnotatedSentence

public class MorphologicalAnalysisLayer : MultiWordMultiItemLayer<MorphologicalParse>{
    
    /// Constructor for the morphological analysis layer. Sets the morphological parse information for multiple words in
    /// the node.
    /// - Parameter layerValue: Layer value for the morphological parse information. Consists of morphological parse information of multiple words separated via space character.
    init(layerValue: String){
        super.init()
        layerName = "morphologicalAnalysis"
        setLayerValue(layerValue: layerValue)
    }
    
    /// Sets the layer value to the string form of the given morphological parse.
    /// - Parameter layerValue: New morphological parse.
    public func setLayerValue(layerValue: String?){
        self.layerValue = layerValue!
        if layerValue != nil{
            let splitWords = layerValue?.split(separator: " ").map(String.init)
            for word in splitWords! {
                self.items.append(MorphologicalParse(parse: word))
            }
        }
    }
    
    /// Sets the layer value to the string form of the given morphological parse.
    /// - Parameter parse: New morphological parse.
    public func setLayerValue(parse: MorphologicalParse){
        self.layerValue = parse.getTransitionList()
        items.append(parse)
    }
    
    /// Returns the total number of morphological tags (for PART_OF_SPEECH) or inflectional groups
    /// (for INFLECTIONAL_GROUP) in the words in the node.
    /// - Parameter viewLayer: Layer type.
    /// - Returns: Total number of morphological tags (for PART_OF_SPEECH) or inflectional groups (for INFLECTIONAL_GROUP)
    /// in the words in the node.
    public override func getLayerSize(viewLayer: ViewLayerType) -> Int{
        switch viewLayer {
        case .PART_OF_SPEECH:
            var size = 0
            for parse in items{
                size = size + parse.tagSize()
            }
            return size
        case .INFLECTIONAL_GROUP:
            var size = 0
            for parse in items{
                size = size + parse.size()
            }
            return size
        default:
            return 0
        }
    }
    
    /// Returns the morphological tag (for PART_OF_SPEECH) or inflectional group (for INFLECTIONAL_GROUP) at position
    /// index.
    /// - Parameters:
    ///   - viewLayer: Layer type.
    ///   - index: Position of the morphological tag (for PART_OF_SPEECH) or inflectional group (for INFLECTIONAL_GROUP)
    /// - Returns: The morphological tag (for PART_OF_SPEECH) or inflectional group (for INFLECTIONAL_GROUP)
    public override func getLayerInfoAt(viewLayer: ViewLayerType, index: Int) -> String?{
        switch viewLayer {
        case .PART_OF_SPEECH:
            var size = 0
            for parse in items{
                if (index < size + parse.tagSize()){
                    return parse.getTag(index: index - size)
                }
                size = size + parse.tagSize()
            }
            return nil
        case .INFLECTIONAL_GROUP:
            var size = 0
            for parse in items{
                if (index < size + parse.size()){
                    return parse.getInflectionalGroupString(index: index - size)
                }
                size = size + parse.size()
            }
            return nil
        default:
            return nil
        }
    }
}
