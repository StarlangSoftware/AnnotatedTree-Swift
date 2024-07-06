//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation

public class SourceLanguageWordLayer : SingleWordLayer<String>{
    
    /// Sets the name of the word
    /// - Parameter layerValue: Name of the word
    init(layerValue: String) {
        super.init()
        self.setLayerValue(layerValue: layerValue)
    }
}
