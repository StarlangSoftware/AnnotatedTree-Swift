//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation

public class SourceLanguageWordLayer : SingleWordLayer<String>{
    
    init(layerValue: String) {
        super.init()
        self.setLayerValue(layerValue: layerValue)
    }
}
