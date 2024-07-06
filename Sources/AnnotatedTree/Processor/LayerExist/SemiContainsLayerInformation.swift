//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation
import AnnotatedSentence

public class SemiContainsLayerInformation : LeafListCondition{
    
    private var viewLayerType: ViewLayerType
    
    /// Constructor for SemiContainsLayerInformation class. Sets the viewLayerType attribute.
    /// - Parameter viewLayerType: Layer for which check is done.
    public init(viewLayerType: ViewLayerType){
        self.viewLayerType = viewLayerType
    }
    
    /// Checks if some (but not all) of the leaf nodes in the leafList contains the given layer information.
    /// - Parameter leafList: Array list storing the leaf nodes.
    /// - Returns: True if some (but not all) of the leaf nodes in the leafList contains the given layer information, false
    /// otherwise.
    public func satisfies(leafList: [ParseNodeDrawable]) -> Bool {
        var notDone : Int = 0, done : Int = 0
        for parseNode in leafList{
            if !(parseNode.getLayerData(viewLayer: .ENGLISH_WORD)?.contains("*"))!{
                switch viewLayerType {
                case .TURKISH_WORD:
                    if parseNode.getLayerData(viewLayer: viewLayerType) != nil{
                        done = done + 1
                    } else {
                        notDone = notDone + 1
                    }
                case .PART_OF_SPEECH, .INFLECTIONAL_GROUP, .NER, .SEMANTICS, .PROPBANK:
                    if IsTurkishLeafNode().satisfies(parseNode: parseNode) {
                        if parseNode.getLayerData(viewLayer: viewLayerType) != nil{
                            done = done + 1
                        } else {
                            notDone = notDone + 1
                        }
                    }
                default:
                    break
                }
            }
        }
        return done != 0 && notDone != 0
    }

}
