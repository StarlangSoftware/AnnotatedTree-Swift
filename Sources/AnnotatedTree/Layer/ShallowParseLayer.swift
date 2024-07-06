//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation

public class ShallowParseLayer : MultiWordLayer<String>{
    
    /// Constructor for the shallow parse layer. Sets shallow parse information for each word in
    /// the node.
    /// - Parameter layerValue: Layer value for the shallow parse information. Consists of shallow parse information
    ///                   for every word.
    init(layerValue: String){
        super.init()
        layerName = "shallowParse"
        setLayerValue(layerValue: layerValue)
    }
    
    /// Sets the value for the shallow parse layer in a node. Value may consist of multiple shallow parse information
    /// separated via space character. Each shallow parse value is a string.
    /// - Parameter layerValue: New layer info
    public func setLayerValue(layerValue: String?){
        self.layerValue = layerValue!
        if layerValue != nil{
            let splitWords = layerValue?.split(separator: " ").map(String.init)
            items.append(contentsOf: splitWords!)
        }
    }
}
