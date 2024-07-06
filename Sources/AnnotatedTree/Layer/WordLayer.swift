//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation

public class WordLayer{
    
    var layerValue: String = ""
    var layerName: String = ""
    
    /// Accessor for the layerValue attribute.
    /// - Returns: LayerValue attribute.
    public func getLayerValue() -> String{
        return layerValue
    }
    
    /// Accessor for the layerName attribute.
    /// - Returns: LayerName attribute.
    public func getLayerName() -> String{
        return layerName
    }
    
    /// Returns string form of the word layer.
    /// - Returns: String form of the word layer.
    public func getLayerDescription() -> String{
        return "{" + layerName + "=" + layerValue + "}"
    }
}
