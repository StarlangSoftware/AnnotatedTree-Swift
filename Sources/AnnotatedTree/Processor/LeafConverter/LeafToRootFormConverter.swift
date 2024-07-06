//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class LeafToRootFormConverter : LeafToStringConverter{
    
    /// Converts the data in the leaf node to string. If there are multiple words in the leaf node, they are concatenated
    /// with space.
    /// - Parameter leafNode: Node to be converted to string.
    /// - Returns: String form of the data. If there are multiple words in the leaf node, they are concatenated
    /// with space.
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
