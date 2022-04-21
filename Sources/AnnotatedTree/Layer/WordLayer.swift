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
    
    public func getLayerValue() -> String{
        return layerValue
    }
    
    public func getLayerName() -> String{
        return layerName
    }
    
    public func getLayerDescription() -> String{
        return "{" + layerName + "=" + layerValue + "}"
    }
}
