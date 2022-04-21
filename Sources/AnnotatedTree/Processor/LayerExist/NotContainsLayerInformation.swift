//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation
import AnnotatedSentence

public class NotContainsLayerInformation : LeafListCondition{
    
    private var viewLayerType: ViewLayerType
    
    public init(viewLayerType: ViewLayerType){
        self.viewLayerType = viewLayerType
    }
    
    public func satisfies(leafList: [ParseNodeDrawable]) -> Bool {
        for parseNode in leafList{
            if (parseNode.getLayerData(viewLayer: .ENGLISH_WORD)?.contains("*"))!{
                switch viewLayerType {
                case .TURKISH_WORD:
                    if parseNode.getLayerData(viewLayer: viewLayerType) != nil{
                        return false
                    }
                case .PART_OF_SPEECH, .INFLECTIONAL_GROUP, .NER, .SEMANTICS, .PROPBANK:
                    if parseNode.getLayerData(viewLayer: viewLayerType) != nil && IsTurkishLeafNode().satisfies(parseNode: parseNode){
                        return false
                    }
                default:
                    break
                }
            }
        }
        return true
    }
}
