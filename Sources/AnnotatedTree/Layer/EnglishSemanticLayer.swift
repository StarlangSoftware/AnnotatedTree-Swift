//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 12.04.2022.
//

import Foundation

public class EnglishSemanticLayer : SingleWordLayer<String>{
    
    /// Constructor for the semantic layer for English language. Sets the layer value to the synset id defined in English
    /// WordNet.
    /// - Parameter layerValue: Value for the English semantic layer.
    init(layerValue: String) {
        super.init()
        self.layerName = "englishSemantics"
        setLayerValue(layerValue: layerValue)
    }
}
