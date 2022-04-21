//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class LeafToRootFormConverter : LeafToStringConverter{
    
    public func leafConverter(leafNode: ParseNodeDrawable) -> String {
        let layerInfo = leafNode.getLayerInfo()
        var rootWords : String = " "
        for i in 0..<layerInfo.getNumberOfWords(){
            let root = layerInfo.getMorphologicalParseAt(index: i)?.getWord().getName()
            if root != nil && root != ""{
                rootWords = rootWords + " " + root!
            }
        }
        return rootWords
    }
}
