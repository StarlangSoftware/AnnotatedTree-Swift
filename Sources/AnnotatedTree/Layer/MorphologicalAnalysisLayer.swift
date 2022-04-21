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
    
    init(layerValue: String){
        super.init()
        layerName = "morphologicalAnalysis"
        setLayerValue(layerValue: layerValue)
    }
    
    public func setLayerValue(layerValue: String?){
        self.layerValue = layerValue!
        if layerValue != nil{
            let splitWords = layerValue?.split(separator: " ").map(String.init)
            for word in splitWords! {
                self.items.append(MorphologicalParse(parse: word))
            }
        }
    }
    
    public func setLayerValue(parse: MorphologicalParse){
        self.layerValue = parse.getTransitionList()
        items.append(parse)
    }
    
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
