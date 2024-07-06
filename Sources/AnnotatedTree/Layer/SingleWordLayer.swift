//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation

public class SingleWordLayer<T> : WordLayer{
    
    /// Sets the property of the word
    /// - Parameter layerValue: Layer info
    public func setLayerValue(layerValue: String){
        self.layerValue = layerValue
    }
}
