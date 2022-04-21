//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation
import AnnotatedSentence

public class LeafToLanguageConverter : LeafToStringConverter{
    var viewLayerType: ViewLayerType = .TURKISH_WORD
    
    public func leafConverter(leafNode: ParseNodeDrawable) -> String {
        let layerData = leafNode.getLayerData(viewLayer: viewLayerType)
        let parentLayerData = (leafNode.getParent() as! ParseNodeDrawable).getLayerData(viewLayer: viewLayerType)
        if layerData != nil{
            if (layerData?.contains("*"))! || (layerData == "0" && parentLayerData == "-NONE-"){
                return ""
            } else {
                return " " + (layerData?.replacingOccurrences(of: "-LRB-", with: "(").replacingOccurrences(of: "-RRB-", with: ")").replacingOccurrences(of: "-LSB-", with: "[").replacingOccurrences(of: "-RSB-", with: "]").replacingOccurrences(of: "-LCB-", with: "{").replacingOccurrences(of: "-RCB-", with: "}").replacingOccurrences(of: "-lrb-", with: "(").replacingOccurrences(of: "-rrb-", with: ")").replacingOccurrences(of: "-lsb-", with: "[").replacingOccurrences(of: "-rsb-", with: "]").replacingOccurrences(of: "-lcb-", with: "{").replacingOccurrences(of: "-rcb-", with: "}"))!
            }
        } else {
            return ""
        }
    }
    
    
    
}
